import Foundation

class Car {
    var model: String
    var makingYear: Int
    var numberOfDoors: Int

    init(model: String, makingYear: Int, numberOfDoors: Int) {
        self.model = model
        self.makingYear = makingYear
        self.numberOfDoors = numberOfDoors
    }
    deinit {
        print("all objects got deinitialized")
    }
}

var c1: Car? = Car(model: "black", makingYear: 56, numberOfDoors: 2)
print(c1)
c1 = nil


// Retain cycle
// to break reatin cycle make either appartment weak or person weak
class Person {
    var name: String
    var apartment: Apartment?

    init(name: String) {
        self.name = name
        print("Person \(name) initialized")
    }

    deinit {
        print("Person \(name) deinitialized")
    }
}

class Apartment {
    var unit: String
    var tenant: Person?

    init(unit: String) {
        self.unit = unit
        print("Apartment \(unit) initialized")
    }

    deinit {
        print("Apartment \(unit) deinitialized")
    }
}

// Creating the retain cycle
var john: Person? = Person(name: "John")
var apt: Apartment? = Apartment(unit: "4A")

john?.apartment = apt
apt?.tenant = john

// Breaking strong references
john = nil
apt = nil // ❌ deinit will not be called — memory leak due to retain cycle

