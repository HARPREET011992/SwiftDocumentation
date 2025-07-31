///*:
// # Opaque Types and Boxed Protocol Types
//
// Swift provides two powerful mechanisms to hide type details: **Opaque Types** and **Boxed Protocol Types**. These are especially useful when defining the public interface of a module, allowing the underlying implementation types to remain private.
//
// ## Definitions
//
// -   **Opaque Type (`some ProtocolName`):**
//    -   Hides the specific concrete type of a return value, exposing it only in terms of the protocols it conforms to.
//    -   **Preserves Type Identity:** The compiler *knows* the exact underlying type, but the client code does not. This means only *one specific type* is returned, even if that type is complex or involves generics itself.
//    -   Example: `func makeShape() -> some Shape`
//
// -   **Boxed Protocol Type (`any ProtocolName`):**
//    -   Can store an instance of *any type* that conforms to the given protocol.
//    -   **Does Not Preserve Type Identity:** The value's specific type is only known at runtime, and it can vary (different types can be stored in the same variable/collection over time).
//    -   Involves a "box" (indirection) at runtime, which can have a minor performance cost.
//    -   Example: `var shapes: [any Shape]`
//
// ---
//
// ## The Problem that Opaque Types Solve
//
// Consider building an ASCII art module. We start with a `Shape` protocol and some conforming structs:
//
// */
protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int
    func draw() -> String {
        var result: [String] = []
        for length in 1...size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}

print("--- The Problem that Opaque Types Solve ---")
let smallTriangle = Triangle(size: 3)
print("Small Triangle:")
print(smallTriangle.draw())
// Expected:
// *
// **
// ***

/*:
 To add operations like flipping or joining shapes using only generics, you end up with very complex, exposed types.

 */
struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

let flippedTriangle = FlippedShape(shape: smallTriangle)
print("\nFlipped Triangle (type: FlippedShape<Triangle>):")
print(flippedTriangle.draw())
// Expected:
// ***
// **
// *

struct JoinedShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}

let joinedTriangles = JoinedShape(top: smallTriangle, bottom: flippedTriangle)
print("\nJoined Triangles (complex type: JoinedShape<Triangle, FlippedShape<Triangle>>):")
print(joinedTriangles.draw())
// Expected:
// *
// **
// ***
// ***
// **
// *

print("\nProblem: These complex generic types (like `JoinedShape<Triangle, FlippedShape<Triangle>>`) leak implementation details of your ASCII art module to its users. Users shouldn't need to know how a shape was constructed, only that it *is* a shape.\n")

/*:
 ---

 ## Returning an Opaque Type (`some Shape`)

 Opaque types solve this by letting the *function's implementation* choose the concrete return type, while the *caller* only sees that it conforms to a protocol. This keeps implementation details private.

 */
struct Square: Shape {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}

print("--- Returning an Opaque Type (`some Protocol`) ---")

func makeTrapezoid() -> some Shape { // Returns some type that conforms to Shape
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top) // FlippedShape is still generic internally

    // The actual return type here is a deeply nested JoinedShape
    let trapezoid = JoinedShape(
        top: top,
        bottom: JoinedShape(top: middle, bottom: bottom)
    )
    return trapezoid // Compiler knows the full type, but public API hides it
}

let trapezoid = makeTrapezoid()
print("Trapezoid (returned as 'some Shape'):")
print(trapezoid.draw())
// Expected:
// *
// **
// **
// **
// **
// *

print("The user of `makeTrapezoid()` doesn't need to know its complex internal type.")
print("Even if the internal construction of the trapezoid changes, the function's return type remains `some Shape`.\n")

/*:
 **Key Characteristic:** A function returning `some Shape` *always* returns the *same specific underlying type*. If you have multiple return paths, they must all yield the same type.

 */
// This is INVALID because it could return a Square or a FlippedShape, which are different types.
// func invalidFlip<T: Shape>(_ shape: T) -> some Shape {
//     if shape is Square {
//         return shape // Return type is 'Square'
//     }
//     return FlippedShape(shape: shape) // Return type is 'FlippedShape<T>'
// }
// This will cause a compile-time error: "Function declares an opaque return type 'some Shape', but the return statements in its body do not all return the same concrete type."

// A valid way to handle the above (by making FlippedShape handle squares internally):
struct CorrectedFlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        if shape is Square {
            return shape.draw() // If it's a square, just draw it normally
        }
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

func correctedFlip<T: Shape>(_ shape: T) -> some Shape {
    return CorrectedFlippedShape(shape: shape) // Always returns CorrectedFlippedShape
}

let square = Square(size: 3)
print("Flipped Square (using correctedFlip):")
print(correctedFlip(square).draw())
// Expected:
// ***
// ***
// ***
print("")

/*:
 ---

 ## Boxed Protocol Types (`any ProtocolName`)

 A **boxed protocol type** (also called an **existential type**) can store an instance of *any type* that conforms to the given protocol. Its specific type isn't known until runtime, and it can change.

 */
print("--- Boxed Protocol Types (`any Protocol`) ---")

struct VerticalShapes: Shape {
    var shapes: [any Shape] // An array that can hold *different* types conforming to Shape
    func draw() -> String {
        return shapes.map { $0.draw() }.joined(separator: "\n\n")
    }
}

let largeTriangle = Triangle(size: 5)
let largeSquare = Square(size: 5)

let verticalStack = VerticalShapes(shapes: [largeTriangle, largeSquare])
print("Vertical Shapes (using `any Shape` array):")
print(verticalStack.draw())
// Expected:
// *
// **
// ***
// ****
// *****
//
// *****
// *****
// *****
// *****
// *****

