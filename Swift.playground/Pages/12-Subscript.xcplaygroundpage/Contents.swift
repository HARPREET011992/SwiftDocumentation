import Foundation

// MARK: - Struct with Instance Subscript
struct NumberList {
    var numbers: [Int]

    subscript(index: Int) -> Int {
        get {
            return numbers[index]
        }
        set {
            numbers[index] = newValue
        }
    }
}

var myList = NumberList(numbers: [1, 2, 3])
print("Struct:", myList[0]) // Output: 2
myList[1] = 20
print("Updated Struct:", myList[1]) // Output: 20


// MARK: - Class with Overridable Subscript
class Matrix {
    var values: [[Int]]

    init(values: [[Int]]) {
        self.values = values
    }

    subscript(row: Int, col: Int) -> Int {
        get {
            return values[row][col]
        }
        set {
            values[row][col] = newValue
        }
    }
}

class IdentityMatrix: Matrix {
    override subscript(row: Int, col: Int) -> Int {
        get {
            return row == col ? 1 : 0
        }
        set {
            print("Identity matrix can't be modified.")
        }
    }
}

let regularMatrix = Matrix(values: [[1, 2], [3, 4]])
print("Class:", regularMatrix[1, 0]) // Output: 3

let identity = IdentityMatrix(values: [[0, 0], [0, 0]])
print("Overridden Class:", identity[0, 0]) // Output: 1
identity[0, 1] = 5 // Will print warning


// MARK: - Enum with Static Subscript
enum Day: Int, CaseIterable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

    static subscript(index: Int) -> Day? {
        return Day(rawValue: index)
    }
}

if let day = Day[3] {
    print("Enum (static subscript):", day) // Output: tuesday
}
