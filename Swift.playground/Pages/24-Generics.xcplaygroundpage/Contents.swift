import Foundation

// Generics is code that works for mutiple types

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


extension Stack {
    var topItem: Element? { // Element is available from the original Stack definition
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

print("--- Extending a Generic Type ---")
if let top = stackOfStrings.topItem {
    print("Top item on stack: \(top)\n") // Expected: "Are"
}

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

protocol Container {
    associatedtype Item // An associated type in Swift is a placeholder type used inside a protocol. It lets you define a protocol with a generic type that gets specified by each conforming type, rather than when the protocol itself is defined.
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
    mutating func append(_ item: Element) {
        self.push(item) // Reuses Stack's push method
    }
}

print("--- Associated Types ---")
var myIntStack = Stack<Int>()
myIntStack.append(1)
myIntStack.append(2)
print("Int Stack count: \(myIntStack.count)") // Expected: 2
print("First item in Int Stack: \(myIntStack[0])\n") // Expected: 1

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

extension Array: Container {

}

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

protocol Container1 {
    associatedtype Item
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(index: Int) -> Item { get }
}

struct IntStack: Container1 {
    var items = [Int]()
    mutating func append(_ item: Int) { items.append(item) }
    var count: Int { items.count }
    subscript(index: Int) -> Int { items[index] }
}

var stack = IntStack()
stack.append(1)
stack.append(2)
stack.append(3)

print(stack[0] == 1)
print(stack[1] == 2)
print(stack[2] != 3)
print(stack.count == 3)
