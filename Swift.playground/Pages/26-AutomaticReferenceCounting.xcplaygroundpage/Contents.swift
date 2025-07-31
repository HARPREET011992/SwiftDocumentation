import Foundation

// Swift use ARC(Automatic reference counting) to track and manage your apps memory

class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

var reference1: Person?
var reference2: Person?
var reference3: Person?

reference1 = Person(name: "Alice")
reference2 = reference1
reference3 = reference2

reference1 = nil
reference2 = nil
reference3 = nil



class User {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    unowned var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}


class Apartment {
    let unit: String
    init(unit: String) {
        self.unit = unit
        print("\(unit) is being initialized")
    }
    var tenant: User?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: User?
var unit4A: Apartment?

john = User(name: "John")
unit4A = Apartment(unit: "4A")

john?.apartment = unit4A
unit4A?.tenant = john

john = nil
unit4A = nil
