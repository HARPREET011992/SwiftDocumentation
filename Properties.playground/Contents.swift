import UIKit

// MARK: - Stored Properties

/*
 Stored properties are variables or constants that store values as part of an instance.
 Each instance of a struct or class has its own copy of stored properties.
*/

struct Area {
    var length: Double
    var width: Double
}

var area1 = Area(length: 10, width: 20)
print(area1.length)  // Prints: 10

area1.length = 100
print(area1.length)  // Prints: 100

// If the instance is a constant (let), stored properties cannot be modified
let area2 = Area(length: 101, width: 20)
print(area2.length)  // Prints: 101
// area2.length = 1000 // Error: Cannot assign to property: 'area2' is a 'let' constant

// MARK: - Lazy Stored Properties

/*
 Lazy stored properties are initialized only when first accessed.
 Useful for properties that are computationally expensive or need external resources.
*/

class DataImporter {
    // Simulate expensive setup (e.g., loading a file)
    var filename = "data.txt"

    init() {
        print("DataImporter initialized")
    }
}

class DataManager {
    lazy var importer = DataImporter()  // Created only when accessed
    var data: [String] = []
}

let manager = DataManager()
print(manager.data)           // Prints: []
manager.data.append("Some data")
print(manager.data)           // Prints: ["Some data"]
manager.data.append("More data")
print(manager.data)           // Prints: ["Some data", "More data"]

// Accessing lazy property for the first time triggers initialization
print(manager.importer.filename)  // Prints "DataImporter initialized" then "data.txt"

// MARK: - Computed Properties

/*
 Computed properties do not store values directly.
 Instead, they provide getters and optionally setters to compute a value indirectly.
*/

struct Temperature {
    var celsius: Double

    // Computed property for Fahrenheit temperature
    var fahrenheit: Double {
        get {
            return (celsius * 9 / 5) + 32
        }
        set {
            celsius = (newValue - 32) * 5 / 9
        }
    }
}

var temp = Temperature(celsius: 25)
print(temp.fahrenheit)  // Prints: 77.0

temp.fahrenheit = 77
print(temp.celsius)     // Prints: 25.0

// MARK: - Read-Only Computed Properties

/*
 Read-only computed properties only have a getter.
 They cannot be set, and often provide a simplified way to access a combination of other properties.
*/

struct User {
    var firstName: String
    var lastName: String

    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

let user1 = User(firstName: "John", lastName: "Doe")
print(user1.fullName)  // Prints: John Doe

// MARK: - Property Observers

/*
 Property observers monitor changes to a property’s value.
 They let you run code before (willSet) or after (didSet) the value changes.
*/

class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}

let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// Output:
// About to set totalSteps to 200
// Added 200 steps

// MARK: - Property Observers in Struct

struct UserWithObserver {
    var fullName: String {
        willSet {
            print("\(fullName) was the last fullName")
        }
        didSet {
            print("\(fullName) is now the fullName")
        }
    }
}

var a1 = UserWithObserver(fullName: "Harpreet Kaur")
a1.fullName = "Jyoti"
// Output:
// Harpreet Kaur was the last fullName
// Jyoti is now the fullName

// MARK: - Property Wrappers

/*
 Property wrappers let you reuse property logic.
 They define a wrapper struct or class with a wrappedValue property.
*/

@propertyWrapper
struct TwelveOrLess {
    private var number = 0

    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }  // Enforce max value 12
    }
}

struct SmallRectangle {
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
}

var rectangle = SmallRectangle()
print(rectangle.height)  // Prints: 0 (default)

rectangle.height = 10
print(rectangle.height)  // Prints: 10

rectangle.height = 24    // Exceeds max limit of 12
print(rectangle.height)  // Prints: 12

// MARK: - Type Properties (Static Properties)

/*
 Type properties belong to the *type itself*, not to any particular instance.
 This means:
 - They are shared by all instances of the type.
 - You access them using the type name, not an instance.
 - Useful for values or behavior common to all instances.
*/

// Example with a struct
struct SomeStructure {
    // Stored type property: fixed value stored once for the type
    static let storedTypeProperty = "Some value."

    // Computed type property: calculated every time it's accessed
    static var computedTypeProperty: Int {
        return 1
    }
}

// Access type properties from struct using the struct name
print(SomeStructure.storedTypeProperty)   // Prints: Some value.
print(SomeStructure.computedTypeProperty) // Prints: 1

// Example with an enum
enum SomeEnumeration {
    static let storedTypeProperty = "Some enum value."
    static var computedTypeProperty: Int {
        return 6
    }
}

// Access type properties from enum using the enum name
print(SomeEnumeration.storedTypeProperty)   // Prints: Some enum value.
print(SomeEnumeration.computedTypeProperty) // Prints: 6

// Example with a class
class SomeClass {
    static let storedTypeProperty = "Some class value."
    static var computedTypeProperty: Int {
        return 27
    }

    // Class computed property that can be overridden by subclasses
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}

// Access type properties from class using the class name
print(SomeClass.storedTypeProperty)               // Prints: Some class value.
print(SomeClass.computedTypeProperty)             // Prints: 27
print(SomeClass.overrideableComputedTypeProperty) // Prints: 107

// Explanation:
// - `static` means the property belongs to the type and cannot be overridden in subclasses.
// - `class` on a computed property allows subclasses to override it.

