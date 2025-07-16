import Foundation
/*:
 # Initialization in Swift

 ## Definition
 **Initialization** is the crucial process of preparing an instance of a class, structure, or enumeration for use. This involves setting an initial value for every **stored property** on that instance and performing any other necessary setup before the new instance is ready.

 In Swift, you define this process using **initializers**, which are special methods identified by the `init` keyword. Unlike Objective-C, Swift initializers **do not return a value**; their primary role is to guarantee that new instances are correctly and fully initialized.

 **Key Aspects of Initialization:**
 - All **stored properties** of a class or structure *must* have an appropriate initial value by the time an instance is created. They cannot be left in an indeterminate state.
 - You can set initial values either within an initializer or by providing **default property values** directly in the property's declaration.
 - Classes can also implement a **deinitializer** (`deinit`), which performs cleanup just before an instance is deallocated.

 ---

 ## Setting Initial Values for Stored Properties

 Stored properties can get their initial values in two main ways:

 ### 1. Default Property Values

 You can provide a default value as part of the property's declaration. This is the simplest way if a property always starts with the same value.

 */
// Example: Fahrenheit with a default property value
struct Fahrenheit {
    var temperature = 32.0 // Default value for freezing point of water
}

print("--- Default Property Values ---")
var fahrenheitTemp = Fahrenheit()
print("The default temperature is \(fahrenheitTemp.temperature)° Fahrenheit")
// Expected: "The default temperature is 32.0° Fahrenheit"

/*:
 ### 2. Initializers

 Initializers are special methods that ensure all properties are initialized. In its simplest form, an initializer is `init()`.

 */
// Example: Basic Initializer
struct TemperatureReading {
    var value: Double

    init() {
        value = 0.0 // Initializes 'value' to zero if no other value is provided
    }
}

print("\n--- Basic Initializers ---")
let defaultReading = TemperatureReading()
print("Default reading value: \(defaultReading.value)")
// Expected: "Default reading value: 0.0"

/*:
 ---

 ## Customizing Initialization

 You can make initializers more flexible by adding parameters, handling optional properties, and assigning constant properties.

 ### 1. Initialization Parameters

 Initializers can accept parameters to customize the instance during creation. These parameters behave like function parameters with both a parameter name (internal) and an argument label (external). Swift automatically provides argument labels for all initializer parameters unless explicitly overridden.

 */
// Example: Celsius structure with custom initializers
struct Celsius {
    var temperatureInCelsius: Double

    // Initializer with argument label "fromFahrenheit" and parameter name "fahrenheit"
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }

    // Initializer with argument label "fromKelvin" and parameter name "kelvin"
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }

    // Initializer with NO argument label for its parameter (using underscore "_")
    init(_ celsius: Double) {
        temperatureInCelsius = celsius
    }
}

print("\n--- Custom Initializers with Parameters ---")
let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
print("Boiling point (Fahrenheit to Celsius): \(boilingPointOfWater.temperatureInCelsius)°C")
// Expected: "Boiling point (Fahrenheit to Celsius): 100.0°C"

let freezingPointOfWater = Celsius(fromKelvin: 273.15)
print("Freezing point (Kelvin to Celsius): \(freezingPointOfWater.temperatureInCelsius)°C")
// Expected: "Freezing point (Kelvin to Celsius): 0.0°C"

let bodyTemperature = Celsius(37.0) // No argument label needed due to `_`
print("Body temperature (direct Celsius): \(bodyTemperature.temperatureInCelsius)°C")
// Expected: "Body temperature (direct Celsius): 37.0°C"

/*:
 ### 2. Optional Property Types

 If a stored property might not have a value during initialization or at other times, declare it as an **optional type**. Optional properties are automatically initialized to `nil`.

 */
// Example: SurveyQuestion with an optional response
class SurveyQuestion {
    var text: String
    var response: String? // Optional String, automatically initialized to nil

    init(text: String) {
        self.text = text
    }

    func ask() {
        print(text)
    }
}

print("\n--- Optional Property Types ---")
let animalQuestion = SurveyQuestion(text: "What's your favorite animal?")
animalQuestion.ask()
print("Response initially: \(animalQuestion.response ?? "No response yet")") // Using nil coalescing
animalQuestion.response = "Dogs!"
print("Response after input: \(animalQuestion.response ?? "No response yet")")

/*:
 ### 3. Assigning Constant Properties During Initialization

 You can assign a value to a **constant property (`let`)** at any point during initialization, as long as it's set to a definite value by the time initialization finishes. Once set, it cannot be modified.

 */
