/*:
 # Type Casting: Vehicles Example

 ## Definition
 **Type casting** in Swift allows you to check the type of an instance and/or treat that instance as a different class within its own class hierarchy. This is crucial when dealing with inheritance, enabling you to interact with objects based on their specific subclass or a more general superclass.

 Swift provides two operators for type casting:
 - **`is`**: Used to *check* if an instance is of a particular class type. It returns `true` or `false`.
 - **`as` (`as?` and `as!`)**: Used to *cast* an instance to a different type.
    - **`as?` (Conditional Downcast)**: Returns an *optional* value of the target type. Use this when you're unsure if the cast will succeed. If the cast fails, it returns `nil`.
    - **`as!` (Forced Downcast)**: Forces the cast to the target type. Only use this when you are *absolutely certain* the cast will succeed, as a failed forced cast will result in a runtime error.

 */

// MARK: - Defining a Class Hierarchy for Type Casting

/*:
 Let's imagine we're building a system to manage different types of vehicles. We'll start with a base `Vehicle` class and then create more specific subclasses.
 */

class Vehicle {
    var brand: String
    var model: String

    init(brand: String, model: String) {
        self.brand = brand
        self.model = model
    }

    func startEngine() {
        print("\(brand) \(model) engine starting...")
    }
}

class Car: Vehicle {
    var numberOfDoors: Int

    init(brand: String, model: String, numberOfDoors: Int) {
        self.numberOfDoors = numberOfDoors
        super.init(brand: brand, model: model)
    }

    func drive() {
        print("Driving the \(brand) \(model) with \(numberOfDoors) doors.")
    }
}

class Motorcycle: Vehicle {
    var hasSidecar: Bool

    init(brand: String, model: String, hasSidecar: Bool) {
        self.hasSidecar = hasSidecar
        super.init(brand: brand, model: model)
    }

    func ride() {
        let sidecarStatus = hasSidecar ? "with a sidecar" : "without a sidecar"
        print("Riding the \(brand) \(model) \(sidecarStatus).")
    }
}

class Truck: Vehicle {
    var cargoCapacityTons: Double

    init(brand: String, model: String, cargoCapacityTons: Double) {
        self.cargoCapacityTons = cargoCapacityTons
        super.init(brand: brand, model: model)
    }

    func haulCargo() {
        print("Hauling \(cargoCapacityTons) tons of cargo with the \(brand) \(model).")
    }
}

/*:
 Now, let's create an array of `Vehicle` instances. Even though we're adding `Car`, `Motorcycle`, and `Truck` objects, the array's inferred type will be `[Vehicle]`.
 */

let garage: [Vehicle] = [
    Car(brand: "Toyota", model: "Camry", numberOfDoors: 4),
    Motorcycle(brand: "Harley-Davidson", model: "Street Glide", hasSidecar: false),
    Truck(brand: "Ford", model: "F-150", cargoCapacityTons: 1.5),
    Car(brand: "Tesla", model: "Model S", numberOfDoors: 4),
    Motorcycle(brand: "Ural", model: "Gear Up", hasSidecar: true)
]

// MARK: - Checking Type with `is`

/*:
 We can use the **`is`** operator to count how many of each specific vehicle type are in our `garage`.
 */

var carCount = 0
var motorcycleCount = 0
var truckCount = 0

for item in garage {
    if item is Car {
        carCount += 1
    } else if item is Motorcycle {
        motorcycleCount += 1
    } else if item is Truck {
        truckCount += 1
    }
}

print("Our garage contains:")
print("- \(carCount) cars")
print("- \(motorcycleCount) motorcycles")
print("- \(truckCount) trucks")
// Expected Output:
// Our garage contains:
// - 2 cars
// - 2 motorcycles
// - 1 trucks

// MARK: - Downcasting with `as?` and `as!`

/*:
 To access the specialized properties and methods of `Car`, `Motorcycle`, or `Truck` instances, we need to **downcast** them from `Vehicle` to their specific types.

 We'll primarily use **`as?`** because we don't know the exact type of each `item` in the `garage` beforehand.
 */

print("\n--- Detailed Vehicle Actions in Garage ---")
for vehicle in garage {
    vehicle.startEngine() // All vehicles can start their engine (from base class)

    if let car = vehicle as? Car {
        car.drive() // Only Cars can drive
    } else if let motorcycle = vehicle as? Motorcycle {
        motorcycle.ride() // Only Motorcycles can ride
    } else if let truck = vehicle as? Truck {
        truck.haulCargo() // Only Trucks can haul cargo
    }
    print("---")
}

/*:
 **Important Note:** Downcasting does not change the instance itself; it merely allows you to treat it as a more specific type within the same class hierarchy.

 ---

 ## Type Casting for `Any` and `AnyObject`

 These are special types for handling values of *any* type (`Any`) or *any class* type (`AnyObject`). They are less common but useful for scenarios where types are truly unknown until runtime.
 */

var mixedBag: [Any] = []
mixedBag.append(Car(brand: "Audi", model: "A4", numberOfDoors: 4))
mixedBag.append(42) // Int
mixedBag.append("Hello Swift") // String
mixedBag.append({ (name: String) -> String in "Greeting: \(name)" }) // A closure
mixedBag.append(true) // Bool

print("\n--- Contents of 'mixedBag' ---")
for item in mixedBag {
    switch item {
    case let car as Car:
        print("Found a Car: \(car.brand) \(car.model)")
    case let number as Int:
        print("Found an Integer: \(number)")
    case let text as String:
        print("Found a String: \"\(text)\"")
    case let greetingFunction as (String) -> String:
        print(greetingFunction("Developer"))
    case is Bool:
        print("Found a Boolean value.")
    default:
        print("Found something else.")
    }
}

