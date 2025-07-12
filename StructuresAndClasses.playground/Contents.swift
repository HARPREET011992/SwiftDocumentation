import UIKit

// class and structure are custom types which is used to define properties and method
// MARK: - Struct Definition (Value Type)
struct Resolution {
    var width: Int
    var height: Int
}

// Memberwise initializer (automatically available for structs)
let hd = Resolution(width: 1920, height: 1080)
var cinema = hd // Copy of hd

// Changing cinema doesn’t affect hd
cinema.width = 2048
print("cinema is now \(cinema.width) pixels wide") // 2048
print("hd is still \(hd.width) pixels wide")       // 1920

// MARK: - Enum as Value Type
enum CompassPoint {
    case north, south, east, west
    mutating func turnNorth() {
        self = .north
    }
}

var currentDirection = CompassPoint.west
let rememberedDirection = currentDirection
currentDirection.turnNorth()

print("The current direction is \(currentDirection)")         // north
print("The remembered direction is \(rememberedDirection)")   // west

// MARK: - Class Definition (Reference Type)
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

// Since it's a reference type, both refer to the same instance
print("The frameRate of tenEighty is \(tenEighty.frameRate)")       // 30.0
print("The frameRate of alsoTenEighty is \(alsoTenEighty.frameRate)") // 30.0

// Identity Check (===)
if tenEighty === alsoTenEighty {
    print("tenEighty and alsoTenEighty refer to the same instance.")
}

// MARK: - Extra Demonstration (Class vs Struct Behavior)
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