// Example: SurveyQuestion with a constant 'text' property
class ImmutableSurveyQuestion {
    let text: String // Now a constant property
    var response: String?

    init(text: String) {
        self.text = text // Assigning a value to a constant during init
    }

    func ask() {
        print(text)
    }
}

print("\n--- Assigning Constant Properties ---")
let colorQuestion = ImmutableSurveyQuestion(text: "What's your favorite color?")
colorQuestion.ask()
// colorQuestion.text = "New Question?" // This would cause a compile-time error
colorQuestion.response = "Blue"
print("Question text (constant): \(colorQuestion.text)")

/*:
 ---

 ## Automatic Initializers

 Swift provides automatic initializers for convenience in common scenarios.

 ### 1. Default Initializers

 If a class or structure provides **default values for all its stored properties** and doesn't define any custom initializers, Swift provides a **default initializer** (`init()`). This initializer simply creates a new instance with all properties set to their default values.

 */
// Example: ShoppingListItem with a default initializer
class ShoppingListItem {
    var name: String?    // Optional String, default value is nil
    var quantity = 1     // Default value is 1
    var purchased = false // Default value is false
}

print("\n--- Default Initializers ---")
var newItem = ShoppingListItem()
print("New item: Name=\(newItem.name ?? "nil"), Quantity=\(newItem.quantity), Purchased=\(newItem.purchased)")
// Expected: "New item: Name=nil, Quantity=1, Purchased=false"

/*:
 ### 2. Memberwise Initializers for Structure Types

 Structure types automatically receive a **memberwise initializer** if they don't define any custom initializers. This initializer allows you to initialize the structure's properties by name, even if they don't have default values.

 */
// Example: Size structure with a memberwise initializer
struct Size {
    var width = 0.0
    var height = 0.0
}

print("\n--- Memberwise Initializers ---")
let twoByTwo = Size(width: 2.0, height: 2.0)
print("Two by Two Size: Width=\(twoByTwo.width), Height=\(twoByTwo.height)")
// Expected: "Two by Two Size: Width=2.0, Height=2.0"

// You can omit values for properties with default values
let zeroByTwo = Size(height: 2.0)
print("Zero by Two Size: Width=\(zeroByTwo.width), Height=\(zeroByTwo.height)")
// Expected: "Zero by Two Size: Width=0.0, Height=2.0"

let zeroByZero = Size() // Can even call it without any arguments if all have defaults
print("Zero by Zero Size: Width=\(zeroByZero.width), Height=\(zeroByZero.height)")
// Expected: "Zero by Zero Size: Width=0.0, Height=0.0"

/*:
 ---

 ## Initializer Delegation for Value Types

 Initializers can call other initializers from the *same* type to avoid duplicating code. For value types (structs and enums), this is done using `self.init()`.

 **Note:** If you define *any* custom initializer for a value type, you lose access to the automatic default and memberwise initializers, unless you define them explicitly yourself or in an extension.

 */
// Supporting structures for Rect example
struct Point {
    var x = 0.0, y = 0.0
}

struct Rect {
    var origin = Point()
    var size = Size() // Using the Size struct defined earlier

    // Custom initializer 1: Default init (explicitly defined to keep it)
    init() { /* no custom logic, uses default property values */ }

    // Custom initializer 2: Memberwise init (explicitly defined to keep it)
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }

    // Custom initializer 3: Delegates to the second initializer
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        // Delegates to init(origin:size:)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

print("\n--- Initializer Delegation (Value Types) ---")
let basicRect = Rect()
print("Basic Rect: Origin=(\(basicRect.origin.x), \(basicRect.origin.y)), Size=(\(basicRect.size.width), \(basicRect.size.height))")
// Expected: "Basic Rect: Origin=(0.0, 0.0), Size=(0.0, 0.0)"

let originRect = Rect(origin: Point(x: 2.0, y: 2.0), size: Size(width: 5.0, height: 5.0))
print("Origin Rect: Origin=(\(originRect.origin.x), \(originRect.origin.y)), Size=(\(originRect.size.width), \(originRect.size.height))")
// Expected: "Origin Rect: Origin=(2.0, 2.0), Size=(5.0, 5.0)"

let centerRect = Rect(center: Point(x: 4.0, y: 4.0), size: Size(width: 3.0, height: 3.0))
print("Center Rect: Origin=(\(centerRect.origin.x), \(centerRect.origin.y)), Size=(\(centerRect.size.width), \(centerRect.size.height))")
// Expected: "Center Rect: Origin=(2.5, 2.5), Size=(3.0, 3.0)"

