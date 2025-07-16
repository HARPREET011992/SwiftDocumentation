import UIKit

/*:
 # Protocols in Swift

 ## Definition
 A **protocol** defines a blueprint of methods, properties, and other requirements that suit a particular task or piece of functionality. Think of it as a contract: any class, structure, or enumeration that wants to fulfill this contract must provide an actual implementation of those requirements. Any type that satisfies these requirements is said to **conform** to that protocol.

 Protocols aren't just for specifying what needs to be implemented; you can also **extend** them to provide default implementations for some requirements or to add extra functionality that conforming types can use.

 ---

 ## Protocol Syntax

 You define protocols much like you define classes, structures, and enumerations, using the `protocol` keyword.

 */
// Example: Basic Protocol Definition
protocol SomeProtocol {
    // Protocol requirements go here
}

/*:
 Custom types adopt a protocol by placing its name after the type's name, separated by a colon. If a type has a superclass, the superclass name comes first, followed by any adopted protocols, all separated by commas.

 */
// Example: Adopting Protocols
struct SomeStructure: SomeProtocol {
    // Structure definition goes here
}

class SomeClass: NSObject, SomeProtocol { // NSObject is a common superclass for UIKit classes
    // Class definition goes here
}

print("--- Protocol Syntax ---")
print("Protocols define requirements that types must implement.")
print("Types adopt protocols using a colon after their name.\n")

/*:
 **Naming Convention:** Protocol names, like other types in Swift, begin with a capital letter (e.g., `FullyNamed`, `RandomNumberGenerator`).

 ---

 ## Property Requirements

 A protocol can require any conforming type to provide instance or type properties with specific names and types. The protocol doesn't care if the property is stored or computed, only that it exists and meets the get/set requirements.

 -   **Gettable and Settable:** Indicated by `{ get set }`. Cannot be fulfilled by a `let` constant or a read-only computed property.
 -   **Gettable only:** Indicated by `{ get }`. Can be satisfied by any property.
 -   **Type Properties:** Always prefixed with `static` in the protocol definition.

 */
protocol SomePropertyProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
    static var someTypeProperty: Int { get set }
}

// Example: FullyNamed Protocol
protocol FullyNamed {
    var fullName: String { get } // Requires a gettable String property
}

// Conforming Structure
struct Person: FullyNamed {
    var fullName: String // Stored property satisfies the requirement
}

print("--- Property Requirements ---")
let john = Person(fullName: "John Appleseed")
print("Person's full name: \(john.fullName)") // Expected: "Person's full name: John Appleseed"

// Conforming Class with Computed Property
class Starship: FullyNamed {
    var prefix: String?
    var name: String

    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }

    var fullName: String { // Computed property satisfies the requirement
        return (prefix != nil ? prefix! + " " : "") + name
    }
}

let ncc1701 = Starship(name: "Enterprise", prefix: "USS")
print("Starship full name: \(ncc1701.fullName)\n") // Expected: "Starship full name: USS Enterprise"

/*:
 ---

 ## Method Requirements

 Protocols can require specific instance and type methods. These are declared without curly braces or method bodies. Default values for parameters are **not** allowed in protocol method definitions.

 -   **Type Methods:** Always prefixed with `static` in the protocol definition.

 */
protocol RandomNumberGenerator {
    func random() -> Double // Requires an instance method returning a Double
    static func someTypeMethod() // Requires a static type method
}

// Example: Linear Congruential Generator conforming to RandomNumberGenerator
class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0

    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy: m))
        return lastRandom / m
    }

    static func someTypeMethod() {
        print("This is a type method implementation for RandomNumberGenerator.")
    }
}

print("--- Method Requirements ---")
let generator = LinearCongruentialGenerator()
print("Random number: \(generator.random())")
print("Another random number: \(generator.random())")
LinearCongruentialGenerator.someTypeMethod()
print("")

/*:
 ### Mutating Method Requirements

 For instance methods on **value types** (structs and enums), if a method needs to modify the instance it belongs to, it must be marked with the `mutating` keyword in the protocol definition. Classes don't need the `mutating` keyword for their implementations.

 */
protocol Togglable {
    mutating func toggle() // Mutating method requirement
}

// Example: OnOffSwitch enumeration conforming to Togglable
enum OnOffSwitch: Togglable {
    case off, on

    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}

print("--- Mutating Method Requirements ---")
var lightSwitch = OnOffSwitch.off
print("Light switch initial state: \(lightSwitch)")
lightSwitch.toggle()
print("Light switch after toggle: \(lightSwitch)\n") // Expected: "Light switch after toggle: on"

/*:
 ---

 ## Initializer Requirements

 Protocols can require specific initializers. These are declared without curly braces or bodies.

 ### Class Implementations of Protocol Initializer Requirements

 When a class implements a protocol's initializer requirement, that initializer **must** be marked with the `required` modifier. This ensures that all subclasses also provide an implementation (explicitly or inherited). If a subclass overrides a superclass designated initializer *and* implements a matching protocol requirement, use both `required` and `override`.

 */
protocol SomeInitProtocol {
    init(someParameter: Int)
}

