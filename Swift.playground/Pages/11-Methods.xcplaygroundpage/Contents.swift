import Foundation

// Methods are functions that are associated with a particular type. Classes, structures, and enumerations

class Counter {
    var count = 0

    func increment() {
        count += 1
    }

    func increment(by amount: Int) {
        count += amount
    }

    func reset() {
        count = 0
    }
}

let counter = Counter()
counter.increment()
counter.increment(by: 10)
counter.reset()

func dummy() {
    print("dummy function called")
}
