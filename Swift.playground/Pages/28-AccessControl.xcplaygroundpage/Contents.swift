import Foundation

// Access Control is of 5 types Open, public, internal, file private, private
// open is you can access outside module , is ok for subclass and override where as publc can't be override
//private and file private also can't be accessed in extension too

// open
open class Person {
    var name: String
    public init(name: String) {
        self.name = name
    }
    
}

class Employee: Person {
    override init(name: String = "Employee") {
        super.init(name: name)
    }
}

// Public

public class Car {
   fileprivate  var make: String
    public init(make: String) {
        self.make = make
    }
}

extension Car {
    func printMake() {

    }
}

class ElectricCar: Car {
    override init(make: String = "Tesla") {
        super.init(make: make)
    }
}

struct Address {
    var street: String?
}
