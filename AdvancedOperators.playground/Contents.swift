import UIKit

/*:
 # Advanced Operators in Swift

 ## Definition
 Swift provides **advanced operators** for complex value manipulation beyond basic arithmetic, including bitwise and bit shifting operations. Unlike C, Swift's arithmetic operators **do not overflow by default**; they trap and report errors. To explicitly allow overflow, Swift offers a special set of **overflow operators** (e.g., `&+`, `&-`, `&*`), all prefixed with an ampersand (`&`).

 Furthermore, Swift allows you to **overload standard operators** for custom types (structs, classes, enums) and even **define your own custom operators** with specific precedence and associativity.

 ---

 ## Bitwise Operators

 **Bitwise operators** allow you to manipulate individual raw data bits within a number. They are commonly used in low-level programming, graphics, and custom data protocols. Swift supports the following bitwise operators, similar to C:

 */
print("--- Bitwise Operators ---")

// Define a UInt8 for examples (8 bits)
let eightBitValue: UInt8 = 0b00001111 // Decimal 15

// ### Bitwise NOT Operator (~)
// Inverts all bits (0 becomes 1, 1 becomes 0).
let invertedBits = ~eightBitValue
print("Original: \(String(eightBitValue, radix: 2)) (\(eightBitValue))")
print("NOT (~):  \(String(invertedBits, radix: 2)) (\(invertedBits))") // 11110000 (240)

// ---
// ### Bitwise AND Operator (&)
// Returns 1 if bits in *both* input numbers are 1.
let firstSet: UInt8 = 0b11110000 // 240
let secondSet: UInt8 = 0b00111100 // 60
let andResult = firstSet & secondSet
print("\nFirst Set:  \(String(firstSet, radix: 2))")
print("Second Set: \(String(secondSet, radix: 2))")
print("AND (&):    \(String(andResult, radix: 2)) (\(andResult))") // 00110000 (48)

// ---
// ### Bitwise OR Operator (|)
// Returns 1 if bits in *either* input number are 1.
let orResult = firstSet | secondSet
print("\nFirst Set:  \(String(firstSet, radix: 2))")
print("Second Set: \(String(secondSet, radix: 2))")
print("OR (|):     \(String(orResult, radix: 2)) (\(orResult))") // 11111100 (252)

// ---
// ### Bitwise XOR Operator (^)
// Returns 1 if bits in input numbers are *different* (exclusive OR).
let xorResult = firstSet ^ secondSet
print("\nFirst Set:  \(String(firstSet, radix: 2))")
print("Second Set: \(String(secondSet, radix: 2))")
print("XOR (^):    \(String(xorResult, radix: 2)) (\(xorResult))") // 11001100 (204)

// ---
// ### Bitwise Left (<<) and Right (>>) Shift Operators
// Move bits left or right, effectively multiplying or dividing by powers of two.
// For unsigned integers, zeros are inserted on the empty side (logical shift).
let shiftValue: UInt8 = 0b00001010 // 10

let shiftedLeft = shiftValue << 2 // Shift left by 2 positions
print("\nOriginal:    \(String(shiftValue, radix: 2)) (\(shiftValue))")
print("Shift left:  \(String(shiftedLeft, radix: 2)) (\(shiftedLeft))") // 00101000 (40)

let shiftedRight = shiftValue >> 1 // Shift right by 1 position
print("Shift right: \(String(shiftedRight, radix: 2)) (\(shiftedRight))") // 00000101 (5)

// Example: Decomposing a color value
let pinkColor: UInt32 = 0xCC6699 // Hexadecimal color
let redComponent = (pinkColor & 0xFF0000) >> 16 // Mask red, then shift
let greenComponent = (pinkColor & 0x00FF00) >> 8 // Mask green, then shift
let blueComponent = pinkColor & 0x0000FF         // Mask blue

