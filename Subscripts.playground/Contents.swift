import Foundation

// ✅ MARK: - What Are Subscripts?
// Subscripts are shortcuts to access elements in a collection, list, or sequence using [] syntax.
// Similar to computed properties but can take parameters.
// Available in: Classes, Structs, and Enums.


// ✅ MARK: - Basic Subscript Syntax

struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index // read-only subscript
    }
}

let threeTimesTable = TimesTable(multiplier: 3)
print("6 × 3 = \(threeTimesTable[6])") // 🧪 Output: 18


// ✅ MARK: - Read-Write Subscript

struct MyList {
    var items = [1, 2, 3, 4, 5]

    subscript(index: Int) -> Int {
        get { return items[index] }
        set { items[index] = newValue }
    }
}

var list = MyList()
print("Before: \(list[2])") // 🧪 Output: 3
list[2] = 99
print("After: \(list[2])")  // 🧪 Output: 99


// ✅ MARK: - Dictionary Style Subscript (Optional Return)

var numberOfLegs = ["spider": 8, "ant": 6, "cat": 4]
numberOfLegs["bird"] = 2
print("Bird has \(numberOfLegs["bird"] ?? 0) legs") // 🧪 Output: 2


// ✅ MARK: - Multi-Parameter Subscript Example

struct Grid {
    var values = [[0, 1], [2, 3]]

    subscript(row: Int, col: Int) -> Int {
        get {
            return values[row][col]
        }
        set {
            values[row][col] = newValue
        }
    }
}

var grid = Grid()
grid[0, 1] = 9
print("grid[0,1]: \(grid[0, 1])") // 🧪 Output: 9



// ✅ MARK: - Type Subscripts (Used on Type Itself)

enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune

    static subscript(n: Int) -> Planet {
        return Planet(rawValue: n)!
    }
}

let mars = Planet[4]
print("Planet[4]: \(mars)") // 🧪 Output: mars


// ✅ MARK: - Summary Notes
/*
- Subscripts allow accessing values using square bracket syntax.
- Can be read-only or read-write.
- Can be overloaded based on input parameter types.
- Can have multiple parameters.
- Subscripts return any type, including optionals.
- Type subscripts use `static` or `class` keyword.
*/


// ✅ BONUS: Custom Subscript with String Keys
struct AnimalInfo {
    var data = ["cat": "Meows", "dog": "Barks", "cow": "Moos"]

    subscript(animal: String) -> String {
        return data[animal, default: "Unknown sound"]
    }
}

let sounds = AnimalInfo()
print("A cat \(sounds["cat"])") // 🧪 Output: A cat Meows
print("A fox \(sounds["fox"])") // 🧪 Output: A fox Unknown sound
