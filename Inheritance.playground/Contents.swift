import UIKit

// MARK: - Inheritance in Swift
/*
Inheritance allows a class (subclass) to inherit methods,
properties, and other characteristics from another class (superclass).

- Base Class: A class without a superclass.
- Subclass: A class that inherits from another class.
- Overriding: Subclasses can provide their own implementation
  of methods, properties, or subscripts.
- Property Observers: Subclasses can observe changes to inherited properties.
- Preventing Overrides: Use 'final' to stop overriding or subclassing.
*/

// MARK: - Base Class Definition
/*
A base class defines common properties and methods.
Classes without a superclass are base classes by default.
*/
class Vehicle {
    var currentSpeed = 0.0

    // Computed property describing current speed
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }

    // Method that can be overridden by subclasses
    func makeNoise() {
        // Base Vehicle makes no noise by default
    }
}

// MARK: - Subclassing
/*
Subclassing creates a new class based on an existing one,
inheriting its behavior and allowing additional features.
*/
class Bicycle: Vehicle {
    var hasBasket = false
}

// MARK: - Overriding Methods
/*
Override methods to provide a custom implementation in a subclass.
Use 'override' keyword to make sure the superclass has the method.
*/
class Train: Vehicle {
    override func makeNoise() {
        print("Choo Choo")
    }
}

// MARK: - Overriding Properties
/*
Override properties to customize getters/setters or add observers.
Use 'super' to call the superclass implementation if needed.
*/
class Car: Vehicle {
    var gear = 1

    override var description: String {
        // Extend the base description with gear info
        return super.description + " in gear \(gear)"
    }
}

// MARK: - Overriding Property Observers
/*
Add property observers (willSet/didSet) to inherited properties
to respond when their values change.
*/
class AutomaticCar: Car {
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10) + 1
        }
    }
}

// MARK: - Preventing Overrides
/*
Use 'final' to prevent overriding or subclassing.

- final func: Cannot be overridden by subclasses.
- final class: Cannot be subclassed.
*/
final class FinalVehicle {
    final func noOverrideAllowed() {
        print("This method can't be overridden.")
    }
}

// MARK: - Examples & Testing

// Create Bicycle instance, set properties, and print description
let bike = Bicycle()
bike.currentSpeed = 15.0
bike.hasBasket = true
print("Bicycle: \(bike.description), Has Basket? \(bike.hasBasket)")

// Create Train instance and call overridden makeNoise()
let train = Train()
train.makeNoise() // Prints: Choo Choo

// Create Car instance, set gear and speed, print description
let car = Car()
car.currentSpeed = 25.0
car.gear = 3
print("Car: \(car.description)")

// Create AutomaticCar instance, change speed to auto-update gear
let automatic = AutomaticCar()
automatic.currentSpeed = 35.0
print("AutomaticCar: \(automatic.description)")