print("\nColor Decomposition:")
print("Pink:      0x\(String(pinkColor, radix: 16))")
print("Red:       0x\(String(redComponent, radix: 16)) (\(redComponent))") // 0xCC (204)
print("Green:     0x\(String(greenComponent, radix: 16)) (\(greenComponent))") // 0x66 (102)
print("Blue:      0x\(String(blueComponent, radix: 16)) (\(blueComponent))") // 0x99 (153)

/*:
 ---

 ## Overflow Operators

 Swift's standard arithmetic operators prevent **integer overflow** by default, reporting an error if the result exceeds the type's capacity. To explicitly allow overflow and have the value **wrap around**, use the overflow operators: `&+` (addition), `&-` (subtraction), and `&*` (multiplication).

 */
print("\n--- Overflow Operators ---")

var maxUInt8 = UInt8.max // 255 (11111111)
print("UInt8 Max: \(maxUInt8)")
maxUInt8 = maxUInt8 &+ 1 // Wraps around to 0
print("UInt8 Max &+ 1: \(maxUInt8)") // 0 (00000000)

var minUInt8 = UInt8.min // 0 (00000000)
print("UInt8 Min: \(minUInt8)")
minUInt8 = minUInt8 &- 1 // Wraps around to 255
print("UInt8 Min &- 1: \(minUInt8)") // 255 (11111111)

var minInt8 = Int8.min // -128 (10000000 in two's complement)
print("Int8 Min: \(minInt8)")
minInt8 = minInt8 &- 1 // Wraps around to 127
print("Int8 Min &- 1: \(minInt8)") // 127 (01111111)

/*:
 ---

 ## Operator Methods (Overloading Existing Operators)

 You can provide custom implementations for standard Swift operators for your own custom types (structs, classes, enums). This is known as **operator overloading**.

 */
print("\n--- Operator Methods (Overloading) ---")

struct Vector2D {
    var x = 0.0, y = 0.0
}

extension Vector2D {
    // ### Infix Operator (+)
    // Overloading the addition operator for Vector2D
    static func + (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y + right.y)
    }

    // ### Prefix Operator (-)
    // Overloading the unary minus operator for Vector2D
    static prefix func - (vector: Vector2D) -> Vector2D {
        return Vector2D(x: -vector.x, y: -vector.y)
    }

    // ### Compound Assignment Operator (+=)
    // Overloading the addition assignment operator.
    // The left parameter is marked `inout` because its value is modified directly.
    static func += (left: inout Vector2D, right: Vector2D) {
        left = left + right // Reuses the custom + operator
    }
}

// Example usage of overloaded operators
let vec1 = Vector2D(x: 3.0, y: 1.0)
let vec2 = Vector2D(x: 2.0, y: 4.0)

let combinedVec = vec1 + vec2
print("Vector1 + Vector2: (\(combinedVec.x), \(combinedVec.y))") // (5.0, 5.0)

let negatedVec = -vec1
print("Negated Vector1:   (\(negatedVec.x), \(negatedVec.y))")   // (-3.0, -1.0)

var mutableVec = Vector2D(x: 1.0, y: 2.0)
let addendVec = Vector2D(x: 3.0, y: 4.0)
mutableVec += addendVec
print("Mutable Vector += Addend: (\(mutableVec.x), \(mutableVec.y))") // (4.0, 6.0)

/*:
 ### Equivalence Operators (== and !=)

 Custom types do not automatically get `==` or `!=`. You usually implement `==` and Swift can provide `!=` for you, by conforming to the `Equatable` protocol.

 */
extension Vector2D: Equatable {
    static func == (left: Vector2D, right: Vector2D) -> Bool {
        return (left.x == right.x) && (left.y == right.y)
    }
}

let vA = Vector2D(x: 1.0, y: 1.0)
let vB = Vector2D(x: 1.0, y: 1.0)
let vC = Vector2D(x: 2.0, y: 2.0)

print("vA == vB: \(vA == vB)") // true
print("vA == vC: \(vA == vC)") // false

/*:
 ---

 ## Custom Operators

 Swift allows you to define your own **custom operators** using the `operator` keyword, specifying them as `prefix`, `infix`, or `postfix`.

 */
