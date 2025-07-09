import Foundation

// MARK: - Basic Function Concepts

// Function that takes a parameter and returns a greeting message
func greet(person: String) -> String {
    return "Hello, \(person)!"
}

// Call the function and store the returned value
let greeting = greet(person: "Anna")
print(greeting)  // Output: Hello, Anna!

// Function with no parameters that returns a string
func sayHelloWorld() -> String {
    return "hello, world"
}
print(sayHelloWorld())

// Function used by another function (example of reuse)
func greetAgain(person: String) -> String {
    return "Welcome back, \(person)!"
}

// Function with multiple parameters and a conditional return
func greet(person: String, alreadyGreeted: Bool) -> String {
    return alreadyGreeted ? greetAgain(person: person) : greet(person: person)
}

// Call function with different argument combinations
print(greet(person: "Leo", alreadyGreeted: true))    // Welcome back, Leo
print(greet(person: "Maya", alreadyGreeted: false))  // Hello, Maya!

// Function that prints directly and doesn't return anything (Void)
func greetAndPrint(person: String) {
    print("Hello, \(person)!")
}
greetAndPrint(person: "Taylor")

// Function that returns the number of characters after printing a string
func printAndCount(string: String) -> Int {
    print(string)
    return string.count
}

let count = printAndCount(string: "Hello")
print("Count: \(count)")

// Use _ to ignore the return value of a function
_ = printAndCount(string: "Ignored")

// MARK: - Nested and Higher-Order Functions

// Function containing other functions (nested functions)
func chooseGreeting(useFormal: Bool) -> String {
    func formal() -> String { return "Good evening." }
    func casual() -> String { return "Hey there!" }
    return useFormal ? formal() : casual()
}
print(chooseGreeting(useFormal: false)) // Hey there!

// Function that returns another function
func makeIncrementer() -> (Int) -> Int {
    func addOne(number: Int) -> Int {
        return number + 1
    }
    return addOne
}

// Using the returned function
let increment = makeIncrementer()
print(increment(5)) // 6

// Function that accepts another function as an argument
func applyTwice(_ function: (Int) -> Int, to number: Int) -> Int {
    return function(function(number))
}
print(applyTwice(increment, to: 3)) // 5

// MARK: - Multiple Return Values

// Function that returns a tuple (min, max) or nil if array is empty
func findMinMax(in array: [Int]) -> (min: Int, max: Int)? {
    guard !array.isEmpty else { return nil }

    var currentMin = array[0]
    var currentMax = array[0]

    for value in array[1...] {
        if value < currentMin {
            currentMin = value
        } else if value > currentMax {
            currentMax = value
        }
    }

    return (currentMin, currentMax)
}

// Using optional binding to safely unwrap the result
let numbers = [5, 8, -2, 42, 0, 17]
if let result = findMinMax(in: numbers) {
    print("Min: \(result.min), Max: \(result.max)")
} else {
    print("Array is empty")
}

// MARK: - Variadic Parameters

// Function that takes any number of Int arguments
func calculateSum(of numbers: Int...) -> Int {
    var total = 0
    for number in numbers {
        total += number
    }
    return total
}
print("Sum: \(calculateSum(of: 1, 2, 3, 4, 5))") // 15

// MARK: - Default Parameter Values

// Function with a default parameter value
func multiply(_ a: Int, by b: Int = 2) -> Int {
    return a * b
}
print("Multiply 6 by default: \(multiply(6))")     // 12
print("Multiply 6 by 5: \(multiply(6, by: 5))")    // 30

// MARK: - In-Out Parameters

// Function that swaps the values of two variables using inout
func swapValues(_ a: inout Int, _ b: inout Int) {
    let temp = a
    a = b
    b = temp
}

// Use & to pass variables as inout parameters
var x = 10
var y = 20
swapValues(&x, &y)
print("x: \(x), y: \(y)") // x: 20, y: 10

// MARK: - Functions as Parameters

// Function that accepts another function to perform an operation
func performOperation(_ a: Int, _ b: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(a, b)
}

// Example functions to pass in
func add(_ a: Int, _ b: Int) -> Int { return a + b }
func subtract(_ a: Int, _ b: Int) -> Int { return a - b }

print("Add: \(performOperation(4, 2, operation: add))")        // 6
print("Subtract: \(performOperation(4, 2, operation: subtract))") // 2

// MARK: - Notes
// - Functions with a return type must always return a value.
// - Functions can be passed around like variables.
// - Function types include parameter and return types.