class SomeBaseClass {
    init() { /* ... */ }
}

class SomeConformingClass: SomeBaseClass, SomeInitProtocol {
    var value: Int

    // Required initializer due to SomeInitProtocol conformance
    required init(someParameter: Int) {
        self.value = someParameter
        super.init()
    }
}

class AnotherConformingClass: SomeBaseClass, SomeInitProtocol {
    var anotherValue: Int

    // Overriding a superclass designated init AND satisfying a protocol requirement
    required override init() {
        self.anotherValue = 0
        super.init()
    }

    required init(someParameter: Int) { // Must still provide the required init
        self.anotherValue = someParameter
        super.init()
    }
}

print("--- Initializer Requirements ---")
let instance1 = SomeConformingClass(someParameter: 100)
print("SomeConformingClass value: \(instance1.value)")
let instance2 = AnotherConformingClass(someParameter: 200)
print("AnotherConformingClass anotherValue: \(instance2.anotherValue)")
let instance3 = AnotherConformingClass()
print("AnotherConformingClass default anotherValue: \(instance3.anotherValue)\n")


/*:
 ### Failable Initializer Requirements

 Protocols can define failable initializer requirements (`init?`). A failable initializer requirement can be satisfied by either a failable or a non-failable initializer on the conforming type.

 */
protocol NameCheckable {
    init?(name: String)
}

struct PersonWithFailableInit: NameCheckable {
    let name: String

    init?(name: String) {
        guard !name.isEmpty else { return nil }
        self.name = name
    }
}

print("--- Failable Initializer Requirements ---")
if let person = PersonWithFailableInit(name: "Alice") {
    print("Created person: \(person.name)")
}

if let _ = PersonWithFailableInit(name: "") {
    print("This should not be printed.")
} else {
    print("Failed to create person with empty name (as expected).\n")
}

/*:
 ---

 ## Protocols as Types

 Protocols themselves don't implement functionality, but you can use them as types in your code. This is common for:

 -   **Generic Constraints:** Allowing functions to work with any type conforming to a protocol.
 -   **Opaque Types:** Hiding the specific underlying type while guaranteeing protocol conformance (e.g., `some SomeProtocol`).
 -   **Boxed Protocol Types:** Allowing runtime flexibility to work with any type that conforms to the protocol, at a potential performance cost.

 */
protocol TextRepresentable {
    var textualDescription: String { get }
}

// Extending an existing type to conform to TextRepresentable
extension Int: TextRepresentable {
    public var textualDescription: String {
        return "The number \(self)"
    }
}

// An example class (reusing from previous section for context)
class Dice {
    let sides: Int
    init(sides: Int) {
        self.sides = sides
    }
}

extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}

struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
// Declare conformance with an empty extension if all requirements are met
extension Hamster: TextRepresentable {}


print("--- Protocols as Types ---")
let favoriteNumber: TextRepresentable = 7
print(favoriteNumber.textualDescription) // Expected: "The number 7"

let myDice = Dice(sides: 6)
let textRepresentableDice: TextRepresentable = myDice
print(textRepresentableDice.textualDescription) // Expected: "A 6-sided dice"

let simonTheHamster = Hamster(name: "Simon")
let somethingTextRepresentable: TextRepresentable = simonTheHamster
print(somethingTextRepresentable.textualDescription) // Expected: "A hamster named Simon"

// Collections of Protocol Types
let things: [TextRepresentable] = [7, myDice, simonTheHamster]
print("\nItems in a collection of protocol types:")
for thing in things {
    print(thing.textualDescription)
}
/* Expected:
 The number 7
 A 6-sided dice
 A hamster named Simon
*/
print("")

/*:
 ---

 ## Protocol Inheritance

 A protocol can inherit from one or more other protocols, adding its own requirements on top of those it inherits.

 */
protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}

// Example class that conforms to PrettyTextRepresentable
class Spaceship: PrettyTextRepresentable {
    let model: String
    let serialNumber: String

    init(model: String, serialNumber: String) {
        self.model = model
        self.serialNumber = serialNumber
    }

    var textualDescription: String { // Conforms to TextRepresentable
        return "\(model) (SN: \(serialNumber))"
    }

    var prettyTextualDescription: String { // Conforms to PrettyTextRepresentable
        return "🚀 \(model) - Serial: \(serialNumber) 🚀"
    }
}

print("--- Protocol Inheritance ---")
let discovery = Spaceship(model: "Discovery One", serialNumber: "HAL9000")
print(discovery.textualDescription)       // From TextRepresentable
print(discovery.prettyTextualDescription) // From PrettyTextRepresentable
print("")

/*:
 ---

 ## Delegation

 **Delegation** is a design pattern where one type hands off some responsibilities to an instance of another type (the "delegate"). This is commonly implemented using protocols to define the delegated tasks. Delegates are often declared as `weak` to prevent strong reference cycles, which means the protocol must be **class-only** (by inheriting from `AnyObject`).

 */
class DiceGame {
    let sides: Int
    let generator = LinearCongruentialGenerator() // Reusing the generator from above
    weak var delegate: DiceGameDelegate? // Delegate is weak

