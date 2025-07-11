import UIKit

// MARK: - What is an Enumeration?
// An enum defines a common type for a group of related values
// It enables you to work with those values in a type-safe way.

enum SomeEnumeration {
    // Example: placeholder enum
}

// MARK: - Basic Enum Example

enum ColorStyle {
    case light
    case dark
}

// Matching enum using a switch statement

var colorStyle: ColorStyle = .light

switch colorStyle {
case .light:
    print("🌞 Light mode is on")
case .dark:
    print("🌚 Dark mode is on")
}

// MARK: - CaseIterable Protocol: Iterating Over All Cases

enum Beverage: CaseIterable {
    case coffee
    case tea
    case juice
}

let numberOfChoices = Beverage.allCases.count
print("🥤 \(numberOfChoices) beverages available:")

for beverage in Beverage.allCases {
    print("- \(beverage)")
}

// MARK: - Enums and Stored vs Computed Properties

// ❌ Enums CANNOT have stored properties
// enum Shape {
//     var name = "circle" // Error: stored properties not allowed in enum
// }

// ✅ Enums CAN have computed properties

enum Planet {
    case earth, mars, jupiter

    var description: String {
        switch self {
        case .earth:
            return "🌍 Our home planet"
        case .mars:
            return "🔴 The red planet"
        case .jupiter:
            return "🟤 The gas giant"
        }
    }
}

let planet = Planet.mars
print("🪐 Description: \(planet.description)")

// MARK: - Associated Values
// Enums can store associated values — extra info per case.

enum APIResponse {
    case success(data: String)
    case failure(error: String, code: Int)
}

let response1 = APIResponse.success(data: "{\"name\": \"John\"}")
let response2 = APIResponse.failure(error: "Not Found", code: 404)

switch response1 {
case .success(let jsonData):
    print("✅ Success: \(jsonData)")
case .failure(let errorMessage, let errorCode):
    print("❌ Failure: \(errorMessage), Code: \(errorCode)")
}

// MARK: - Recursive Enums (with indirect)
// Used to represent tree-like data structures, such as math expressions or file systems.

indirect enum Expression {
    case number(Int)
    case addition(Expression, Expression)
    case multiplication(Expression, Expression)
}

func evaluate(_ expression: Expression) -> Int {
    switch expression {
    case .number(let value):
        return value
    case .addition(let left, let right):
        return evaluate(left) + evaluate(right)
    case .multiplication(let left, let right):
        return evaluate(left) * evaluate(right)
    }
}

let expr = Expression.addition(.number(2), .multiplication(.number(3), .number(4)))
print("🧮 Expression result: \(evaluate(expr))")  // Output: 14

// MARK: - Summary
/*
✅ Use enums for grouping related types safely.
✅ Enums can:
    - Use switch statements
    - Be iterable (with CaseIterable)
    - Have computed properties
    - Store dynamic values (associated values)
    - Be recursive (with indirect)
❌ Enums cannot store stored properties like structs or classes.
*/
