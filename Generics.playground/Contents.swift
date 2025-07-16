import UIKit

/*:
 # Generics in Swift

 ## Definition
 **Generics** in Swift enable you to write flexible, reusable functions and types that can work with **any type**, subject to requirements that you define. This powerful feature allows you to write code that avoids duplication and expresses its intent in a clear, abstracted manner.

 Many of Swift's standard library types, like `Array` and `Dictionary`, are built with generics. For example, `Array<Int>` or `Array<String>` can hold values of any specified type.

 ---

 ## The Problem that Generics Solve

 Imagine you need a function to swap two values. Without generics, you'd have to write separate functions for each type (`Int`, `String`, `Double`, etc.), even though the logic inside each function is identical. This leads to code duplication.

 */
// Nongeneric function to swap two Int values
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temporaryA = a
    a = b
    b = temporaryA
}

print("--- The Problem that Generics Solve ---")
var someInt = 3
var anotherInt = 107
swapTwoInts(&someInt, &anotherInt)
print("Ints after swap: someInt is now \(someInt), and anotherInt is now \(anotherInt)")
// Expected: "Ints after swap: someInt is now 107, and anotherInt is now 3"

func swapTwoStrings(_ a: inout String, _ b: inout String) {
    let temporaryA = a
    a = b
    b = temporaryA
}

var someString = "hello"
var anotherString = "world"
swapTwoStrings(&someString, &anotherString)
print("Strings after swap: someString is now \(someString), and anotherString is now \(anotherString)\n")
// Expected: "Strings after swap: someString is now world, and anotherString is now hello"

/*:
 Notice how `swapTwoInts` and `swapTwoStrings` have identical bodies. Generics solve this by allowing you to write a single function that works for *any* type.

 ---

 ## Generic Functions

 **Generic functions** are functions that can operate on values of any type. You define them using **type parameters**—placeholder type names (e.g., `T`) enclosed in angle brackets (`<T>`) after the function name.

 */
// Generic function to swap two values of any type 'T'
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temporaryA = a
    a = b
    b = temporaryA
}

print("--- Generic Functions ---")
var myInt = 15
var yourInt = 20
swapTwoValues(&myInt, &yourInt) // T is inferred as Int
print("Generic swap Ints: myInt is \(myInt), yourInt is \(yourInt)")

var myBool = true
var yourBool = false
swapTwoValues(&myBool, &yourBool) // T is inferred as Bool
print("Generic swap Bools: myBool is \(myBool), yourBool is \(yourBool)\n")

/*:
 **Type Parameters:**
 -   Specify and name a placeholder type (e.g., `<T>`).
 -   Can be used to define parameter types, return types, or types within the function body.
 -   Swift infers the actual type for `T` each time the function is called.
 -   You can have multiple type parameters (e.g., `<T, U>`).
 -   Conventionally, use **Upper Camel Case** names like `T`, `U`, `Key`, `Value`, `Element`.

 ---

 ## Generic Types

 Swift allows you to define your own **generic types** (classes, structures, and enumerations) that can work with any type, similar to `Array<Element>` or `Dictionary<Key, Value>`.

 */
// Example: A generic Stack structure (Last-In, First-Out collection)
struct Stack<Element> { // 'Element' is the type parameter
    var items: [Element] = [] // Stores items of type 'Element'

    mutating func push(_ item: Element) { // Accepts item of type 'Element'
        items.append(item)
    }

    mutating func pop() -> Element { // Returns item of type 'Element'
        return items.removeLast()
    }
}

print("--- Generic Types ---")
var stackOfStrings = Stack<String>() // Create a Stack that holds Strings
stackOfStrings.push("Swift")
stackOfStrings.push("Generics")
stackOfStrings.push("Are")
stackOfStrings.push("Cool")

print("Popping from stack: \(stackOfStrings.pop())") // Expected: "Cool"
print("Stack size: \(stackOfStrings.items.count)\n") // Expected: 3

/*:
 ### Extending a Generic Type

 You can extend a generic type without providing a type parameter list in the extension's definition. The original type parameter names are available within the extension's body.

 */