/*:
 ---

 ## Class Inheritance and Initialization

 Class initialization involves a two-phase process to ensure all properties are initialized, including inherited ones.

 ### Designated Initializers and Convenience Initializers

 - **Designated Initializers**: Primary initializers. They fully initialize all properties introduced by their class and call a superclass designated initializer to continue initialization up the hierarchy. A class typically has very few, often only one, designated initializer.
 - **Convenience Initializers**: Secondary initializers. They provide shortcuts to common initialization patterns. A convenience initializer *must* call another initializer from the *same* class, and it must ultimately call a designated initializer. They are marked with the `convenience` keyword.

 **Initializer Delegation Rules for Classes:**
 1.  A **designated initializer** must call a designated initializer from its immediate superclass (delegates **up**).
 2.  A **convenience initializer** must call another initializer from the *same* class (delegates **across**).
 3.  A **convenience initializer** must ultimately call a designated initializer.

 ### Two-Phase Initialization

 Swift's class initialization is a two-phase process for safety and flexibility:
 - **Phase 1: Initialization of Properties**: Each stored property is assigned an initial value by the class that introduced it, starting from the subclass and moving up the inheritance chain. Memory is initialized.
 - **Phase 2: Customization**: Working back down the chain, each class has the opportunity to customize its properties further, access `self`, call methods, etc., once all properties are initialized.

 **Safety Checks:**
 1.  Designated initializer initializes its own properties *before* delegating up.
 2.  Designated initializer delegates up *before* assigning to inherited properties.
 3.  Convenience initializer delegates *across* *before* assigning to any property.
 4.  Cannot call instance methods, read instance properties, or refer to `self` as a value until Phase 1 is complete.

 ### Initializer Inheritance and Overriding

 Swift subclasses generally **do not inherit superclass initializers by default**. If a subclass wants to provide an initializer that matches a superclass designated initializer, it must **override** it using the `override` keyword.

 */
// Example: Vehicle Class Hierarchy Initialization
class Vehicle {
    var numberOfWheels: Int
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }

    // Designated Initializer for Vehicle
    init(numberOfWheels: Int) {
        self.numberOfWheels = numberOfWheels
    }

    // A convenience initializer
    convenience init() {
        self.init(numberOfWheels: 0) // Delegates to designated initializer
    }
}

class Bicycle: Vehicle {
    var hasBasket: Bool

    // Overriding a designated initializer from Vehicle
    override init(numberOfWheels: Int) { // Matches Vehicle's designated init
        self.hasBasket = false // Initialize own property first (Safety Check 1)
        super.init(numberOfWheels: numberOfWheels) // Delegate up (Safety Check 1)
        // Can now modify inherited properties or call methods in Phase 2
    }

    // A custom designated initializer for Bicycle
    init(hasBasket: Bool) {
        self.hasBasket = hasBasket
        super.init(numberOfWheels: 2) // Delegates up to Vehicle's designated init
    }

    // A convenience initializer for Bicycle
    convenience init(withBasket: Bool) {
        self.init(hasBasket: withBasket) // Delegates across to another Bicycle initializer
    }
}

print("\n--- Class Inheritance and Initialization ---")

let genericVehicle = Vehicle()
print("Generic Vehicle: \(genericVehicle.description)") // Expected: "0 wheel(s)"

let basicBicycle = Bicycle(numberOfWheels: 2) // Using overridden init
print("Basic Bicycle: \(basicBicycle.description), Basket: \(basicBicycle.hasBasket)") // Expected: "2 wheel(s), Basket: false"

let shoppingBicycle = Bicycle(hasBasket: true) // Using custom designated init
print("Shopping Bicycle: \(shoppingBicycle.description), Basket: \(shoppingBicycle.hasBasket)") // Expected: "2 wheel(s), Basket: true"

let touringBicycle = Bicycle(withBasket: false) // Using convenience init
print("Touring Bicycle: \(touringBicycle.description), Basket: \(touringBicycle.hasBasket)") // Expected: "2 wheel(s), Basket: false"

/*:
 ### Required Initializers

 **Definition:** You use the `required` modifier to ensure that every subclass of a class implements a specific designated initializer. This means that if a superclass defines a `required` initializer, all its direct and indirect subclasses **must** provide an implementation for that initializer, either by defining it directly or by inheriting it (which is only possible if they override all of the superclass's designated initializers, including the `required` one, and then inherit a default implementation of the `required` initializer).

 The `required` modifier is written before the `init` keyword.

 */
