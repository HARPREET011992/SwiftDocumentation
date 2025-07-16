import Foundation
/*:
 # Swift Extensions: Adding Functionality to Existing Types

 ## Definition
 **Extensions** in Swift allow you to add new functionality to an **existing class, structure, enumeration, or protocol type** without modifying its original source code. This powerful feature enables "retroactive modeling," meaning you can extend types for which you don't have access to the original source code (like Swift's built-in types). Extensions are similar to categories in Objective-C, but without names.

 **Key Capabilities of Extensions:**
 - Add **computed instance properties** and **computed type properties**.
 - Define **instance methods** and **type methods**.
 - Provide **new initializers** (convenience initializers for classes, or new initializers for value types).
 - Define **subscripts**.
 - Define and use **new nested types**.
 - Make an existing type **conform to a protocol**.

 **Important Considerations:**
 - Extensions can add *new* functionality, but they **cannot override existing functionality**.
 - Extensions **cannot add stored properties** to a class, structure, or enumeration.
 - Extensions **cannot add property observers** to existing properties.
 - New functionality added via an extension is available on all existing instances of that type, regardless of when they were created.

 ---

 ## Extension Syntax

 Extensions are declared using the `extension` keyword:

 ```swift
 extension SomeType {
     // new functionality to add to SomeType goes here
 }
To extend a type to adopt one or more protocols:

Swift
extension SomeType: SomeProtocol, AnotherProtocol {
    // implementation of protocol requirements goes here
}
*/

// MARK: - Examples of Extensions

/*:

1. Computed Properties

Extensions can add computed instance properties and computed type properties to existing types.
Let's add some unit conversion properties to Swift's built-in Double type.
*/

extension Double {
// Definition: Add computed instance properties and computed type properties
/// Converts meters to kilometers.
var km: Double { return self / 1_000.0 }
/// Represents a value in meters.
var m: Double { return self }
/// Converts meters to centimeters.
var cm: Double { return self * 100.0 }
/// Converts meters to millimeters.
var mm: Double { return self * 1_000.0 }
/// Converts meters to feet.
var ft: Double { return self / 0.3048 } // 1 meter = 3.28084 feet, so 1 foot = 0.3048 meters
/// Converts meters to inches.
var inch: Double { return self / 0.0254 } // 1 inch = 0.0254 meters
}

print("--- Computed Properties ---")
let distanceInMeters = 50.0 // Starting with a value in meters
print("50 meters is (distanceInMeters.km) km")
print("50 meters is (distanceInMeters.cm) cm")
print("50 meters is (distanceInMeters.ft) feet")
print("10 feet is (10.0.ft) meters")

let totalDistance = 5.km + 200.m + 30.ft // Combining different units
print("Total distance: (totalDistance) meters")

/*:

2. Initializers

Extensions can add new initializers to existing types. This is useful for providing convenience initializers or allowing existing types to be initialized with custom data.
Let's add an initializer to String to create a string by repeating a character.
*/

extension String {
// Definition: Provide new initializers
/// Initializes a new string by repeating a given character a specified number of times.
init(repeating character: Character, count: Int) {
self = String(repeating: character, count: count)
}

/// Initializes a new string by repeating another string a specified number of times.
init(repeating str: String, count: Int) {
    var result = ""
    for _ in 0..<count {
        result += str
    }
    self = result
}
}

print("\n--- Initializers ---")
let dottedLine = String(repeating: ".", count: 30)
print(dottedLine)

let pattern = String(repeating: "-=-", count: 5)
print(pattern)

/*:

3. Methods (Instance and Type Methods)

Extensions can add new instance methods and type methods to existing types.
Let's add a trim() method to String and isEven property to Int.
*/

extension String {
// Definition: Define instance methods and type methods
/// Returns a new string with leading and trailing whitespace and newlines removed.
func trim() -> String {
return self.trimmingCharacters(in: .whitespacesAndNewlines)
}

/// Returns a reversed version of the string.
func reversedString() -> String {
    return String(self.reversed())
}
}

extension Int {
// Definition: Define instance methods and type methods (continued)
/// Returns true if the integer is an even number.
var isEven: Bool {
return self % 2 == 0
}

/// Returns true if the integer is an odd number.
var isOdd: Bool {
    return !self.isEven
}

/// A mutating instance method to square the integer's value.
mutating func square() {
    self = self * self
}

/// A type method to get a random integer within a range.
static func random(in range: ClosedRange<Int>) -> Int {
    return Int.random(in: range)
}
}

print("\n--- Methods ---")
let quote = "   Knowledge is power.   \n"
print("Original: '(quote)'")
print("Trimmed:  '(quote.trim())'")
print("Reversed: '(quote.reversedString())'")

print("5 is even: (5.isEven)")
print("4 is odd: (4.isOdd)")

var numberToSquare = 7
numberToSquare.square()
print("7 squared is: (numberToSquare)")

let randomNumber = Int.random(in: 1...100)
print("A random number between 1 and 100: (randomNumber)")

/*:

4. Subscripts

Extensions can add new subscripts to an existing type.
Let's add a subscript to String to easily access characters at a specific index.
*/

