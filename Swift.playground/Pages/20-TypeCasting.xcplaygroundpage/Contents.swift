import Foundation

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

let garage: [Vehicle] = [
    Car(brand: "Toyota", model: "Camry", numberOfDoors: 4),
    Motorcycle(brand: "Harley-Davidson", model: "Street Glide", hasSidecar: false),
    Truck(brand: "Ford", model: "F-150", cargoCapacityTons: 1.5),
    Car(brand: "Tesla", model: "Model S", numberOfDoors: 4),
    Motorcycle(brand: "Ural", model: "Gear Up", hasSidecar: true)
]

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