// Example: Animal hierarchy with a required initializer
class Animal {
    var species: String

    // Definition: A required designated initializer
    required init(species: String) {
        self.species = species
    }

    func makeSound() {
        print("Generic animal sound.")
    }
}

class Dog: Animal {
    var breed: String

    // Must implement the required initializer from Animal
    // 'override' is implicit for required initializers in subclasses
    required init(species: String) {
        self.breed = "Unknown" // Initialize own property first
        super.init(species: species) // Delegate up
        print("A \(self.breed) \(self.species) is being initialized.")
    }

    init(breed: String, species: String) {
        self.breed = breed
        super.init(species: species)
        print("A \(self.breed) \(self.species) with specific breed is being initialized.")
    }

    override func makeSound() {
        print("Woof!")
    }
}

class Cat: Animal {
    var livesLeft: Int

    // Must implement the required initializer from Animal
    required init(species: String) {
        self.livesLeft = 9 // Initialize own property
        super.init(species: species) // Delegate up
        print("A \(self.species) with \(self.livesLeft) lives left is being initialized.")
    }

    init(livesLeft: Int, species: String) {
        self.livesLeft = livesLeft
        super.init(species: species)
    }

    override func makeSound() {
        print("Meow!")
    }
}

print("\n--- Required Initializers ---")
let mysteryAnimal = Animal(species: "Mystery Creature")
mysteryAnimal.makeSound()

let strayDog = Dog(species: "Canine") // Calls the required initializer
strayDog.makeSound()
print("Stray dog breed: \(strayDog.breed)")

let fluffyCat = Cat(species: "Feline") // Calls the required initializer
fluffyCat.makeSound()
print("Fluffy cat lives left: \(fluffyCat.livesLeft)")

let goldenRetriever = Dog(breed: "Golden Retriever", species: "Canine") // Calls custom init
goldenRetriever.makeSound()

/*:
 ### Failable Initializers

 **Definition:** A **failable initializer** is an initializer that might fail to create an instance of a type. This is useful when initialization might not always succeed due to invalid input values, missing external resources, or other conditions. A failable initializer returns an **optional** value of the type it initializes (`TypeName?`). If the initialization fails, it returns `nil`.

 You define a failable initializer by placing a question mark (`?`) after the `init` keyword (e.g., `init?`). A failable initializer can delegate to another failable initializer (using `self.init?()` or `super.init?()`) or to a non-failable initializer. A non-failable initializer cannot delegate to a failable one.

 */
// Example: Animal with a failable initializer based on name validity
class NamedAnimal {
    let name: String
    let species: String

    // Definition: A failable initializer
    init?(name: String, species: String) {
        guard !name.isEmpty else {
            print("Initialization failed: Animal name cannot be empty.")
            return nil // Return nil if initialization conditions are not met
        }
        self.name = name
        self.species = species
    }
}

// Example with an enumeration
enum TemperatureUnit: String {
    case celsius, fahrenheit, kelvin

    // Failable initializer to create a unit from a raw string value
    init?(symbol: Character) {
        switch symbol {
        case "C": self = .celsius
        case "F": self = .fahrenheit
        case "K": self = .kelvin
        default: return nil // Fail if symbol is not recognized
        }
    }
}


print("\n--- Failable Initializers ---")

// Successful initialization
if let lion = NamedAnimal(name: "Simba", species: "Lion") {
    print("Successfully created animal: \(lion.name) the \(lion.species).")
} else {
    print("Failed to create animal.")
}
// Expected: "Successfully created animal: Simba the Lion."

// Failed initialization
if let namelessAnimal = NamedAnimal(name: "", species: "Unknown") {
    print("Successfully created animal: \(namelessAnimal.name) the \(namelessAnimal.species).")
} else {
    print("Failed to create animal.")
}
// Expected: "Initialization failed: Animal name cannot be empty."
// Expected: "Failed to create animal."

// Failable init for enum
if let unitC = TemperatureUnit(symbol: "C") {
    print("Unit from symbol 'C': \(unitC)") // Expected: celsius
}

if let unitX = TemperatureUnit(symbol: "X") {
    print("Unit from symbol 'X': \(unitX)")
} else {
    print("Failed to initialize TemperatureUnit from symbol 'X'.") // Expected: Failed...
}

