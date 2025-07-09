import UIKit

// MARK: - Collection Types: Array, Set, Dictionary

// MARK: - Array

// Initialize empty arrays
var someInts = [Int]()
var anotherInts: [Int] = []

// Initialize array with default values
var numberArray = Array(repeating: 0, count: 5)

// Accessing and modifying array
var shoppingList = ["Eggs", "Milk"]

// Count and isEmpty
print("Shopping list count: \(shoppingList.count)")
print(shoppingList.isEmpty ? "Shopping list is empty" : "Shopping list has \(shoppingList.count) items")

// Append items
shoppingList.append("Bread")
shoppingList += ["Apples", "Bananas"]
print("Shopping list after appending: \(shoppingList)")

// Retrieve value by index
let firstItem = shoppingList[0]
print("First item: \(firstItem)")

// Iterate over array
for item in shoppingList {
    print("Item: \(item)")
}

for (index, value) in shoppingList.enumerated() {
    print("Item \(index + 1): \(value)")
}

// Prefix and suffix equality
let prefix = ["Eggs", "Milk"]
if shoppingList.starts(with: prefix) {
    print("Shopping list starts with \(prefix)")
}

let suffix = ["Apples", "Bananas"]
if shoppingList.suffix(2) == suffix {
    print("Shopping list ends with \(suffix)")
}

// MARK: - Set

// Initialize empty set
var letters = Set<Character>()
letters.insert("a")
letters = []  // still of type Set<Character>

// Create set with array literal
var favoriteGenres: Set = ["Rock", "Classical", "Hip hop"]

// Count and isEmpty
print("Favorite genres count: \(favoriteGenres.count)")
print(favoriteGenres.isEmpty ? "No favorite genres" : "Some favorite genres exist")

// Add and remove items
favoriteGenres.insert("Jazz")
if let removed = favoriteGenres.remove("Rock") {
    print("Removed genre: \(removed)")
}

// Contains
if favoriteGenres.contains("Funk") {
    print("Includes Funk")
} else {
    print("No Funk here")
}

// Iterate set
for genre in favoriteGenres {
    print("Genre: \(genre)")
}

// Sorted iteration
for genre in favoriteGenres.sorted() {
    print("Sorted genre: \(genre)")
}

// Set operations
let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let primeDigits: Set = [2, 3, 5, 7]

print("Union: \(oddDigits.union(evenDigits).sorted())")
print("Intersection: \(oddDigits.intersection(evenDigits).sorted())")
print("Subtraction: \(oddDigits.subtracting(primeDigits).sorted())")
print("Symmetric Difference: \(oddDigits.symmetricDifference(primeDigits).sorted())")

// Set membership and equality
let houseAnimals: Set = ["🐶", "🐱"]
let farmAnimals: Set = ["🐮", "🐔", "🐑", "🐶", "🐱"]
let cityAnimals: Set = ["🐦", "🐭"]

print("house ⊆ farm: \(houseAnimals.isSubset(of: farmAnimals))")
print("farm ⊇ house: \(farmAnimals.isSuperset(of: houseAnimals))")
print("farm ∩ city = ∅: \(farmAnimals.isDisjoint(with: cityAnimals))")

// MARK: - Dictionary

// Initialize empty dictionary
var namesOfIntegers: [Int: String] = [:]
namesOfIntegers[16] = "Sixteen"
namesOfIntegers = [:]

// Dictionary literal
var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

// Count and isEmpty
print("Airports count: \(airports.count)")
print(airports.isEmpty ? "No airports" : "Airports available")

// Add/update items
airports["LHR"] = "London"
airports["LHR"] = "London Heathrow"
if let oldValue = airports.updateValue("Dublin Airport", forKey: "DUB") {
    print("Replaced old value: \(oldValue)")
}

// Retrieve value
if let airportName = airports["DUB"] {
    print("Airport name: \(airportName)")
} else {
    print("Airport not found")
}

// Remove item
airports["APL"] = "Apple International"
airports["APL"] = nil

if let removedAirport = airports.removeValue(forKey: "DUB") {
    print("Removed airport: \(removedAirport)")
}

// Iterate over dictionary
for (code, name) in airports {
    print("\(code): \(name)")
}

// Iterate keys and values
for code in airports.keys {
    print("Airport code: \(code)")
}

for name in airports.values {
    print("Airport name: \(name)")
}

// Convert to array
let airportCodes = Array(airports.keys)
let airportNames = Array(airports.values)
print("Airport codes: \(airportCodes)")
print("Airport names: \(airportNames)")
