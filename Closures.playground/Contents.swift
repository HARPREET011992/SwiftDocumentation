import Foundation

// MARK: - What is a Closure?
/*
 A closure is a self-contained block of code that can be passed around and used in your code.
 Closures in Swift can:
 - Capture values from the surrounding context.
 - Be assigned to variables or constants.
 - Be passed as parameters to functions.

 There are different types of closures in Swift:
 1. Non-escaping closures (default): Used only inside the function.
 2. Escaping closures: Used outside the function after it returns.
 3. Auto-closures: Automatically wrap an expression in a closure.
 4. Trailing closures: Syntactic sugar when closure is the final parameter.
 5. Capturing values: Closures remember the variables from their creation context.
*/

// MARK: - Example 1: Simple Inline (Non-Escaping) Closure

var addTwoNumbers: (Int, Int) -> Int = { (a, b) in
    return a + b
}

print("Simple closure result: \(addTwoNumbers(10, 20))")  // Output: 30

// MARK: - Example 2: Passing Closure to a Function (Non-Escaping)

func calculate(operation: (Int, Int) -> Int) {
    let result = operation(5, 3)
    print("Calculation result: \(result)")
}

calculate(operation: addTwoNumbers)  // Output: 8

// MARK: - Example 3: Escaping Closure

@MainActor
func fetchAPI(completion: @escaping (Int) -> Void) {
    print("Fetching data...")
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        let simulatedResult = 100
        completion(simulatedResult)
    }
}

fetchAPI { data in
    print("Escaping closure result: \(data)")  // Output: 100 (after 2 seconds)
}

// MARK: - Example 4: Trailing Closure Syntax

func performTask(with message: String, completion: () -> Void) {
    print(message)
    completion()
}

// Using trailing closure
performTask(with: "Starting task...") {
    print("Task completed. (Trailing closure used)")
}

// Trailing closure with filter
let numbers = [1, 2, 3, 4, 5]
let evenNumbers = numbers.filter { $0 % 2 == 0 }
print("Even numbers using trailing closure: \(evenNumbers)")  // Output: [2, 4]

// MARK: - Example 5: Auto-Closure

func logIfTrue(_ condition: @autoclosure () -> Bool) {
    if condition() {
        print("Auto-closure condition is true!")
    } else {
        print("Auto-closure condition is false.")
    }
}

let isUserLoggedIn = true
logIfTrue(isUserLoggedIn)  // Swift wraps the expression as a closure

// Escaping auto-closure
var storedCondition: (() -> Bool)?

@MainActor
func storeCondition(_ condition: @autoclosure @escaping () -> Bool) {
    storedCondition = condition
}

storeCondition(isUserLoggedIn)

if let check = storedCondition {
    print("Stored auto-closure result: \(check())")  // Output: true
}

// MARK: - Example 6: Capturing Values

/*
 Closures can capture and store references to variables and constants
 from the surrounding context in which they are defined.
 This is called "capturing values".
*/

func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var total = 0
    let incrementer: () -> Int = {
        total += amount
        return total
    }
    return incrementer
}

let incrementByFive = makeIncrementer(forIncrement: 5)
print(incrementByFive()) // Output: 5
print(incrementByFive()) // Output: 10
print(incrementByFive()) // Output: 15

let incrementByTwo = makeIncrementer(forIncrement: 2)
print(incrementByTwo()) // Output: 2
print(incrementByTwo()) // Output: 4

// Explanation: Each closure keeps its own captured `total` variable!

// MARK: - Example 7: Capture List

/*
 Capture lists let you control how values are captured:
 - Strong (default): Reference is retained strongly.
 - Weak/unowned: Used to avoid retain cycles in classes.
*/

class Person {
    let name: String
    init(name: String) { self.name = name }
    deinit { print("\(name) is being deinitialized") }
}

var john: Person? = Person(name: "John")

let greeting: () -> Void = { [weak john] in
    if let name = john?.name {
        print("Hello, \(name)")
    } else {
        print("John is nil")
    }
}

greeting()  // Output: Hello, John
john = nil  // Person instance deallocated
greeting()  // Output: John is nil

// MARK: - Summary

print("""
----------------------
🔹 Closure Summary:
- Closures are reusable, self-contained blocks of code.
- Closures can capture and store values from context.
- @escaping allows closures to run after the function returns.
- @autoclosure lets you pass expressions instead of closures.
- Trailing closures improve readability.
- Capture lists prevent memory issues like retain cycles.
----------------------
""")
