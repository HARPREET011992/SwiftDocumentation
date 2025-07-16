import UIKit

/*:
 # Access Control in Swift

 ## Definition
 **Access control** in Swift restricts the visibility and usability of parts of your code (like classes, structs, enums, properties, methods, etc.) from other source files and **modules**. Its primary purpose is to **hide implementation details** and define a clear, preferred **public interface (API)** for your code.

 By default, most entities in Swift have an `internal` access level. For single-target apps, you often don't need to specify access levels explicitly. However, it becomes crucial when building **frameworks** or **multi-module applications**.

 ---

 ## Modules, Source Files, and Packages

 Swift's access control is based on these concepts:

 -   **Module:** A single unit of code distribution, like an Xcode app target or a framework. When you `import` something, you're importing a module.
 -   **Source File:** A single Swift `.swift` file within a module.
 -   **Package:** A group of modules, typically defined by a build system like Swift Package Manager (`Package.swift`).

 ---

 ## Access Levels

 Swift provides six access levels, from most to least restrictive:

 1.  **`private`**: Restricts use to the **enclosing declaration** (e.g., a specific class) and its extensions *within the same source file*.
 2.  **`fileprivate`**: Restricts use to the **current source file**.
 3.  **`internal`** (Default): Restricts use to the **defining module**.
 4.  **`package`**: Restricts use to the **defining package**. This is typically used when you have multiple modules within a single package.
 5.  **`public`**: Allows use within **any source file** in the defining module, and **any module that imports** the defining module. Defines the public API of a framework.
 6.  **`open`**: Applies only to **classes and their members**. Same as `public`, but additionally allows **subclassing and overriding** from outside the defining module. This explicitly signals that the class is designed for external inheritance.

 **Guiding Principle:** **No entity can be defined in terms of another entity that has a lower (more restrictive) access level.**
 For example, a `public` variable cannot have a `private` type, because the type wouldn't be accessible everywhere the variable is.

 */
print("--- Access Levels in Action ---")

// Example of different access levels
open class OpenClass { // Can be subclassed outside the module
    public var publicProperty = "Accessible everywhere"
    internal var internalProperty = "Accessible within this module"
    fileprivate func filePrivateMethod() { print("Accessible only in this file.") }
    private func privateMethod() { print("Accessible only in this class declaration.") }

    public init() {}
    internal init(internalValue: String) { self.internalProperty = internalValue }
    fileprivate init(filePrivateValue: String) { self.filePrivateMethod() } // Can call filePrivateMethod
}

public class PublicClass { // Can be used outside module, but not subclassed (unless open)
    public var publicProp = "Public from PublicClass"
    var internalProp = "Internal by default in public type" // Implicitly internal
    fileprivate func filePrivateFunc() { print("File-private func in PublicClass.") }
    private func privateFunc() { print("Private func in PublicClass.") }
}

class InternalClass { // Implicitly internal
    var internalMember = "Internal member" // Implicitly internal
    fileprivate func internalFilePrivateFunc() {}
    private func internalPrivateFunc() {}
}

fileprivate class FilePrivateClass { // Only usable within this file
    var filePrivateMember = "File-private member" // Implicitly file-private
    private func privateFuncInFilePrivate() {}
}

private class PrivateClass { // Only usable within this specific declaration
    var privateMember = "Private member" // Implicitly private
}


/*:
 ### Access Levels for Members of a Type

 -   If a type is `private` or `fileprivate`, its members automatically inherit that same access level.
 -   If a type is `internal` or `public`, its members default to `internal`.
    -   You **must explicitly mark** members as `public` if you want them to be part of the public API of a `public` type.
 */

public struct MyPublicStruct {
    public var publicValue = 10         // Explicitly public
    var internalValue = 20              // Implicitly internal (since struct is public)
    private(set) var controlledValue = 5 // Getter is public, setter is private
}

let myStruct = MyPublicStruct()
print("Public value: \(myStruct.publicValue)")
// print(myStruct.internalValue) // Error if accessed from another module

var modifiableStruct = MyPublicStruct()
// modifiableStruct.controlledValue = 6 // Error: 'set' is private

/*:
 ### Default Access Levels

 -   Unless specified, all entities have an `internal` access level.
 -   This is convenient for single-target apps where everything is typically within one module.

 */
class AnotherInternalClass { // Implicitly internal
    func someMethod() {}     // Implicitly internal
}

/*:
 ### Subclassing and Overriding

 -   You can subclass any class visible in the current context within the same module.
 -   You can subclass any `open` class from another module.
 -   A subclass **cannot have a higher access level** than its superclass.
 -   Overrides can make inherited members **more accessible** (e.g., `fileprivate` to `internal`).

 */
public class BaseClass {
    fileprivate func secretMethod() { print("Base secret method.") }
}

internal class SubClass: BaseClass {
    override internal func secretMethod() { // Valid: increasing access from fileprivate to internal
        super.secretMethod() // Valid: calling super's method from same file/module
        print("SubClass version of secret method.")
    }
}

let sub = SubClass()
sub.secretMethod() // Accessible because it's internal now.

/*:
 ### Getters and Setters

 -   Getters and setters usually have the same access level as the property/subscript.
 -   You can give a **setter a lower access level** using `fileprivate(set)`, `private(set)`, `internal(set)`, or `package(set)`. This creates a read-only property for external access while allowing internal modification.

 */
struct Temperature {
    var celsius: Double
    // Public getter, private setter for fahrenheit
    public private(set) var fahrenheit: Double {
        get { return celsius * 9 / 5 + 32 }
        set { celsius = (newValue - 32) * 5 / 9 }
    }
}

var temp = Temperature(celsius: 25)
print("Temperature in Fahrenheit: \(temp.fahrenheit)") // Getter is public
// temp.fahrenheit = 70 // Error: 'set' for 'fahrenheit' is 'private'

/*:
 ### Protocols

 -   Protocols define their own access level.
 -   All requirements within a protocol automatically get the **same access level** as the protocol itself.
 -   A type conforming to a protocol must implement all requirements with **at least the protocol's access level**.

 */
public protocol Identifiable {
    var id: String { get } // Automatically public because protocol is public
    func identify()        // Automatically public
}

public struct User: Identifiable {
    public var id: String = UUID().uuidString
    public func identify() { print("User ID: \(id)") } // Must be public
}

/*:
 ### Extensions

 -   Extensions default to the same access level as the type they extend.
 -   You can provide an explicit access-level modifier for an extension to change the default for its members (e.g., `private extension MyType { ... }`).
 -   Extensions in the same file as the original type can access its `private` members.

 */
struct SomeData {
    private var internalSecret = 100
}

extension SomeData { // Implicitly internal
    func printSecret() {
        print("The secret is: \(internalSecret)") // Can access private member from same file
    }
}

let data = SomeData()
data.printSecret() // Expected: The secret is: 100

/*:
 ### Generics & Type Aliases

 -   **Generic types/functions:** Access level is the *minimum* of the generic type/function's access level and any type constraints.
 -   **Type Aliases:** Can have an access level less than or equal to the type they alias (e.g., a `public` alias cannot point to an `internal` type).

 ---

 Access control is a powerful tool for designing clear, maintainable APIs and ensuring the stability and security of your code by managing what parts are visible and modifiable from different parts of your application or framework.

 */
