import UIKit

// MARK: - 📘 DEFINITIONS

// ✅ STRUCTURE:
// A structure is a **value type** used to encapsulate related properties and behavior.
// Structures are copied when assigned or passed around in code.
// Commonly used for data models, lightweight objects, and immutability.

struct SampleStruct {
    var value: Int
}

// ✅ CLASS:
// A class is a **reference type** that encapsulates data and behavior.
// Classes support inheritance and identity checking.
// Used when shared mutable state or object identity is important.

class SampleClass {
    var value: Int
    init(value: Int) {
        self.value = value
    }
}

// MARK: - ✅ COMMON BEHAVIOR BETWEEN STRUCTURE AND CLASS

// Both can have properties, methods, initializers, subscripts, extensions, and protocol conformance.

struct UserStruct {
    var name: String
    func greet() {
        print("Hello, \(name) from Struct!")
    }
}

class UserClass {
    var name: String
    init(name: String) {
        self.name = name
    }
    func greet() {
        print("Hello, \(name) from Class!")
    }
}

let structUser = UserStruct(name: "Alice")
structUser.greet() // Hello, Alice from Struct!

let classUser = UserClass(name: "Bob")
classUser.greet()  // Hello, Bob from Class!

// MARK: - ✅ STRUCTURE (VALUE TYPE)

struct Resolution {
    var width: Int
    var height: Int
}

let hd = Resolution(width: 1920, height: 1080)
var cinema = hd
cinema.width = 2048

print("cinema is now \(cinema.width) pixels wide") // 2048
print("hd is still \(hd.width) pixels wide")       // 1920

// MARK: - ✅ ENUM (ALSO VALUE TYPE)

enum CompassPoint {
    case north, south, east, west
    mutating func turnNorth() {
        self = .north
    }
}

var currentDirection = CompassPoint.west
let rememberedDirection = currentDirection
currentDirection.turnNorth()

print("Current direction: \(currentDirection)")         // north
print("Remembered direction: \(rememberedDirection)")   // west

// MARK: - ✅ CLASS (REFERENCE TYPE)

class VideoMode {
    var resolution = Resolution(width: 0, height: 0)
    var interlaced = false
    var frameRate = 0.0
    var name: String?
}

let tenEighty = VideoMode()
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0

print("tenEighty frameRate: \(tenEighty.frameRate)")       // 30.0
print("alsoTenEighty frameRate: \(alsoTenEighty.frameRate)") // 30.0

// MARK: - ✅ IDENTITY OPERATORS (===, !==)

if tenEighty === alsoTenEighty {
    print("tenEighty and alsoTenEighty refer to the same instance.")
}

// MARK: - ✅ STRUCT vs CLASS COPY BEHAVIOR

struct BookStruct {
    var title: String
}

class BookClass {
    var title: String
    init(title: String) {
        self.title = title
    }
}

var structBook1 = BookStruct(title: "Swift Basics")
var structBook2 = structBook1
structBook2.title = "Swift Advanced"

print("Struct Book1 title: \(structBook1.title)") // Swift Basics
print("Struct Book2 title: \(structBook2.title)") // Swift Advanced

let classBook1 = BookClass(title: "Swift Basics")
let classBook2 = classBook1
classBook2.title = "Swift Advanced"

print("Class Book1 title: \(classBook1.title)")   // Swift Advanced
print("Class Book2 title: \(classBook2.title)")   // Swift Advanced

// MARK: - ✅ STRUCT INSIDE CLASS (still value type, but shared via reference to class)

class Wrapper {
    var res = Resolution(width: 640, height: 480)
}

let wrap1 = Wrapper()
let wrap2 = wrap1
wrap2.res.width = 800

print("wrap1 width: \(wrap1.res.width)") // 800 (class reference is shared)

// MARK: - ✅ CLASS INSIDE STRUCT (class reference is shared, even if struct is copied)

class Engine {
    var power = 100
}

struct Car {
    var engine = Engine()
}

var car1 = Car()
var car2 = car1
car2.engine.power = 200

print("car1 engine power: \(car1.engine.power)") // 200
print("car2 engine power: \(car2.engine.power)") // 200

// Even though Car is a struct, its class property `engine` shares the same reference
