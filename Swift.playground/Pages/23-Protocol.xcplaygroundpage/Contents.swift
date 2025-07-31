import Foundation

//Protocols in Swift define a blueprint of methods, properties, and other requirements that a class, structure, or enumeration can adopt. Any type that fulfills these requirements is said to conform to the protocol. This allows for flexible and extensible code design.
//
//Protocol Syntax and Adoption
//
//Protocols are defined similarly to classes, structures, and enumerations, using the protocol keyword:

protocol SomeProtocol {
    // protocol definition goes here
}

//Custom types adopt a protocol by listing its name after the type's name, separated by a colon. Multiple protocols can be adopted by separating their names with commas:
//

struct SomeStructure: FirstProtocol, AnotherProtocol {
    // structure definition goes here
}

class SomeClass: SomeSuperclass, FirstProtocol, AnotherProtocol {
    // class definition goes here
}
//Note: Protocol names, like other types in Swift, should begin with a capital letter.
//
//Property Requirements
//
//Protocols can require conforming types to provide specific instance or type properties. The protocol specifies the property name, type, and whether it must be gettable or gettable and settable.
//
//gettable and settable properties are indicated by { get set }.
//
//gettable properties are indicated by { get }.
//
//Property requirements are always declared with the var keyword.
//
//Type property requirements must be prefixed with static in the protocol definition.
//
//Swift
protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
    static var someTypeProperty: Int { get set }
}
//Example: FullyNamed Protocol
//
//The FullyNamed protocol requires a conforming type to have a gettable String property called fullName:
//
//Swift
protocol FullyNamed {
    var fullName: String { get }
}

struct Person: FullyNamed {
    var fullName: String // Conforms by having a stored property
}

class Starship: FullyNamed {
    var prefix: String?
    var name: String

    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }

    var fullName: String { // Conforms by having a computed property
        return (prefix != nil ? prefix! + " " : "") + name
    }
}
//Method Requirements
//
//Protocols can require instance and type methods. These are declared without a method body. Default values for parameters are not allowed in protocol method definitions.
//
//Type method requirements must be prefixed with static in the protocol definition.
//
//Swift
protocol SomeProtocol {
    static func someTypeMethod()
}
//Example: RandomNumberGenerator Protocol
//
//The RandomNumberGenerator protocol requires a random() instance method that returns a Double:
//
//Swift
protocol RandomNumberGenerator {
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0

    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}
//Mutating Method Requirements
//
//For methods that modify instances of value types (structures and enumerations), the mutating keyword is used in the protocol definition.
//
//Swift
protocol Togglable {
    mutating func toggle()
}

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
//Note: The mutating keyword is only necessary for value types; it's not required when implementing a mutating protocol method in a class.
//
//Initializer Requirements
//
//Protocols can require specific initializers. Conforming classes must mark their initializer implementations with the required modifier to ensure all subclasses also conform.
//
//Swift
protocol SomeProtocol {
    init(someParameter: Int)
}

class SomeClass: SomeProtocol {
    required init(someParameter: Int) {
        // initializer implementation goes here
    }
}
//If a class overrides a designated initializer from a superclass and also implements a matching protocol initializer requirement, use both required and override.
//
//Failable initializer requirements can be satisfied by failable or nonfailable initializers. Nonfailable initializer requirements can be satisfied by nonfailable or implicitly unwrapped failable initializers.
//
//Protocols with Semantic Requirements Only
//
//Some protocols, like Sendable, Copyable, and BitwiseCopyable, don't have explicit method or property requirements. They define semantic requirements about how values of those types behave. Swift often implicitly adds conformance to these protocols.
//
//Swift
struct MyStruct: Copyable {
    var counter = 12
}

extension MyStruct: BitwiseCopyable { } // Empty extension for semantic conformance
// You can suppress implicit conformance by writing a tilde (~) before the protocol name or by using an unavailable extension.
//
//Protocols as Types
//
//Protocols can be used as types in your code, most commonly as generic constraints, opaque types, or boxed protocol types.
//
//Generic constraints: Allow functions to work with any type that conforms to a specific protocol.
//
//Opaque types: Hide the underlying type from clients of an API, guaranteeing only conformance to a protocol.
//
//Boxed protocol types: Allow for runtime flexibility, working with any type that conforms to the protocol, but with a performance cost.
//
//Protocols can also be used to define the type of elements in collections:


let things: [TextRepresentable] = [game, d12, simonTheHamster]
Delegation

Delegation is a design pattern where one type hands off some responsibilities to an instance of another type (the delegate). This is implemented by defining a protocol that encapsulates the delegated responsibilities.

Swift
class DiceGame {
    // ...
    weak var delegate: Delegate? // Delegate property
    // ...
    protocol Delegate: AnyObject { // Class-only protocol for weak reference
        func gameDidStart(_ game: DiceGame)
        func game(_ game: DiceGame, didEndRound round: Int, winner: Int?)
        func gameDidEnd(_ game: DiceGame)
    }
    // ...
}

class DiceGameTracker: DiceGame.Delegate {
    // ... implementation of delegate methods ...
}
//Delegates are typically declared as weak references to prevent strong reference cycles. This requires the protocol to be class-only, achieved by inheriting from AnyObject.
//
//Protocols can be nested within type declarations.
//
//Adding Protocol Conformance with an Extension
//
//Existing types can adopt and conform to new protocols using extensions, even if you don't have access to their original source code.
//
//Swift
protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}
//If a type already satisfies all protocol requirements, an empty extension can be used to declare its adoption of the protocol.
//
//Conditionally Conforming to a Protocol
//
//Generic types can conditionally conform to a protocol using a where clause in an extension. This means the conformance only applies when the generic parameter(s) meet certain conditions.
//
//Swift
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}
//Synthesized Protocol Implementations
//
//Swift can automatically provide protocol conformance for Equatable, Hashable, and Comparable in many cases, reducing boilerplate code.
//
//Equatable: Synthesized for structures and enumerations with Equatable stored properties or associated types, or enumerations with no associated types.
//
//Hashable: Synthesized for structures and enumerations with Hashable stored properties or associated types, or enumerations with no associated types.
//
//Comparable: Synthesized for enumerations without raw values; associated types must conform to Comparable.
//
//Protocol Inheritance
//
//Protocols can inherit from one or more other protocols, adding further requirements.
//
//Swift
protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    // additional protocol definition goes here
}

protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}
//Any type adopting PrettyTextRepresentable must satisfy the requirements of both PrettyTextRepresentable and TextRepresentable.

// Class-Only Protocols

//You can restrict protocol adoption to only class types by adding the AnyObject protocol to its inheritance list.

protocol SomeClassOnlyProtocol: AnyObject, SomeInheritedProtocol {
    // class-only protocol requirements
}
