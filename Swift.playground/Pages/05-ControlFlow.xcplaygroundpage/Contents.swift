import Foundation

let names = ["Alice", "Bob", "Charlie"]
print("Iterating over an array:")
for name in names {
    print("  Hello, \(name)!")
}

let ages = ["Alice": 30, "Bob": 24, "Charlie": 35]
print("\nIterating over a dictionary:")
for (personName, personAge) in ages {
    print("  \(personName) is \(personAge) years old.")
}

print("\nIterating over a numeric range (closed range 1...5):")
for index in 1...5 {
    print("  \(index) times 2 is \(index * 2)")
}

print("\nIterating over a numeric range (half-open range 0..<3):")
for i in 0..<3 {
    print("  Loop iteration \(i)")
}

let base = 2
let exponent = 4
var result = 1
print("\nCalculating \(base) to the power of \(exponent):")
for _ in 1...exponent {
    result *= base
}
print("  Result: \(result)") // 16

print("\nStride: Counting by 2s (from 0 to 10, not including 10):")
for num in stride(from: 0, to: 10, by: 2) {
    print("  \(num)") // 0, 2, 4, 6, 8
}

print("\nStride: Counting by 3s (from 1 to 10, including 10 if divisible):")
for num in stride(from: 1, through: 10, by: 3) {
    print("  \(num)") // 1, 4, 7, 10
}

print("\n--- While Loops ---")
var countdown = 5
print("Countdown using while loop:")
while countdown > 0 {
    print("  \(countdown)...")
    countdown -= 1
}
print("  Lift off!")

var batteryLevel = 5
print("\nCharging until full (repeat-while):")
repeat {
    print("  Battery at \(batteryLevel)%")
    batteryLevel += 10
} while batteryLevel <= 100 // Loop runs once even if batteryLevel was already 100
print("  Battery fully charged!")

let currentTemperature = 25 // Celsius
print("Temperature advice (if-else if-else):")
if currentTemperature <= 0 {
    print("  It's freezing! Bundle up.")
} else if currentTemperature > 30 {
    print("  It's scorching hot! Stay hydrated.")
} else {
    print("  The temperature is mild. Enjoy!")
}

// ### `if` as an expression (assigning a value based on conditions)
let advice = if currentTemperature <= 0 {
    "It's freezing! Bundle up."
} else if currentTemperature > 30 {
    "It's scorching hot! Stay hydrated."
} else {
    "The temperature is mild. Enjoy!"
}
print("Advice from if expression: \(advice)")

print("\n--- Switch Statement ---")

let dayOfWeek = "Wednesday"

print("What day is it? (Basic switch):")
switch dayOfWeek {
case "Monday":
    print("  It's the start of the week.")
case "Friday":
    print("  Yay, it's almost the weekend!")
case "Saturday", "Sunday": // Compound case
    print("  It's the weekend!")
default: // The default case makes the switch exhaustive
    print("  It's a regular weekday.")
}

// ### Interval Matching
let score = 85

print("\nStudent grade (Interval Matching):")
switch score {
case 0..<50:
    print("  Failing grade.")
case 50..<70:
    print("  Passing, but needs improvement.")
case 70..<90:
    print("  Good job!")
case 90...100:
    print("  Excellent work!")
default:
    print("  Invalid score.")
}

// ### Tuples in `switch`
let coordinates = (3, 0)

print("\nPoint classification (Tuples in switch):")
switch coordinates {
case (0, 0):
    print("  At the origin.")
case (_, 0): // Wildcard pattern for x, fixed y
    print("  On the X-axis.")
case (0, _): // Fixed x, wildcard for y
    print("  On the Y-axis.")
case (-10...10, -10...10): // Interval matching in tuple
    print("  Inside the 10x10 box.")
default:
    print("  Outside the box.")
}

let student = ("John Doe", 15, "Mathematics")

