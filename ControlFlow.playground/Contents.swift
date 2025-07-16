import UIKit

/*:
 # Control Flow in Swift

 ## Definition
 Swift provides a comprehensive set of **control flow statements** that dictate the order in which your code executes. These include:
 -   **Loops** (`for-in`, `while`, `repeat-while`) for performing tasks repeatedly.
 -   **Conditional statements** (`if`, `guard`, `switch`) for executing different code branches based on conditions.
 -   **Transfer statements** (`break`, `continue`, `fallthrough`, `defer`) to alter the flow of execution within loops or other scopes.

 Swift's `switch` statement is particularly powerful, supporting advanced **pattern matching** like interval matches, tuples, type casting, value binding, and `where` clauses.

 ---

 ## For-In Loops

 The `for-in` loop iterates over sequences such as arrays, dictionaries, ranges, and strings.

 */
print("--- For-In Loops ---")

// ### Iterating over an Array
let names = ["Alice", "Bob", "Charlie"]
print("Iterating over an array:")
for name in names {
    print("  Hello, \(name)!")
}

// ### Iterating over a Dictionary
// Dictionary elements are iterated as (key, value) tuples.
let ages = ["Alice": 30, "Bob": 24, "Charlie": 35]
print("\nIterating over a dictionary:")
for (personName, personAge) in ages {
    print("  \(personName) is \(personAge) years old.")
}

// ### Iterating over Numeric Ranges
print("\nIterating over a numeric range (closed range 1...5):")
for index in 1...5 { // Includes both 1 and 5
    print("  \(index) times 2 is \(index * 2)")
}

print("\nIterating over a numeric range (half-open range 0..<3):")
for i in 0..<3 { // Includes 0, 1, 2 but not 3
    print("  Loop iteration \(i)")
}

// ### Ignoring Values with Underscore (_)
let base = 2
let exponent = 4
var result = 1
print("\nCalculating \(base) to the power of \(exponent):")
for _ in 1...exponent { // We don't need the loop variable itself
    result *= base
}
print("  Result: \(result)") // 16

// ### Stride Functions for Stepping Through Ranges
print("\nStride: Counting by 2s (from 0 to 10, not including 10):")
for num in stride(from: 0, to: 10, by: 2) {
    print("  \(num)") // 0, 2, 4, 6, 8
}

print("\nStride: Counting by 3s (from 1 to 10, including 10 if divisible):")
for num in stride(from: 1, through: 10, by: 3) {
    print("  \(num)") // 1, 4, 7, 10
}

/*:
 ---

 ## While Loops

 A `while` loop repeatedly executes a block of statements as long as a condition remains `true`. Use them when the number of iterations isn't known beforehand.

 */
print("\n--- While Loops ---")

// ### `while` loop (condition evaluated at the start)
var countdown = 5
print("Countdown using while loop:")
while countdown > 0 {
    print("  \(countdown)...")
    countdown -= 1
}
print("  Lift off!")

// ### `repeat-while` loop (condition evaluated at the end)
// Guarantees at least one execution of the loop body.
var batteryLevel = 5
print("\nCharging until full (repeat-while):")
repeat {
    print("  Battery at \(batteryLevel)%")
    batteryLevel += 10
} while batteryLevel <= 100 // Loop runs once even if batteryLevel was already 100
print("  Battery fully charged!")

/*:
 ---

 ## Conditional Statements

 Conditional statements allow you to execute different parts of your code based on certain conditions.

 */
print("\n--- Conditional Statements ---")

// ### `if` statement
// Executes code if a condition is true. Can include `else if` and `else` clauses.
let currentTemperature = 25 // Celsius

print("Temperature advice (if-else if-else):")
if currentTemperature <= 0 {
    print("  It's freezing! Bundle up.")
} else if currentTemperature > 30 {
    print("  It's scorching hot! Stay hydrated.")
} else {
    print("  The temperature is mild. Enjoy!")
}

// ### `if` as an expression (assigning a value based on conditions)
let advice = if currentTemperature <= 0 {
    "It's freezing! Bundle up."
} else if currentTemperature > 30 {
    "It's scorching hot! Stay hydrated."
} else {
    "The temperature is mild. Enjoy!"
}
print("Advice from if expression: \(advice)")

/*:
 ### `switch` Statement

 A `switch` statement considers a value and compares it against several possible **patterns**. It executes the code for the first matching pattern. Swift's `switch` statements are **exhaustive** by default (must cover all possible cases), preventing accidental fallthrough.

 */
print("\n--- Switch Statement ---")

let dayOfWeek = "Wednesday"

print("What day is it? (Basic switch):")
switch dayOfWeek {
case "Monday":
    print("  It's the start of the week.")
case "Friday":
    print("  Yay, it's almost the weekend!")
case "Saturday", "Sunday": // Compound case
    print("  It's the weekend!")
default: // The default case makes the switch exhaustive
    print("  It's a regular weekday.")
}

// ### Interval Matching
let score = 85

print("\nStudent grade (Interval Matching):")
switch score {
case 0..<50:
    print("  Failing grade.")
case 50..<70:
    print("  Passing, but needs improvement.")
case 70..<90:
    print("  Good job!")
case 90...100:
    print("  Excellent work!")
default:
    print("  Invalid score.")
}

// ### Tuples in `switch`
let coordinates = (3, 0)

print("\nPoint classification (Tuples in switch):")
switch coordinates {
case (0, 0):
    print("  At the origin.")
case (_, 0): // Wildcard pattern for x, fixed y
    print("  On the X-axis.")
case (0, _): // Fixed x, wildcard for y
    print("  On the Y-axis.")
case (-10...10, -10...10): // Interval matching in tuple
    print("  Inside the 10x10 box.")
default:
    print("  Outside the box.")
}

// ### Value Bindings
// Temporarily binds matched values to constants/variables for use within the case.
let student = ("John Doe", 15, "Mathematics")

print("\nStudent info (Value Bindings):")
switch student {
case (let name, 15, _): // Binds name, matches age 15, any subject
    print("  Found a 15-year-old student named \(name).")
case (_, let age, "Science"): // Binds age, matches Science, any name
    print("  Found a student \(age) years old studying Science.")
case let (name, age, subject): // Catches all remaining, binds all values
    print("  Student: \(name), Age: \(age), Subject: \(subject).")
}

// ### `where` clause
// Adds an additional condition to a `case`.
let point = (2, 2)

print("\nPoint on a line (where clause):")
switch point {
case let (x, y) where x == y:
    print("  (\(x), \(y)) is on the line x = y.")
case let (x, y) where x == -y:
    print("  (\(x), \(y)) is on the line x = -y.")
default:
    print("  (\(point.0), \(point.1)) is just an arbitrary point.")
}

/*:
 ### Patterns in `if` statements (`if case`)

 You can use patterns directly in `if` statements with `if case`.

 */
print("\n--- Patterns in If Statements (`if case`) ---")

let optionalNumber: Int? = 10
if case .some(let value) = optionalNumber { // Matches if optionalNumber has a value, binds it to 'value'
    print("  The optional number is \(value).")
}

let statusCode = 404
if case 400..<500 = statusCode { // Matches if statusCode is in the 4xx range
    print("  Client error code: \(statusCode)")
}

/*:
 ---

 Swift's control flow features provide robust tools for directing program execution, from simple loops to sophisticated pattern matching. They make your code concise, readable, and less prone to errors.
 */
