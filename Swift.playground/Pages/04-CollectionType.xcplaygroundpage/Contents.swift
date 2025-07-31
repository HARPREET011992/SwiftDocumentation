import Foundation

// Set, Array, Dictionary

var animalArray = [String]()
var colorSet = Set<String>()
var taskDict = [String: String]()

let arrayWithDefaultValue = Array(repeating: "Default", count: 5)

print("Array with default values: \(arrayWithDefaultValue)")

let animal = ["Lion", "Tiger"]
animalArray.append("Dog")
animalArray.append("Cat")
animalArray.append("Goat")

print("Animal array before insertion :\(animalArray)")

animalArray.insert("Elephant", at: 0)

print("Animal array after insertion :\(animalArray)")

animalArray.append(contentsOf: animal)

print("Animal array after appending elements :\(animalArray)")

colorSet.insert("Red")
colorSet.insert("Blue")

print("Color set : \(colorSet)")

colorSet.insert("Red")

print("Color set : \(colorSet)")

taskDict["Task1"] = "Complete Swift course"
taskDict["Task2"] = "Complete iOS course"
taskDict["Task3"] = "Complete macOS course"

print("Task dictionary : \(taskDict)")

taskDict["Task1"] = "Complete iOS course"

print("Task dictionary : \(taskDict)")

let oddDigits: Set = [1, 3, 5, 7, 9]
let evenDigits: Set = [0, 2, 4, 6, 8]
let singleDigitPrimeNumbers: Set = [2, 3, 5, 7]


print(oddDigits.union(evenDigits).sorted())
// [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
print(oddDigits.intersection(evenDigits).sorted())
// []
print(oddDigits.subtracting(singleDigitPrimeNumbers).sorted())
// [1, 9]
print(oddDigits.symmetricDifference(singleDigitPrimeNumbers).sorted())
// [1, 2, 9]

for (Task, TaskName) in taskDict {
    print("\(Task): \(TaskName)")
}

for taskKeys in taskDict.keys {
    print("\(taskKeys)")
}

for taskValues in taskDict.values {
    print("\(taskValues)")
}




