import Foundation

class Room {
    let name: String
    init(name: String) { self.name = name }
}

class Residence {
    var rooms: [Room] = []

    var numberOfRooms: Int {
        return rooms.count
    }

    subscript(index: Int) -> Room? {
        if index >= 0 && index < rooms.count {
            return rooms[index]
        } else {
            return nil
        }
    }
}

class Person {
    var residence: Residence?
}

let john = Person()

if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

john.residence = Residence()
john.residence?.rooms.append(Room(name: "Bedroom"))

if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?

    func buildingIdentifier() -> String? {
        if let number = buildingNumber, let street = street {
            return "\(number) \(street)"
        } else if let name = buildingName {
            return name
        } else {
            return nil
        }
    }
}

class ComplexResidence: Residence {
    override var numberOfRooms: Int {
        get { return rooms.count }
        set {
            guard !rooms.isEmpty else { return }
            rooms = Array(repeating: Room(name: rooms[0].name), count: newValue)
        }
    }
    override subscript(i: Int) -> Room? {
        get {
            if i >= 0 && i < rooms.count {
                return rooms[i]
            } else {
                return nil
            }
        }
        set {
            if let newValue = newValue, i >= 0 && i < rooms.count {
                rooms[i] = newValue
            }
        }
    }

    var address: Address?

    func printNumberOfRooms() {
        print("The number of rooms is \(numberOfRooms)")
    }
}

let person = Person()
person.residence = ComplexResidence()

// Safely cast and add rooms
if let complex = person.residence as? ComplexResidence {
    complex.rooms.append(Room(name: "Living Room"))
    complex.rooms.append(Room(name: "Kitchen"))

    // Optional chaining to access subscript
    if let firstRoomName = person.residence?[0]?.name {
        print("First room: \(firstRoomName)")
    }
}

// MARK: - ✅ Optional Chaining with Method
if let complex = person.residence as? ComplexResidence {
    complex.printNumberOfRooms()
    print("Method call succeeded.")
} else {
    print("Method call failed.")
}

// MARK: - ✅ Optional Chaining with Assignment
let address = Address()
address.buildingName = "The Larches"
address.street = "Laurel Street"
if let complexResidence = person.residence as? ComplexResidence {
    complexResidence.address = address

    if let street = complexResidence.address?.street {
        print("Street: \(street)")
    }
}

if let complexResidence = person.residence as? ComplexResidence,
   let buildingID = complexResidence.address?.buildingIdentifier() {
    print("Building ID: \(buildingID)")
}

if let complexResidence = person.residence as? ComplexResidence,
   let beginsWithThe = complexResidence.address?.buildingIdentifier()?.hasPrefix("The") {
    print("Begins with 'The': \(beginsWithThe)")
}

var testScores = [
    "Dave": [86, 82, 84],
    "Bev": [79, 94, 81]
]

testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72    

print("Test Scores:", testScores)