print("\n--- Custom Operators ---")

// ### Custom Prefix Operator (+++)
prefix operator +++

extension Vector2D {
    // Define the behavior of the custom prefix operator
    static prefix func +++ (vector: inout Vector2D) -> Vector2D {
        vector += vector // Uses our custom += operator
        return vector
    }
}

var originalVec = Vector2D(x: 1.0, y: 4.0)
let doubledVec = +++originalVec
print("Original vector: (\(originalVec.x), \(originalVec.y))")   // (2.0, 8.0)
print("Doubled vector:  (\(doubledVec.x), \(doubledVec.y))")    // (2.0, 8.0)

// ### Custom Infix Operator (+-) with Precedence
// Custom infix operators belong to a Precedence Group.
// `AdditionPrecedence` means it behaves like `+` and `-`.
infix operator +-: AdditionPrecedence

extension Vector2D {
    static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
        return Vector2D(x: left.x + right.x, y: left.y - right.y)
    }
}

let vecA = Vector2D(x: 10.0, y: 5.0)
let vecB = Vector2D(x: 3.0, y: 2.0)
let resultVec = vecA +- vecB
print("Custom infix (+-): (\(resultVec.x), \(resultVec.y))") // (13.0, 3.0)

/*:
 ---

 ## Result Builders

 **Result builders** (formerly known as function builders) are types that add special syntax for creating nested data (like lists or trees) in a more natural, declarative way, often leveraging ordinary Swift control flow (like `if` and `for`).

 */
print("\n--- Result Builders ---")

protocol Drawable {
    func draw() -> String
}

struct Line: Drawable {
    var elements: [Drawable]
    func draw() -> String {
        return elements.map { $0.draw() }.joined(separator: "")
    }
}

struct Text: Drawable {
    var content: String
    init(_ content: String) { self.content = content }
    func draw() -> String { return content }
}

struct Space: Drawable {
    func draw() -> String { return " " }
}

struct Stars: Drawable {
    var length: Int
    func draw() -> String { return String(repeating: "*", count: length) }
}

struct AllCaps: Drawable {
    var content: Drawable
    func draw() -> String { return content.draw().uppercased() }
}

@resultBuilder
struct DrawingBuilder {
    // Required: Combines multiple Drawable components into a single Drawable (often a Line)
    static func buildBlock(_ components: Drawable...) -> Drawable {
        return Line(elements: components)
    }

    // Supports `if` statements
    static func buildEither(first: Drawable) -> Drawable { return first }
    static func buildEither(second: Drawable) -> Drawable { return second }

    // Supports `for` loops
    static func buildArray(_ components: [Drawable]) -> Drawable {
        return Line(elements: components)
    }
}

// Function that uses the result builder for its closure parameter
func buildMyDrawing(@DrawingBuilder content: () -> Drawable) -> Drawable {
    return content()
}

func makeComplexGreeting(name: String? = nil) -> Drawable {
    let greeting = buildMyDrawing { // This block uses the DrawingBuilder syntax
        Stars(length: 3)
        Text("Hello")
        Space()
        AllCaps(content: buildMyDrawing { // Nested builder usage
            if let name = name {
                Text(name + "!")
            } else {
                Text("World!")
            }
        })
        Stars(length: 2)

        // Example with for loop due to buildArray
        for _ in 0..<2 {
            Space()
            Stars(length: 1)
        }
    }
    return greeting
}

let simpleGreeting = makeComplexGreeting()
print("Simple greeting: \(simpleGreeting.draw())") // "***Hello WORLD!* *"

let personalizedGreeting = makeComplexGreeting(name: "Gemini")
print("Personalized greeting: \(personalizedGreeting.draw())") // "***Hello GEMINI!* *"

/*:
 ---

 Swift's advanced operators provide powerful tools for low-level data manipulation, custom type behavior, and expressive, declarative syntax. They enhance code clarity and allow you to tailor the language to your specific needs.
 */