    init(sides: Int) {
        self.sides = sides
    }

    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }

    func play(rounds: Int) {
        delegate?.gameDidStart(self)
        for round in 1...rounds {
            let player1 = roll()
            let player2 = roll()
            if player1 == player2 {
                delegate?.game(self, didEndRound: round, winner: nil)
            } else if player1 > player2 {
                delegate?.game(self, didEndRound: round, winner: 1)
            } else {
                delegate?.game(self, didEndRound: round, winner: 2)
            }
        }
        delegate?.gameDidEnd(self)
    }

    // Nested protocol for the delegate
    protocol DiceGameDelegate: AnyObject { // Class-only protocol
        func gameDidStart(_ game: DiceGame)
        func game(_ game: DiceGame, didEndRound round: Int, winner: Int?)
        func gameDidEnd(_ game: DiceGame)
    }
}

class DiceGameTracker: DiceGame.DiceGameDelegate {
    var playerScore1 = 0
    var playerScore2 = 0

    func gameDidStart(_ game: DiceGame) {
        print("Game Tracker: Started a new game!")
        playerScore1 = 0
        playerScore2 = 0
    }

    func game(_ game: DiceGame, didEndRound round: Int, winner: Int?) {
        switch winner {
        case 1:
            playerScore1 += 1
            print("Game Tracker: Player 1 won round \(round)")
        case 2:
            playerScore2 += 1
            print("Game Tracker: Player 2 won round \(round)")
        default:
            print("Game Tracker: Round \(round) was a draw")
        }
    }

    func gameDidEnd(_ game: DiceGame) {
        if playerScore1 == playerScore2 {
            print("Game Tracker: The game ended in a draw.")
        } else if playerScore1 > playerScore2 {
            print("Game Tracker: Player 1 won the game!")
        } else {
            print("Game Tracker: Player 2 won the game!")
        }
    }
}

print("--- Delegation Example ---")
let tracker = DiceGameTracker()
let game = DiceGame(sides: 6)
game.delegate = tracker // Assign the delegate

game.play(rounds: 3)
/* Expected output:
Game Tracker: Started a new game!
(Random results for each round, e.g.)
Game Tracker: Player 1 won round 1
Game Tracker: Player 2 won round 2
Game Tracker: Round 3 was a draw
Game Tracker: The game ended in a draw.
*/

/*:
 ---

 ## Conditionally Conforming to a Protocol

 A generic type can conform to a protocol only under specific conditions (e.g., when its generic parameter also conforms to that protocol). You specify these conditions using a `where` clause in an extension.

 */
// Reusing TextRepresentable and Dice for Array example
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}

print("\n--- Conditionally Conforming to a Protocol ---")
let d6 = Dice(sides: 6)
let d12 = Dice(sides: 12)
let myDiceCollection = [d6, d12]
print(myDiceCollection.textualDescription) // Expected: "[A 6-sided dice, A 12-sided dice]"

// This would NOT compile because Int conforms to TextRepresentable, but String does not (by default in this Playground)
// let mixedCollection = [1, "hello"] // Error: String does not conform to TextRepresentable
// print(mixedCollection.textualDescription)


/*:
 ---

 ## Adopting a Protocol Using a Synthesized Implementation

 Swift can automatically provide protocol conformance for `Equatable`, `Hashable`, and `Comparable` in many simple cases, reducing boilerplate code. You simply declare conformance in the type's original definition, and Swift generates the necessary implementation.

 */
struct Vector3D: Equatable { // Swift synthesizes `==`
    var x = 0.0, y = 0.0, z = 0.0
}

enum SkillLevel: Comparable { // Swift synthesizes `<` (and other comparisons)
    case beginner
    case intermediate
    case expert(stars: Int) // Associated values must also be Comparable
}

print("\n--- Synthesized Protocol Conformance ---")
let v1 = Vector3D(x: 1, y: 2, z: 3)
let v2 = Vector3D(x: 1, y: 2, z: 3)
print("Vectors are equal: \(v1 == v2)") // Expected: true

var levels = [SkillLevel.intermediate, SkillLevel.beginner,
              SkillLevel.expert(stars: 5), SkillLevel.expert(stars: 3)]

print("Sorted Skill Levels:")
for level in levels.sorted() {
    print(level)
}
/* Expected:
 beginner
 intermediate
 expert(stars: 3)
 expert(stars: 5)
*/

/*:
 ---

 ## Implicit Conformance to a Protocol

 For certain common protocols like `Copyable`, `Sendable`, and `BitwiseCopyable`, Swift automatically infers conformance if a type fulfills their requirements. You don't need to explicitly declare it, though you can. You can suppress implicit conformance with `~ProtocolName`.

 */
struct FileDescriptor: Sendable { // Suppresses implicit Sendable conformance
    let rawValue: Int
}

print("\n--- Implicit Conformance ---")
print("FileDescriptor struct intentionally suppresses Sendable conformance with ~Sendable.")
print("Other types like simple structs often get Copyable/Sendable implicitly.")
