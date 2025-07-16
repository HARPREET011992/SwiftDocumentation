import Foundation

// MARK: - 🔷 Important Definition: Error Handling
/// Error handling is the process of responding to and recovering from error conditions in your program.
/// Swift supports throwing, catching, propagating, and handling recoverable errors at runtime.

// MARK: - 🔷 Representing and Throwing Errors

enum VendingMachineError: Error {
    case invalidSelection
    case insufficientFunds(coinsNeeded: Int)
    case outOfStock
}

// Throwing an error
// throw VendingMachineError.insufficientFunds(coinsNeeded: 5)

// MARK: - 🔷 Throwing Functions

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0

    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }
        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }
        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }

        coinsDeposited -= item.price
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        print("Dispensing \(name)")
    }
}

// MARK: - 🔷 Propagating Errors

let favoriteSnacks = [
    "Alice": "Chips",
    "Bob": "Licorice",
    "Eve": "Pretzels"
]

func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    try vendingMachine.vend(itemNamed: snackName)
}

// MARK: - 🔷 Throwing Initializer

struct PurchasedSnack {
    let name: String
    init(name: String, vendingMachine: VendingMachine) throws {
        try vendingMachine.vend(itemNamed: name)
        self.name = name
    }
}

// MARK: - 🔷 Handling Errors with do-catch

var machine = VendingMachine()
machine.coinsDeposited = 8

do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: machine)
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error)")
}

// MARK: - 🔷 Catching Specific Errors in do-catch

@MainActor
func nourish(with item: String) throws {
    do {
        try machine.vend(itemNamed: item)
    } catch is VendingMachineError {
        print("Couldn't buy that from the vending machine.")
    }
}

do {
    try nourish(with: "Beet-Flavored Chips")
} catch {
    print("Unexpected error: \(error)")
}

// MARK: - 🔷 Catching Multiple Errors Together

@MainActor
func eat(item: String) throws {
    do {
        try machine.vend(itemNamed: item)
    } catch VendingMachineError.invalidSelection,
            VendingMachineError.insufficientFunds,
            VendingMachineError.outOfStock {
        print("Invalid selection, out of stock, or not enough money.")
    }
}

// MARK: - 🔷 try? – Converting Errors to Optionals

func someThrowingFunction() throws -> Int {
    return 42
}

let x = try? someThrowingFunction() // x is Int?
print("try? result:", x ?? -1)

// MARK: - 🔷 try! – Disabling Error Propagation

func loadImage(atPath path: String) throws -> String {
    guard path.contains(".jpg") else {
        throw NSError(domain: "InvalidPath", code: 0, userInfo: nil)
    }
    return "Image loaded from \(path)"
}

let image = try! loadImage(atPath: "./Resources/John Appleseed.jpg")
print(image)

// MARK: - 🔷 Typed Throws

enum StatisticsError: Error {
    case noRatings
    case invalidRating(Int)
}

func summarize(_ ratings: [Int]) throws(StatisticsError) {
    guard !ratings.isEmpty else { throw .noRatings }
    var counts = [1: 0, 2: 0, 3: 0]
    for rating in ratings {
        guard rating >= 1 && rating <= 3 else { throw .invalidRating(rating) }
        counts[rating]! += 1
    }
    print("*", counts[1]!, "-- **", counts[2]!, "-- ***", counts[3]!)
}

do {
    try summarize([])
} catch {
    switch error {
    case StatisticsError.noRatings:
        print("No ratings available.")
    case StatisticsError.invalidRating(let rating):
        print("Invalid rating: \(rating)")
//    default:
//        print("Unknown error.")
    }
}

// MARK: - 🔷 defer – Cleanup Actions

func processFile() throws {
    print("Opening file...")
    defer {
        print("Closing file...")
    }
    throw NSError(domain: "FileError", code: 1, userInfo: nil)
}

do {
    try processFile()
} catch {
    print("Caught file error.")
}
