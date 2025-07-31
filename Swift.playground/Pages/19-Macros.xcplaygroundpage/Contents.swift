import Foundation

func logDebugInfo(message: String,
                  file: String = #file,
                  line: Int = #line,
                  function: String = #function,
                  column: Int = #column) {
    print("""
    🐞 Debug Log:
    Message: \(message)
    File: \(file)
    Line: \(line)
    Column: \(column)
    Function: \(function)
    """)
}

struct Person {
    let name: String
    let age: Int

    func greet() {
        logDebugInfo(message: "Greeting started")
        print("Hello, my name is \(name) and I am \(age) years old.")
        logDebugInfo(message: "Greeting finished")
    }
}

let person = Person(name: "Alice", age: 30)
person.greet()

