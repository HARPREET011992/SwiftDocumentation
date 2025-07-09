import UIKit

// MARK: - String Literals
// A string literal is a sequence of characters enclosed in double quotes (" ")

let greeting = "Hello, Playground"
print(greeting)


// MARK: - Multiline String Literals
// Use triple double quotes (""") to define strings that span multiple lines

let introduction = """
Hi, my name is Harpreet.
I live in Canada.
I am a software engineer.
"""
print(introduction)


// MARK: - Line Breaks
// Insert a line break using the newline escape sequence: \n

let message = "Hello, my name is Harpreet.\nI live in Canada.\nI am a software engineer."
print(message)


// MARK: - String Mutability
// Use `var` instead of `let` to make a string mutable (modifiable)

var name: String = "Harpreet"
name += " Kaur"
print(name)


// MARK: - String Value Types
// Strings are value types. Modifying a copy does not affect the original.

var firstName: String = "Harpreet"
var lastName: String = firstName
lastName += " Kaur"
print("Original: \(firstName)")
print("Modified Copy: \(lastName)")


// MARK: - Working with Characters
// You can loop through a string character-by-character

let phrase = "Hello World"
for character in phrase {
    print(character)
}


// MARK: - Characters to String
// Convert an array of characters into a string

let characters: [Character] = ["H", "e", "l", "l", "o"]
let stringFromCharacters = String(characters)
print(stringFromCharacters)


// MARK: - String Concatenation
// Combine strings using the + operator or append method

let string1 = "hello"
let string2 = " there"
var welcome = string1 + string2
print(welcome)

let additionalInfo: String = "Myself Harpreet"
welcome += " \(additionalInfo)"
print(welcome)

let punctuation = "."
welcome.append(contentsOf: punctuation)
print(welcome)


// MARK: - String Interpolation
// Embed values directly into a string using \()

let number = 5
print("Double of \(number) is \(number * 2)")


// MARK: - String Indices
// Strings have custom index types for accessing characters

let greetings: String = "Hello, world!"
print("Character count: \(greetings.count)")
print("First character after start index: \(greetings[greetings.index(after: greetings.startIndex)])")
print("Character before end index: \(greetings[greetings.index(before: greetings.endIndex)])")
print("Character at offset 2: \(greetings[greetings.index(greetings.startIndex, offsetBy: 2)])")


// MARK: - Inserting and Removing Characters
// Use insert() and remove() to modify characters in a string

var mutableGreeting = greetings
mutableGreeting.insert("!", at: mutableGreeting.endIndex)
print(mutableGreeting)

mutableGreeting.remove(at: mutableGreeting.index(before: mutableGreeting.endIndex))
print(mutableGreeting)


// MARK: - Substrings
// You can create substrings using range slicing

if let index = greetings.firstIndex(of: "o") {
    let substring = greetings[..<index]
    print("Substring before 'o': \(substring)")
}


// MARK: - String Equality
// Compare strings and characters using == and !=

let str1 = "Swift"
let str2 = "Swift"
print("Are strings equal? \(str1 == str2)")
print("Are strings not equal? \(str1 != str2)")


// MARK: - Prefix and Suffix Equality
// Check whether a string starts with or ends with a specific substring

let text = "Welcome to Swift programming"

if text.hasPrefix("Welcome") {
    print("The text starts with 'Welcome'")
}

if text.hasSuffix("programming") {
    print("The text ends with 'programming'")
}

