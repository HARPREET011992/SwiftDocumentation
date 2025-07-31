import Foundation

//Assignment, arithmatic, compairision operator

let value1 = 4
let value2 = 5

if value1 == value2 {
    print("both values are equal")
} else {
    print("both values are not equal")
}

// compound assignment operator +=, -=, *=, /=

// +, -, /, *, %

let firstNumber = 20
let secondNumber = 10

if firstNumber == secondNumber {
    print(true)
}


let sum = firstNumber + secondNumber
let difference = firstNumber - secondNumber
let product = firstNumber * secondNumber
let quotient = firstNumber / secondNumber
let remainder = firstNumber % secondNumber

print("Sum: \(sum)")
print("Difference: \(difference)")
print("Product: \(product)")
print("Quotient: \(quotient)")
print("Remainder: \(remainder)")

// compairision operator >=, <=, >, <, ==, !=

func checkComparison(_ number1: Int, _ number2: Int) {
    if number1 >= number2 {
        print("number1 is greater than or equal to number2")
    } else if number1 <= number2 {
        print("number1 is less than or equal to number2")
    } else if number1 == number2 {
        print("number1 is equal to number2")
    } else if number1 != number2 {
        print("number1 is not equal to number2")
    } else if number1 > number2 {
        print("number1 is greater than number2")
    } else if number1 < number2 {
        print("number1 is less than number2")
    }
}

let number1 = 10
let number2 = 20

print(checkComparison(number1, number2))

// Ternary Conditional Operator

let answer = firstNumber > secondNumber ? "True" : "False"

// Closed Range Operator

for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}

// Half-Range Operator

for index in 1..<5 {
    print("\(index) times 5 is \(index * 5)")
}

// one-sided Range Operator
let names = ["Anna", "Alex", "Brian", "Jack"]

for name in names[...2] {
    print(name)
}

// Logical Operators

//Logical NOT (!a)

let allowedEntry = false
if !allowedEntry {
    print("ACCESS DENIED")
}

//Logical AND (a && b)

let enteredDoorCode = true
let passedRetinaScan = false
if enteredDoorCode && passedRetinaScan {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}

//Logical OR (a || b)
let hasDoorKey = false
let knowsOverridePassword = true
if hasDoorKey || knowsOverridePassword {
    print("Welcome!")
} else {
    print("ACCESS DENIED")
}
