import UIKit

// Enumeration is used to define a group of related values in a type-safe way.

// Raw values and associated values
// CaseIterable is used to iterate through each case in an enum.
// Enums can use Int, String, or Character as raw value types.

enum AppError: String, CaseIterable {
    case invalidInput = "t"
    case internalError = "e"
    case networkError = "n"
    case invalidResponse = "i"

    var description: String {
        return "Error code: \(rawValue)"
    }
    init?(rawValue: String) {
        switch rawValue {
        case "t":
            self = .invalidInput
        case "e":
            self = .internalError
        case "n":
            self = .networkError
        case "i":
            self = .invalidResponse
        default:
            self = .invalidInput
        }
    }
}

let firstError = AppError.invalidInput

switch firstError {
case .invalidInput:
    print("Invalid input")
case .internalError:
    print("Internal error")
case .networkError:
    print("Network error")
case .invalidResponse:
    print("Invalid response")
}

// Iterate through all cases using CaseIterable
for error in AppError.allCases {
    error.description
}

// Associated Values Example
enum Currency<T: Numeric> {
    case rupees(T)
    case dollars(T)
    case pounds(T)
    case singaPourDoller(T)
    case americanDoller(String)
}


let rupees = Currency.rupees(100)

let doller = Currency.dollars(15)

switch rupees {
case .rupees(let value):
    print("Rupees: \(value) ₹")
case .dollars(let value):
    print("Dollars: \(value) $")
case .pounds(let value):
    print("Pounds: \(value) £")
case .singaPourDoller(let value):
    print("si: \(value) £")
case .americanDoller(let value):
    print("si: \(value) £")
}

print(rupees)

// Shape enum with associated values
enum Shape {
    case square(side: Int)
    case rectangle(width: Int, height: Int)
    case circle(radius: Int)
}

let square = Shape.square(side: 10)

switch square {
case .square(let side):
    print("Area of square: \(side * side)")
case .rectangle(let width, let height):
    print("Area of rectangle: \(width * height)")
case .circle(let radius):
    print("Area of circle: \(Double(radius * radius) * 3.14)")
}

protocol ArithmaticProtocol {
    func evaluate() -> Int
}

// Recursive Enum Example
indirect enum Arithmetic: ArithmaticProtocol {
    case value(Int)
    case add(Arithmetic, Arithmetic)
    case subtract(Arithmetic, Arithmetic)
    case multiply(Arithmetic, Arithmetic)
    case divide(Arithmetic, Arithmetic)

    func evaluate() -> Int {
        switch self {
        case .value(let value):
            return value
        case .add(let lhs, let rhs):
            return lhs.evaluate() + rhs.evaluate()
        case .subtract(let lhs, let rhs):
            return lhs.evaluate() - rhs.evaluate()
        case .multiply(let lhs, let rhs):
            return lhs.evaluate() * rhs.evaluate()
        case .divide(let lhs, let rhs):
            return lhs.evaluate() / rhs.evaluate()
        }
    }
}



let firstValue = Arithmetic.value(10)
let secondValue = Arithmetic.value(20)
let sum = Arithmetic.multiply(secondValue, firstValue)

print("Result of expression: \(sum.evaluate())")
