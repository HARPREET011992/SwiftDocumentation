import UIKit

// MARK: - 🧱 What is Initialization?

/// Initialization prepares an instance of a type (class, struct, enum) for use.
/// All stored properties must be initialized before use.


// MARK: - 🔹 Default Initializer (Auto-generated)

struct Point {
    var x = 0.0
    var y = 0.0
}

let origin = Point()  // Uses default initializer
print("Default Point: (\(origin.x), \(origin.y))")


// MARK: - 🔹 Memberwise Initializer (struct only)

struct Size {
    var width = 0.0
    var height = 0.0
}

let square = Size(width: 2.0, height: 2.0)
print("Square: \(square.width)x\(square.height)")


// MARK: - 🔹 Custom Initializer

struct Celsius {
    var temperature: Double

    init(fromFahrenheit fahrenheit: Double) {
        temperature = (fahrenheit - 32) / 1.8
    }

    init(fromKelvin kelvin: Double) {
        temperature = kelvin - 273.15
    }

    init(_ celsius: Double) {
        temperature = celsius
    }
}

let boiling = Celsius(fromFahrenheit: 212)
let freezing = Celsius(fromKelvin: 273.15)
let normal = Celsius(37)

print("Boiling: \(boiling.temperature), Freezing: \(freezing.temperature), Normal: \(normal.temperature)")


// MARK: - 🔹 Argument Labels & Without Labels

struct Color {
    var red, green, blue: Double

    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    init(white: Double) {
        red = white
        green = white
        blue = white
    }
}

let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
let gray = Color(white: 0.5)

print("Magenta RGB: \(magenta.red), \(magenta.green), \(magenta.blue)")
print("Gray RGB: \(gray.red), \(gray.green), \(gray.blue)")


// MARK: - 🔹 Optional Properties

class SurveyQuestion {
    let text: String
    var response: String?  // Optional String

    init(text: String) {
        self.text = text
    }

    func ask() {
        print(text)
    }
}

let question = SurveyQuestion(text: "Do you like cheese?")
question.ask()
question.response = "Yes, I do!"


// MARK: - 🔹 Constant Properties During Init

// `text` is a constant (`let`) but initialized inside the initializer
class SurveyQuestionConst {
    let text: String
    var response: String?

    init(text: String) {
        self.text = text
    }
}


// MARK: - 🔹 Failable Initializer

enum Planet: Int {
    case mercury = 1, venus, earth, mars
}

let earth = Planet(rawValue: 3)  // Valid
let unknown = Planet(rawValue: 9)  // nil

print("Earth: \(String(describing: earth)), Unknown: \(String(describing: unknown))")


// MARK: - 🔹 Enum with Associated Values & Case Initializers

enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}

let productBarcode = Barcode.upc(8, 85909, 51226, 3)
let qrCode = Barcode.qrCode("ABCDEFG123")


// MARK: - 🔹 Default Initializer for Class

class ShoppingListItem {
    var name: String?
    var quantity = 1
    var purchased = false
}

let item = ShoppingListItem()
print("Item: \(item.name ?? "Unnamed"), Qty: \(item.quantity), Purchased: \(item.purchased)")

// MARK: - 🔹 Initializer Delegation for Value Types
struct Rect {
    var origin = Point()
    var size = Size()

    // 1. Default initializer (no parameters)
    init() {}

    // 2. Memberwise initializer (takes origin and size)
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }

    // 3. Delegating initializer (calculates origin from center, then delegates)
    init(center: Point, size: Size) {
        let originX = center.x - size.width / 2
        let originY = center.y - size.height / 2
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

// Using initializers
let rect1 = Rect() // default
let rect2 = Rect(origin: Point(x: 1, y: 1), size: Size(width: 3, height: 3)) // memberwise
let rect3 = Rect(center: Point(x: 4, y: 4), size: Size(width: 2, height: 2)) // delegating

print(rect1.origin, rect1.size)
print(rect2.origin, rect2.size)
print(rect3.origin, rect3.size)

//Class Initialization Overview
//All stored properties, including inherited ones, must be initialized during class initialization.
//Swift uses two types of initializers for classes:
//Designated initializers: Primary initializers that fully initialize all properties introduced by the class and call a superclass initializer.
//Convenience initializers: Secondary helpers that call a designated initializer in the same class, often providing default values or shortcuts.
//Initialization Rules
//Designated initializers must call a designated initializer from the immediate superclass.
//Convenience initializers must call another initializer in the same class and ultimately call a designated initializer.
//Think of it as:
//Designated initializers delegate up the inheritance chain.
//Convenience initializers delegate across the same class.
//Two-Phase Initialization
//Phase 1:
//Each class initializes its own properties, then calls superclass initializers up the chain. Memory is not fully initialized until the top class finishes this phase.
//Phase 2:
//Initializers can then customize properties, call methods, and access self.
//Safety Checks Swift Enforces
//Designated initializers must initialize all properties before calling superclass initializers.
//Designated initializers must call superclass initializers before modifying inherited properties.
//Convenience initializers must delegate before assigning any property values.
//No instance methods or property access until Phase 1 completes.
//Initializer Inheritance and Overriding
//Swift subclasses do not inherit superclass initializers by default.
//You must override superclass designated initializers explicitly with the override keyword.
//Convenience initializers are not overridden but can be redefined without override.
//Example

class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}

class Bicycle: Vehicle {
    override init() {
        super.init()           // Call superclass designated initializer
        numberOfWheels = 2     // Customize property after superclass init
    }
}

let bike = Bicycle()
print(bike.description)  // Output: 2 wheel(s)

class Hoverboard: Vehicle {
    var color: String
    init(color: String) {
        self.color = color
        // super.init() called implicitly
    }
    override var description: String {
        return "\(super.description) in \(color)"
    }
}

let hoverboard = Hoverboard(color: "silver")
print(hoverboard.description)  // Output: 0 wheel(s) in silver
