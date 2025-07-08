import UIKit

import Foundation

// MARK: - Swift Operators Explained

// Operators work on different targets:
// Unary (!a), Binary (a + b), and Ternary (a ? b : c)

// MARK: Assignment Operator (=)
var a = 10

// MARK: Compound Assignment Operators (+=, -=, *=, /=, %=)
a += 10  // a = a + 10
print("a after += 10: \(a)")

a -= 10  // a = a - 10
print("a after -= 10: \(a)")

a *= 10  // a = a * 10
print("a after *= 10: \(a)")

a /= 10  // a = a / 10
print("a after /= 10: \(a)")

a %= 10  // a = a % 10
print("a after %= 10: \(a)")

// MARK: Equality Operators (==, !=)
print("10 == 10:", 10 == 10)  // true
print("10 != 10:", 10 != 10)  // false

// MARK: Arithmetic Operators (+, -, *, /, %)
print("10 + 10 =", 10 + 10)
print("10 - 10 =", 10 - 10)
print("10 * 10 =", 10 * 10)
print("10 / 10 =", 10 / 10)
print("10 % 10 =", 10 % 10)

// MARK: Comparison Operators (>, <, >=, <=, ==, !=)
let b = 10
let c = 20

print("b > c:", b > c)
print("b < c:", b < c)
print("b >= c:", b >= c)
print("b <= c:", b <= c)
print("b == c:", b == c)
print("b != c:", b != c)

// MARK: Ternary Conditional Operator
let marks = 85
let result = marks > 30 ? "✅ Pass" : "❌ Fail"
print("Result based on marks: \(result)")

// MARK: Nil-Coalescing Operator (??)
// Provides a default value if optional is nil
var optionalName: String? = ""
let displayName = optionalName?.isEmpty == false ? optionalName! : "Default Name"
print("Display Name: \(displayName)")

// MARK: Range Operators

// Closed Range (1...5) includes both ends
print("Closed Range Example:")
for index in 1...5 {
    print("\(index) × 5 = \(index * 5)")
}

// Half-Open Range (0..<n) excludes upper bound
let names = ["Harpreet", "Gurpreet", "Sam", "Ram", "Shyam", "Jai"]

print("\nHalf-Open Range Example:")
for i in 0..<names.count {
    print("Name \(i + 1): \(names[i])")
}

// One-Sided Ranges
print("\nOne-Sided Range from index 2 to end:")
for name in names[2...] {
    print(name)
}

print("\nOne-Sided Range from start to index 2:")
for name in names[...2] {
    print(name)
}

// MARK: Logical operator

// Logical and, logical or, logical not

let isStudent: Bool = true
let userAge: Int = 12

// Ternary usage
print(isStudent ? "✅ Student Access Granted" : "❌ Access Denied")

print((isStudent && userAge < 18) ? "🎓 Minor Student - Restricted Access" : "🟢 Full Access")

print((!isStudent || userAge >= 18) ? "🔓 Adult or Non-Student - Access OK" : "🔒 Access Denied - Underage Student")
