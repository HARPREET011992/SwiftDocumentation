import Foundation

// MARK: ✅ What Are Methods?
/*
 Methods are functions associated with a type (class, struct, or enum).

 🔸 Instance Methods → tied to a specific instance.
 🔸 Type Methods     → tied to the type itself.
*/


// MARK: 📍 Instance Methods

class Counter {
    var count = 0

    func increment() {
        count += 1
    }

    func increment(by amount: Int) {
        count += amount
    }

    func reset() {
        count = 0
    }
}

// Usage
let counter = Counter()
counter.increment()
counter.increment(by: 5)
counter.reset()


// MARK: 🔹 self Keyword Example
/*
 `self` refers to the current instance.
 It's required when parameter names conflict with property names.
*/

struct Point {
    var x = 0.0
    func isToTheRightOf(x: Double) -> Bool {
        return self.x > x
    }
}

let point = Point(x: 4.0)
print(point.isToTheRightOf(x: 2.0)) // true


// MARK: 🔧 Mutating Methods (for Structs & Enums)
/*
 Structs and enums are value types.
 To modify `self` or properties, methods must be marked as `mutating`.
*/

struct MovePoint {
    var x = 0.0, y = 0.0

    mutating func moveBy(x: Double, y: Double) {
        self = MovePoint(x: self.x + x, y: self.y + y)
    }
}

var mp = MovePoint(x: 1.0, y: 1.0)
mp.moveBy(x: 2.0, y: 3.0)
print("Moved point: (\(mp.x), \(mp.y))") // (3.0, 4.0)


// MARK: 🔁 Enum with Mutating Method

enum TriStateSwitch {
    case off, low, high

    mutating func next() {
        switch self {
        case .off: self = .low
        case .low: self = .high
        case .high: self = .off
        }
    }
}

var ovenSwitch = TriStateSwitch.low
ovenSwitch.next()
print(ovenSwitch) // high
ovenSwitch.next()
print(ovenSwitch) // off


// MARK: 🧱 Type Methods
/*
 Type methods belong to the type itself.

 🔹 Use `static` for structs and enums.
 🔹 Use `class` for classes (supports override).
*/

class SomeClass {
    class func someTypeMethod() {
        print("This is a type method.")
    }
}

SomeClass.someTypeMethod()


// MARK: 💡 @discardableResult
/*
 If a method returns a value, but it's okay to ignore the result,
 use `@discardableResult` to avoid compiler warnings.

 This is useful when a result is optional or secondary.
*/

struct Calculator {
    @discardableResult
    func add(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
}

let calc = Calculator()
print(calc.add(2, 3)) // ✅ No warning even though the result is not used
