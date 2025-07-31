import Foundation

func addSum() {
    let a = 10
    let b = 20
    a + b
}

//print(addSum())

func addSumWithParameters(a: Int, b: Int, c: Int) -> Int {
    return a+b+c
}

print(addSumWithParameters(a: 3, b: 4, c: 5))

func addSumWithInoutParameters(_ a: inout Int, _ b: inout Int) -> Int {
    a += 2
    b += 2
    return a+b
}

var num1 = 10
var num2 = 20

print(addSumWithInoutParameters(&num1, &num2))

// variadic parameters

func sumOfVariadicParameters(_ numbers: Int...) -> Int {
    return numbers.reduce(0, +)
}

print(sumOfVariadicParameters(1, 2, 3, 4, 5))