print("\n`shapes: [any Shape]` allows `largeTriangle` (type Triangle) and `largeSquare` (type Square) to coexist in the same array, as long as they both conform to `Shape`.\n")

/*:
 **Limitations of Boxed Protocol Types:**
 -   **No Type Identity Preservation:** You lose the specific type information at compile time.
 -   **Runtime Performance Cost:** Involves indirection ("boxing") to handle values of varying sizes and types.
 -   **Limited Operations:** You can only use methods, properties, and subscripts defined by the protocol. You can't access `size` directly on an `any Shape` if `size` isn't part of the `Shape` protocol.
 -   **No `Self` or Associated Types:** Protocols with `Self` requirements or `associatedtype`s cannot be used directly as boxed protocol types (e.g., `any Equatable`, `any Container` will not work without careful consideration or specific Swift versions).

 */
// Accessing a specific property (like 'size') requires downcasting:
if let downcastTriangle = verticalStack.shapes[0] as? Triangle {
    print("Downcasted triangle size: \(downcastTriangle.size)\n") // Expected: "5"
}

/*:
 ---

 ## Differences Between Opaque Types and Boxed Protocol Types

 The core difference is **type identity preservation**.

 -   **Opaque Type (`some Protocol`)**: The compiler knows the exact type, but it's hidden from the caller. *Always* returns the same single underlying type.
 -   **Boxed Protocol Type (`any Protocol`)**: The specific type is *not* known until runtime, and the type can *vary*.

 ### Example: Nesting Transformations

 Opaque types allow nesting transformations (like `flip(flip(someShape))`) because the compiler still knows the full, concrete type chain, even if it's hidden. Boxed protocol types often break this due to type erasure.

 */
func opaqueFlip<T: Shape>(_ shape: T) -> some Shape {
    return FlippedShape(shape: shape) // Returns 'some FlippedShape<T>'
}

func opaqueJoin<T: Shape, U: Shape>(_ top: T, _ bottom: U) -> some Shape {
    return JoinedShape(top: top, bottom: bottom) // Returns 'some JoinedShape<T, U>'
}

print("--- Differences: Nesting Transformations ---")
let nestedOpaqueShape = opaqueJoin(smallTriangle, opaqueFlip(smallTriangle))
print("Nesting opaque types works:\n\(nestedOpaqueShape.draw())\n")
// Expected: (Same as joinedTriangles earlier)
// *
// **
// ***
// ***
// **
// *

// ---
// Attempting the same with a function returning 'any Shape':
func protoFlip<T: Shape>(_ shape: T) -> any Shape {
    // This *could* return different concrete types based on logic, e.g.:
    // if shape is Square { return shape }
    // else { return FlippedShape(shape: shape) }
    // But for this example, we'll keep it simple:
    return FlippedShape(shape: shape)
}

// let nestedProtoShape = protoFlip(protoFlip(smallTriangle))
// This line would cause a compile-time error:
// "Argument type 'any Shape' does not conform to expected type 'Shape'"
// because `any Shape` (the boxed protocol type) does *not* conform to `Shape` itself.

print("Nesting `any Shape` values directly would fail because `any Shape` itself does not conform to `Shape`.\n")

/*:
 ### Example: Protocols with Associated Types

 Protocols with associated types (like `Container` from our Generics playground) cannot be directly used as boxed protocol types without the `any` keyword in Swift 5.6+ due to the type information loss. Opaque types handle this naturally.

 */
protocol Container {
    associatedtype Item // Associated type
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

extension Array: Container {} // Make Array conform to Container

print("--- Differences: Associated Types ---")

// Opaque type: The compiler knows 'Item' is Int.
func makeOpaqueContainer<T>(item: T) -> some Container {
    return [item] // Underlying type is [T] (e.g., [Int])
}

let opaqueContainer = makeOpaqueContainer(item: 123)
let firstItemOpaque = opaqueContainer[0]
print("Type of item from opaque container: \(type(of: firstItemOpaque))") // Expected: "Int"

// Boxed protocol type: Cannot be directly used if protocol has associated types (without 'any')
// func makeProtoContainer<T>(item: T) -> Container { // Error before Swift 5.6
//     return [item]
// }

// With `any Container`, it works, but type information for Item is lost at the call site
func makeAnyContainer<T>(item: T) -> any Container {
    return [item]
}
let anyContainer = makeAnyContainer(item: "hello")
// let firstItemAny = anyContainer[0] // Error: Value of type 'any Container' has no subscript members
// This is because the 'Item' associated type isn't concrete at the call site.
// You would need to downcast or use other methods to access the item in a type-safe way.
print("Boxed protocol type `any Container` allows storage, but accessing `Item` directly is harder due to type erasure.")
print("You would typically access elements through methods that return `any Item` or require explicit downcasting.")
print("For example, `anyContainer.count` works, but `anyContainer[0]` requires more sophisticated handling.\n")

/*:
 **When to choose which:**

 -   **Opaque Types (`some`):**
    -   When you want to return a value of a *single, specific type* (even if complex), but you want to *hide* that type from the API users.
    -   When the protocol has `associatedtype`s or `Self` requirements.
    -   When you need to perform operations that depend on type identity (like `==` or nesting transformations).

 -   **Boxed Protocol Types (`any`):**
    -   When you need to store or return values of *different, varying concrete types* that all conform to the same protocol.
    -   When the performance cost of indirection is acceptable.
    -   When you only need to use the functionality defined directly by the protocol, and you don't need to preserve specific type information for operations like equality or chaining.

 */


