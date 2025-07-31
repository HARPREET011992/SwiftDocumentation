import Foundation

//Initialization is the process of preparing an instance of a class, structure, or enumeration for use.

class User {
    var name: String
    var last: String

    // Designated initializers are the primary initializers for a class
    init(name: String, last: String) {
        self.name = name
        self.last = last
    }

//    convenience initializers must call another initializer in the same class using self.init(...).
    convenience init(name: String) {
        self.init(name: name, last: "")
    }
}
let user1 = User(name: "John", last: "Doe")

let user2 = User(name: "Jane")
print(user1.name)
print(user2.name) 
print(user2.last) 

struct UserStructure {
    var last: String
    var name: String

    init(name: String, last: String) {
        self.name = name
        self.last = last
    }

    init(name: String) {
           self.init(name: name, last: "")
       }

}

let structUser = UserStructure(name: "Ali")
print(structUser.name)
print(structUser.last)

enum UserEnum {
    case hot
    case cold

    init(temprature: Int) {
        if temprature > 30 {
           self = .hot
        } else {
            self = .cold
        }
    }
}

let user12 = UserEnum(temprature: 45)
print(user12)

// Failable initializer This means the initializer might fail to create an instance and return nil.

struct UserStruct {
    var name: String

    init?(name: String?) {
        guard let name = name, !name.isEmpty else {
                    return nil
                }
        self.name = name
    }
}

let userStruct = UserStruct(name: "") 
print(userStruct!)


//Required initializer is used to mandate every subclass to use this initializer

class Person {
    var name: String

    // Required initializer
    required init(name: String) {
        self.name = name
    }
}

class Girl: Person {
    required init(name: String) {
        super.init(name: name)
    }
}
