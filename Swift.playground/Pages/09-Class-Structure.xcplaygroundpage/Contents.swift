import Foundation

// MARK: - Reference Type Example
class User {
    var name: String
    var email: String

    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}

var user1 = User(name: "Harpreet", email: "Harpreet@gmail.com")
var user2 = user1  // Both variables refer to the same heap object

// Print the actual heap address of the class instance (not the variable)
print("Heap address of user1 =", Unmanaged.passUnretained(user1).toOpaque())
print("Heap address of user2 =", Unmanaged.passUnretained(user2).toOpaque())

// MARK: - Value Type Example
struct Address {
    var street: String
    var city: String
}

var a1 = Address(street: "abc Road", city: "AB")
var a2 = a1  // Value type: a2 is a **copy** of a1

// Print memory addresses of the struct variables (stack memory)
withUnsafePointer(to: &a1) { print("Stack address of a1 =", $0) }
withUnsafePointer(to: &a2) { print("Stack address of a2 =", $0) }

// MARK: - Struct Containing a Class

/// A struct containing both a value type and a reference type
struct Person {
    var user: User       // reference type
    var address: Address // value type
}

var p1 = Person(user: user1, address: a1)
var p2 = p1  // Entire struct is copied (but reference inside still points to same User instance)

// Print addresses of the struct instances
withUnsafePointer(to: &p1) { print("Stack address of p1 =", $0) }
withUnsafePointer(to: &p2) { print("Stack address of p2 =", $0) }

// Print addresses of the nested class objects inside each struct
print("Heap address of p1.user =",Unmanaged.passUnretained(p1.user).toOpaque())
print("Heap address of p2.user =",Unmanaged.passUnretained(p2.user).toOpaque())

// MARK: - Class Containing a Structure

class Car {
    var model: String
    var address: Address

    init(model: String, address: Address) {
        self.model = model
        self.address = address
    }

    func clone() -> Car {
        return Car(model: self.model,address: self.address)
    }

}
let a12 = Address(street: "Abc", city: "nm")
let a22 = Address(street: "Abc1", city: "nm1")
let m1 = Car(model: "m1", address: a1)
let m2 = m1.clone()

m1.address = a22
//m1.changeCity()

print(m1.address.city)
print(m2.address.city)
