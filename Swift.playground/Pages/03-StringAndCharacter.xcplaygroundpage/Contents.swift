import Foundation

let firstText = "Hello, World!"
let secondText = "Hello, Swift!"

var resultText = firstText + " " + secondText

let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.
"""

for value in quotation {
    print(value, separator: "#")
}

// String indicies

var firstIndex = quotation.startIndex

var endIndex = quotation.endIndex

var afterIndex = quotation.index(after: firstIndex)

var beforeIndex = quotation.index(before: endIndex)





