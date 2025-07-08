import UIKit

//Data type in swift

var count: Int // Interger Value can be signed or unsigned but whole number
var speed: Double // For Decimal value but 64 bit
var work: Float // For Decimal Value but 32 bit
var isWorking: Bool // Boolean value just true or false
var name: String // used to store sequence of character

// declaration type

let myName: String = "Harpreet Kaur" // declare value with let which is not going to be change (immutable)
var age: Int = 20 //declare value which can be changed (mutable)

var currentYear = 2021

if currentYear == 2020 {
    age = 20
} else if currentYear == 2021 {
    age += 1
} else {
    age = 22
}

let π = 3.14159
let 你好 = "你好世界"
let 🐶🐮 = "dogcow"

print(🐶🐮, 你好, π, separator: " | ", terminator: ".\n") // print statement for debugging


// typealias

typealias ages = Int

var myAge: ages = 20

print(myAge)

// Tuple Declaration

var httpError: (Int, String)
httpError = (404, "Not Found")
print(httpError)