extension Stack {
    var topItem: Element? { // Element is available from the original Stack definition
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

print("--- Extending a Generic Type ---")
if let top = stackOfStrings.topItem {
    print("Top item on stack: \(top)\n") // Expected: "Are"
}

/*:
 ---

 ## Type Constraints

 Sometimes, you need to restrict the types that can be used with generic functions or types. **Type constraints** specify that a type parameter must inherit from a specific class or conform to a particular protocol (or a composition of protocols).

 This is crucial for functionality like comparison (`==`) or hashing, which aren't universally available for all types.

 */
// Example: findIndex function
// This function requires 'T' to be Equatable, so we can use '==' for comparison
func findIndex<T: Equatable>(of valueToFind: T, in array: [T]) -> Int? {
    for (index, value) in array.enumerated() {
        if value == valueToFind { // '==' operator is available because T: Equatable
            return index
        }
    }
    return nil
}

print("--- Type Constraints ---")
let numbers = [10, 20, 30, 40, 50]
if let index = findIndex(of: 30, in: numbers) {
    print("Index of 30: \(index)") // Expected: 2
} else {
    print("30 not found.")
}

let names = ["Alice", "Bob", "Charlie"]
if let index = findIndex(of: "Bob", in: names) {
    print("Index of 'Bob': \(index)\n") // Expected: 1
} else {
    print("'Bob' not found.")
}

/*:
 **Type Constraint Syntax:**
 -   Placed after a type parameter's name, separated by a colon (e.g., `<T: SomeClass, U: SomeProtocol>`).
 -   Multiple constraints for a single type parameter can be listed, separated by `&` (e.g., `<T: Hashable & Codable>`).

 ---

 ## Associated Types

 When defining a protocol, you can declare one or more **associated types**. These are placeholder names for types that are used as part of the protocol's definition. The actual type is specified only when a conforming type adopts the protocol. They are declared with the `associatedtype` keyword.

 */
protocol Container {
    associatedtype Item // Placeholder for the type of elements the container holds
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

// Example: Stack conforming to Container
extension Stack: Container {
    var count: Int {
        return items.count
    }
    
    subscript(i: Int) -> Element {
        return items[i]
    }
    // Reusing the generic Stack from earlier
    // Swift infers 'Item' to be 'Element' from the existing methods
    // We don't need 'typealias Item = Element' explicitly here
    mutating func append(_ item: Element) {
        self.push(item) // Reuses Stack's push method
    }

    // count and subscript are already implemented by Array and are available directly
    // var count: Int { return items.count }
    // subscript(i: Int) -> Element { return items[i] }
}

print("--- Associated Types ---")
var myIntStack = Stack<Int>()
myIntStack.append(1)
myIntStack.append(2)
print("Int Stack count: \(myIntStack.count)") // Expected: 2
print("First item in Int Stack: \(myIntStack[0])\n") // Expected: 1

/*:
 ### Adding Constraints to an Associated Type

 You can add type constraints to an associated type within a protocol.

 */
protocol EquatableContainer {
    associatedtype Item: Equatable // Item must conform to Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

// Example: A simple Array wrapper that needs Equatable items
struct MyEquatableArray<T: Equatable>: EquatableContainer {
    var elements: [T] = []

    mutating func append(_ item: T) {
        elements.append(item)
    }

    var count: Int {
        return elements.count
    }

    subscript(i: Int) -> T {
        return elements[i]
    }
}

print("--- Associated Types with Constraints ---")
var eqArray = MyEquatableArray<String>()
eqArray.append("One")
eqArray.append("Two")
print("Equatable array count: \(eqArray.count)\n")

/*:
 ---

 ## Generic Where Clauses

 A **generic `where` clause** allows you to define additional requirements for associated types or to specify equality relationships between types and associated types. It starts with the `where` keyword, typically placed right before the opening curly brace of a type or function's body.

 */
// IMPORTANT: Extend Array to conform to Container so allItemsMatch can use it
extension Array: Container {
    // Swift infers 'Item' to be 'Element' (e.g., String for [String])
    // append, count, and subscript are already provided by Array
}

// Function to compare two containers, even if they are different types, as long as their items match
func allItemsMatch<C1: Container, C2: Container>(
    _ someContainer: C1, _ anotherContainer: C2
) -> Bool where C1.Item == C2.Item, C1.Item: Equatable {
    // Both containers must hold the same 'Item' type, and that 'Item' must be Equatable.

    // Check that both containers contain the same number of items.
    if someContainer.count != anotherContainer.count {
        return false
    }

    // Check each pair of items to see if they're equivalent.
    for i in 0..<someContainer.count {
        if someContainer[i] != anotherContainer[i] { // Uses '!=' from Equatable constraint
            return false
        }
    }

    // All items match, so return true.
    return true
}

print("--- Generic Where Clauses ---")
var myStringStack = Stack<String>()
myStringStack.push("apple")
myStringStack.push("banana")
myStringStack.push("cherry")

// Array now explicitly conforms to Container thanks to the extension above
let stringArray = ["apple", "banana", "cherry"]

if allItemsMatch(myStringStack, stringArray) {
    print("Stack and Array contain matching items.") // Expected: "Stack and Array contain matching items."
} else {
    print("Stack and Array do NOT contain matching items.")
}

let differentArray = ["apple", "banana", "date"]
if allItemsMatch(myStringStack, differentArray) {
    print("Stack and different Array contain matching items.")
} else {
    print("Stack and different Array do NOT contain matching items.\n") // Expected: "Stack and different Array do NOT contain matching items."
}

/*:
 Generics are a cornerstone of Swift's power, enabling robust, flexible, and type-safe code. By understanding type parameters, constraints, and associated types, you can build highly adaptable components.

 What other aspects of Swift's generics or related features would you like to explore?
 */