extension String {
// Definition: Define subscripts
/// Allows subscript access to individual characters in the string, returning an optional Character.
subscript(index: Int) -> Character? {
guard index >= 0 && index < self.count else { return nil }
let charIndex = self.index(self.startIndex, offsetBy: index)
return self[charIndex]
}

/// Allows subscript access to a range of the string, returning an optional String.
subscript(range: Range<Int>) -> String? {
    guard range.lowerBound >= 0 && range.upperBound <= self.count && range.lowerBound <= range.upperBound else { return nil }
    let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
    let endIndex = self.index(self.startIndex, offsetBy: range.upperBound)
    return String(self[startIndex..<endIndex])
}
}

print("\n--- Subscripts ---")
let programmingLanguage = "Swift Language"
print("Character at index 0: \(programmingLanguage[0] ?? "?")")
print("Character at index 6: \(programmingLanguage[6] ?? ")")")
print("Substring (0..<5): \(programmingLanguage[0..<5] ?? "N/A")")
print("Substring (7..<15): \(programmingLanguage[7..<15] ?? "N/A")")
print("Substring (invalid range): \(programmingLanguage[100..<105] ?? "Out of bounds")")

/*:

5. Nested Types

Extensions can add new nested types to existing classes, structures, and enumerations.
Let's add a ValidationResult enum to String to categorize its validity based on certain rules.
*/

extension String {
// Definition: Define and use new nested types
/// A nested enumeration to describe the result of a validation check for a string.
enum ValidationResult {
case valid
case empty
case tooShort(minimum: Int)
case tooLong(maximum: Int)
case containsInvalidCharacters(characters: String)
}

/// Performs a simple validation check on the string based on length and allowed characters.
func validate(minLength: Int, maxLength: Int, allowedCharacters: CharacterSet) -> ValidationResult {
    if self.isEmpty {
        return .empty
    }
    if self.count < minLength {
        return .tooShort(minimum: minLength)
    }
    if self.count > maxLength {
        return .tooLong(maximum: maxLength)
    }

    let invertedSet = allowedCharacters.inverted
    if let range = self.rangeOfCharacter(from: invertedSet) {
        let invalidChars = String(self[range])
        return .containsInvalidCharacters(characters: invalidChars)
    }

    return .valid
}
}

print("\n--- Nested Types ---")
let alphaNumeric = CharacterSet.alphanumerics
let username = "john_doe123"
let shortUsername = "jd"
let longUsername = "thisisareallylongusername"
let badUsername = "user!@#"

print("Username validation for '(username)':")
switch username.validate(minLength: 5, maxLength: 15, allowedCharacters: alphaNumeric.union(CharacterSet(charactersIn: "_"))) {
case .valid: print("  Valid!")
case .empty: print("  Empty.")
case .tooShort(let min): print("  Too short, needs at least (min).")
case .tooLong(let max): print("  Too long, max (max).")
case .containsInvalidCharacters(let chars): print("  Contains invalid characters: (chars).")
}

print("Username validation for '(shortUsername)':")
switch shortUsername.validate(minLength: 5, maxLength: 15, allowedCharacters: alphaNumeric.union(CharacterSet(charactersIn: "_"))) {
case .valid: print("  Valid!")
case .empty: print("  Empty.")
case .tooShort(let min): print("  Too short, needs at least (min).")
case .tooLong(let max): print("  Too long, max (max).")
case .containsInvalidCharacters(let chars): print("  Contains invalid characters: (chars).")
}

print("Username validation for '(badUsername)':")
switch badUsername.validate(minLength: 5, maxLength: 15, allowedCharacters: alphaNumeric.union(CharacterSet(charactersIn: "_"))) {
case .valid: print("  Valid!")
case .empty: print("  Empty.")
case .tooShort(let min): print("  Too short, needs at least (min).")
case .tooLong(let max): print("  Too long, max (max).")
case .containsInvalidCharacters(let chars): print("  Contains invalid characters: (chars).")
}

/*:

6. Protocol Conformance

Extensions can make an existing type conform to one or more protocols.
Let's make Int conform to a custom Describable protocol.
*/

protocol Describable {
var fullDescription: String { get }
func describe()
}

extension Int: Describable {
// Definition: Make an existing type conform to a protocol
// We can provide an implementation for the protocol requirement here.
var fullDescription: String {
return "The integer value is (self)."
}

func describe() {
    print("This number is \(self).")
}
}

extension String: Describable {
// Definition: Make an existing type conform to a protocol (continued)
var fullDescription: String {
return "The string value is \(self)."
}

func describe() {
    print("This string is \"\(self)\".")
}
}

print("\n--- Protocol Conformance ---")
let myAge = 30
print(myAge.fullDescription)
myAge.describe()

let greeting = "Hello Swift"
print(greeting.fullDescription)
greeting.describe()

/*:
 Extensions are a fundamental part of writing clean, modular, and reusable Swift code. They allow you to enhance existing types without subclassing or modifying their original definitions, making your codebase more flexible and easier to maintain.*/