print("\nStudent info (Value Bindings):")
switch student {
case (let name, 15, _): // Binds name, matches age 15, any subject
    print("  Found a 15-year-old student named \(name).")
case (_, let age, "Science"): // Binds age, matches Science, any name
    print("  Found a student \(age) years old studying Science.")
case let (name, age, subject): // Catches all remaining, binds all values
    print("  Student: \(name), Age: \(age), Subject: \(subject).")
}

let point = (2, 2)

print("\nPoint on a line (where clause):")
switch point {
case let (x, y) where x == y:
    print("  (\(x), \(y)) is on the line x = y.")
case let (x, y) where x == -y:
    print("  (\(x), \(y)) is on the line x = -y.")
default:
    print("  (\(point.0), \(point.1)) is just an arbitrary point.")
}

print("\n--- Patterns in If Statements (`if case`) ---")

let optionalNumber: Int? = 10
if case .some(let value) = optionalNumber { // Matches if optionalNumber has a value, binds it to 'value'
    print("  The optional number is \(value).")
}

let statusCode = 404
if case 400..<500 = statusCode { // Matches if statusCode is in the 4xx range
    print("  Client error code: \(statusCode)")
}

print("1. continue:")

let puzzleInput = "great minds think alike"
var puzzleOutput = ""
let charactersToRemove: [Character] = ["a", "e", "i", "o", "u", " "]

for character in puzzleInput {
    if charactersToRemove.contains(character) {
        continue
    }
    puzzleOutput.append(character)
}
print("Output without vowels/spaces:", puzzleOutput)

print("\n2. break (loop):")

for number in 1...5 {
    if number == 3 {
        break
    }
    print("Number:", number)
}
// Prints 1, 2

print("\n2. break (switch):")

let symbol: Character = "三"
var value: Int?

switch symbol {
case "1", "١", "一", "๑":
    value = 1
case "2", "٢", "二", "๒":
    value = 2
case "3", "٣", "三", "๓":
    value = 3
case "4", "٤", "四", "๔":
    value = 4
default:
    break
}

if let intValue = value {
    print("Matched value is:", intValue)
} else {
    print("No match.")
}

// MARK: - Fallthrough Statement Example

print("\n3. fallthrough:")

let number = 5
var description = "The number \(number) is"

switch number {
case 2, 3, 5, 7:
    description += " a prime number, and also"
    fallthrough
default:
    description += " an integer."
}

print(description)
// Prints "The number 5 is a prime number, and also an integer."

// MARK: - Labeled Statements Example

print("\n4. labeled break/continue:")

let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1)
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
var square = 0
var diceRoll = 0

gameLoop: while square != finalSquare {
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }

    switch square + diceRoll {
    case finalSquare:
        break gameLoop
    case let newSquare where newSquare > finalSquare:
        continue gameLoop
    default:
        square += diceRoll
        square += board[square]
    }
}
print("Game over at square \(square)")

// MARK: - Early Exit with guard

print("\n5. early exit with guard:")

func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
    }
    print("Hello \(name)!")

    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    print("I hope the weather is nice in \(location).")
}

greet(person: ["name": "John"])
greet(person: ["name": "Jane", "location": "Cupertino"])

// MARK: - defer Statement Example

print("\n6. defer:")

var scores = 3
if scores < 100 {
    scores += 100
    defer {
        scores -= 100
    }
    print("Score with bonus:", scores)
}
// After defer, score is restored

print("Score after defer:", score)

if scores < 10 {
    defer {
        print(scores)
    }
    defer {
        print("The score is:")
    }
    scores += 5
}

// MARK: - Availability Check

print("\n7. API availability check:")

if #available(iOS 10, macOS 10.12, *) {
    print("Running on modern OS version")
} else {
    print("Fallback for older OS")
}

@available(macOS 10.12, *)
struct ColorPreference {
    var bestColor = "blue"
}

func chooseBestColor() -> String {
    guard #available(macOS 10.12, *) else {
        return "gray"
    }
    let colors = ColorPreference()
    return colors.bestColor
}

print("Best color:", chooseBestColor())


