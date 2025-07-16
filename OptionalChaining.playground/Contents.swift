import Foundation

// MARK: - ✅ Definition
/*
 Optional Chaining is a process for querying and calling properties, methods,
 and subscripts on an optional that might currently be nil.

 If the optional contains a value, the property, method, or subscript call succeeds;
 if the optional is nil, the call returns nil — not a runtime error.
*/

// MARK: - ✅ Syntax Comparison
/*
 Forced Unwrapping: optional!
 Optional Chaining: optional?

 The difference:
 - Forced unwrapping crashes if the optional is nil.
 - Optional chaining fails gracefully and returns nil.
*/

// MARK: - ✅ Room Class
class Room {
    let name: String
    init(name: String) { self.name = name }
}

// MARK: - ✅ Residence Base Class
class Residence {
    // 🛠️ Added missing 'rooms' property
    var rooms: [Room] = []

    var numberOfRooms: Int {
        return rooms.count
    }

    // ✅ Subscript to safely access rooms (optional return)
    subscript(index: Int) -> Room? {
        if index >= 0 && index < rooms.count {
            return rooms[index]
        } else {
            return nil
        }
    }
}

// MARK: - ✅ Person Class
class Person {
    var residence: Residence?
}

// MARK: - ✅ Simple Example
let john = Person()

// Optional chaining (✅ Safe)
if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
} else {
    print("Unable to retrieve the number of rooms.")
}

// Assign a Residence
john.residence = Residence()
john.residence?.rooms.append(Room(name: "Bedroom"))

if let roomCount = john.residence?.numberOfRooms {
    print("John's residence has \(roomCount) room(s).")
}

// MARK: - ✅ Address Class
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

// MARK: - ✅ ComplexResidence Subclass
class ComplexResidence: Residence {
    override var numberOfRooms: Int {
        get { return rooms.count }
        set {
            guard !rooms.isEmpty else { return }
            rooms = Array(repeating: Room(name: rooms[0].name), count: newValue)
        }
    }

    // Non-optional subscript (safe when used correctly)
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

// MARK: - ✅ Using ComplexResidence
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

// MARK: - ✅ Method with Optional Return
if let complexResidence = person.residence as? ComplexResidence,
   let buildingID = complexResidence.address?.buildingIdentifier() {
    print("Building ID: \(buildingID)")
}

if let complexResidence = person.residence as? ComplexResidence,
   let beginsWithThe = complexResidence.address?.buildingIdentifier()?.hasPrefix("The") {
    print("Begins with 'The': \(beginsWithThe)")
}

// MARK: - ✅ Subscripts of Optional Type (Dictionary)
var testScores = [
    "Dave": [86, 82, 84],
    "Bev": [79, 94, 81]
]

testScores["Dave"]?[0] = 91       // ✅ OK
testScores["Bev"]?[0] += 1        // ✅ OK
testScores["Brian"]?[0] = 72      // ✅ No crash – ignored safely

print("Test Scores:", testScores)

// MARK: - ✅ Summary Notes
/*
 - Optional chaining lets you access properties, methods, and subscripts on optionals safely.
 - Returns nil if any link in the chain is nil.
 - Commonly used with:
     • Properties: person.residence?.address
     • Methods: person.residence?.printNumberOfRooms()
     • Subscripts: person.residence?[0]
     • Assignments: person.residence?.address = address
 - Prevents runtime crashes due to forced unwrapping (!).
*/
