import Foundation

// Constant and Variable

let environment = "Development"
var maxLoginAttempts = 10


if environment == "Development" {
    maxLoginAttempts = 1
} else {
    maxLoginAttempts = 10
}

print("Max login attempts: \(maxLoginAttempts)")

typealias firstName = String
var age = 30
var adress = "Kitchener"
var crime = -1

// type annotation, type inference, type safety

var lastName: firstName

let isMarried: Bool

lastName = "Kaur"
isMarried = true


