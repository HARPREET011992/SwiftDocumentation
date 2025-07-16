import UIKit

/*:
 # Automatic Reference Counting (ARC)

 ## Definition
 **Automatic Reference Counting (ARC)** is Swift's memory management system. It automatically tracks and manages your app's memory usage for **class instances**. When an instance of a class is no longer needed, ARC automatically frees up the memory it used, preventing memory leaks and ensuring efficient resource utilization.

 **Important Note:** ARC applies *only* to **class instances**. Structures and enumerations are value types and are not managed by ARC.

 ---

 ## How ARC Works

 1.  **Allocation:** When you create a new instance of a class, ARC allocates memory to store that instance's properties and type information.
 2.  **Reference Counting:** ARC keeps a count of how many **strong references** (properties, constants, variables) currently point to an instance.
 3.  **Deallocation:** ARC will **not deallocate** an instance as long as at least one strong reference to it exists. When the strong reference count drops to zero, ARC frees the memory.

 A **strong reference** is the default type of reference. It "keeps a firm hold" on an instance, preventing it from being deallocated.

 */
print("--- How ARC Works (ARC in Action) ---")

class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

// Declare optional variables to demonstrate deallocation
var reference1: Person?
var reference2: Person?
var reference3: Person?

// Create a new Person instance. Strong reference count = 1 (from reference1)
reference1 = Person(name: "John Appleseed")
// Expected Output: "John Appleseed is being initialized"

// Assigning to other variables creates more strong references
reference2 = reference1 // Strong reference count = 2
reference3 = reference1 // Strong reference count = 3

print("Strong references exist for John Appleseed.")

// Break two strong references. Strong reference count = 1
reference1 = nil
reference2 = nil
print("Two references released. John Appleseed still exists.")

// Break the final strong reference. Strong reference count = 0, instance deallocated.
reference3 = nil
// Expected Output: "John Appleseed is being deinitialized"
print("All references released. John Appleseed deinitialized.\n")

/*:
 ---

 ## Strong Reference Cycles Between Class Instances

 A **strong reference cycle** occurs when two (or more) class instances hold strong references to each other. This prevents their reference counts from ever dropping to zero, leading to a **memory leak** because ARC cannot deallocate them.

 */
print("--- Strong Reference Cycles Between Class Instances ---")

class Tenant {
    let name: String
    init(name: String) { self.name = name }
    var apartment: ApartmentStrong? // Strong reference to an Apartment
    deinit { print("\(name) is being deinitialized") }
}

class ApartmentStrong {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Tenant? // Strong reference to a Tenant
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Tenant?
var unit4A: ApartmentStrong?

// Create instances, strong references from 'john' and 'unit4A'
john = Tenant(name: "John Appleseed")
unit4A = ApartmentStrong(unit: "4A")

print("Instances initialized.")

// Create strong references to each other
john!.apartment = unit4A // John has a strong reference to Apartment
unit4A!.tenant = john     // Apartment has a strong reference to John

print("Strong reference cycle created between John and Apartment 4A.")

// Attempt to break external strong references
john = nil
unit4A = nil

print("External references released, but deinitializers were NOT called!")
print("This indicates a memory leak due to a strong reference cycle.\n")
// Expected: No deinitialization messages for John or Apartment 4A

/*:
 ---

 ## Resolving Strong Reference Cycles

 Swift provides two keywords to break strong reference cycles: `weak` and `unowned`. Both prevent a strong hold on the referenced instance.

 ### Weak References (`weak`)

 -   Used when the other instance has a **shorter lifetime** or can be deallocated first (e.g., an `Apartment` might exist without a `Tenant`).
 -   **Does not keep a strong hold.**
 -   Automatically set to `nil` when the referenced instance is deallocated.
 -   Always declared as **optional variables** (`var`), because they can become `nil`.

 */
print("--- Resolving Strong Reference Cycles: Weak References ---")

class PersonWeak {
    let name: String
    init(name: String) { self.name = name }
    var apartment: ApartmentWeak? // Strong reference to Apartment
    deinit { print("\(name) is being deinitialized") }
}

class ApartmentWeak {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: PersonWeak? // **Weak reference** to Person
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var jane: PersonWeak?
var unit2B: ApartmentWeak?

jane = PersonWeak(name: "Jane Doe")
unit2B = ApartmentWeak(unit: "2B")

jane!.apartment = unit2B
unit2B!.tenant = jane // Weak reference from Apartment to Person

print("Weak reference established.")

// Break the strong reference from 'jane'.
// PersonWeak instance's strong reference count drops to 0.
jane = nil
// Expected Output: "Jane Doe is being deinitialized"
print("Jane Doe released. Apartment 2B's tenant reference is now nil.")

// Break the strong reference from 'unit2B'.
// ApartmentWeak instance's strong reference count drops to 0.
unit2B = nil
// Expected Output: "Apartment 2B is being deinitialized"
print("Apartment 2B released. All memory freed.\n")

/*:
 ### Unowned References (`unowned`)

 -   Used when the other instance has the **same lifetime or a longer lifetime** (e.g., a `CreditCard` *always* belongs to a `Customer`, and the card won't outlive the customer).
 -   **Does not keep a strong hold.**
 -   **Never becomes `nil`** during its lifetime; it's always expected to refer to an existing instance.
 -   Always declared as **non-optional variables or constants** (`var` or `let`).
 -   **Important:** Accessing an unowned reference after its instance has been deallocated leads to a runtime error.

 */
print("--- Resolving Strong Reference Cycles: Unowned References ---")

class Customer {
    let name: String
    var card: CreditCard? // Optional strong reference to CreditCard
    init(name: String) { self.name = name }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer // **Unowned reference** to Customer (non-optional)
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

var david: Customer?

david = Customer(name: "David Smith")
// CreditCard initializer requires a customer, ensuring it always has one.
david!.card = CreditCard(number: 1234_5678_9012_3456, customer: david!)

print("Unowned reference established.")

// Break the strong reference from 'david'.
// Customer instance's strong reference count drops to 0.
david = nil
// Expected Output:
// "David Smith is being deinitialized"
// "Card #1234567890123456 is being deinitialized"
print("David Smith and CreditCard deinitialized.\n")

/*:
 ### Unowned Optional References (`unowned var someProperty: Type?`)

 -   Introduced in Swift 5. It combines aspects of unowned and optionality.
 -   Used when the other instance has the same or longer lifetime, but the reference itself can temporarily be `nil`.
 -   Behaves like a regular unowned reference for ARC (no strong hold), but can be `nil`.
 -   You are responsible for ensuring it always refers to a valid object or is `nil`.

 */
print("--- Unowned Optional References ---")

class Department {
    var name: String
    var courses: [Course] // Strong references to courses
    init(name: String) {
        self.name = name
        self.courses = []
    }
    deinit { print("\(name) department is being deinitialized") }
}

class Course {
    var name: String
    unowned let department: Department // Unowned: Course must always have a department
    unowned var nextCourse: Course? // Unowned Optional: May or may not have a next course
    init(name: String, in department: Department) {
        self.name = name
        self.department = department
        self.nextCourse = nil
    }
    deinit { print("\(name) course is being deinitialized") }
}

var dept: Department? = Department(name: "Computer Science")
let introCS = Course(name: "Intro to CS", in: dept!)
let dataStruct = Course(name: "Data Structures", in: dept!)
let algorithms = Course(name: "Algorithms", in: dept!)

introCS.nextCourse = dataStruct
dataStruct.nextCourse = algorithms
dept!.courses = [introCS, dataStruct, algorithms]

print("Department and courses initialized.")

// Deallocate the department. All courses are also deallocated.
dept = nil
// Expected Output (order might vary slightly):
// "Intro to CS course is being deinitialized"
// "Data Structures course is being deinitialized"
// "Algorithms course is being deinitialized"
// "Computer Science department is being deinitialized"
print("Department and courses deinitialized without a cycle.\n")

/*:
 ### Unowned References and Implicitly Unwrapped Optional Properties

 Used when **both properties must always have a value** once initialization is complete, and neither should be `nil`. This is common for two instances that are mutually dependent.

 -   One property is `unowned`.
 -   The other property is an **implicitly unwrapped optional** (`Type!`). This allows a temporary `nil` value during initialization, which is automatically unwrapped for access later.

 */
print("--- Unowned & Implicitly Unwrapped Optional Properties ---")

class Country {
    let name: String
    var capitalCity: City! // Implicitly unwrapped optional (strong reference)
    init(name: String, capitalName: String) {
        self.name = name
        // `self` is available here because `name` is set, and `capitalCity` has a default nil value
        self.capitalCity = City(name: capitalName, country: self)
    }
    deinit { print("\(name) country is being deinitialized") }
}

class City {
    let name: String
    unowned let country: Country // Unowned reference to Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
    deinit { print("\(name) city is being deinitialized") }
}

var myCountry: Country? = Country(name: "Canada", capitalName: "Ottawa")
print("\(myCountry!.name)'s capital city is called \(myCountry!.capitalCity.name)")
// Expected Output: "Canada's capital city is called Ottawa"

print("Country and City initialized.")

// Deallocate the country. Both instances are deallocated.
myCountry = nil
// Expected Output:
// "Ottawa city is being deinitialized"
// "Canada country is being deinitialized"
print("Country and City deinitialized without a cycle.\n")

/*:
 ---

 ## Strong Reference Cycles for Closures

 A strong reference cycle can also occur if a **closure** (which is a **reference type** like classes) is assigned to a property of a class instance, and the closure's body **captures** that instance (e.g., by referring to `self`).

 */
print("--- Strong Reference Cycles for Closures ---")

class HTMLElement {
    let name: String
    let text: String?
    // `lazy` allows `self` to be referenced in the closure's default value
    // This closure captures `self` implicitly, creating a cycle.
    lazy var asHTML: () -> String = {
        if let text = self.text { // Captures self
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }

    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
        print("\(name) element is being initialized")
    }

    deinit {
        print("\(name) element is being deinitialized")
    }
}

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
_ = paragraph!.asHTML() // Access the lazy property to initialize the closure
print("HTML Element initialized and closure created.")

// Attempt to release the HTML element
paragraph = nil
print("HTML Element reference released, but deinitializer was NOT called!")
print("This indicates a memory leak due to a strong reference cycle between the instance and its closure.\n")
// Expected: No deinitialization message for "p"

/*:
 ### Resolving Strong Reference Cycles for Closures (Capture Lists)

 You resolve closure cycles using a **capture list** within the closure's definition. This specifies how references (like `self`) are captured: as `weak` or `unowned`.

 **Syntax:** `[weak self]` or `[unowned self]` placed before the closure's parameter list (or `in` keyword if no parameters/return type).

 */
print("--- Resolving Strong Reference Cycles for Closures: Capture Lists ---")

class OtherHTMLElement {
    let name: String
    let text: String?
    // Use a capture list to break the cycle: [unowned self]
    lazy var asHTML: () -> String = {
        [unowned self] in // self is captured as unowned
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }

    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
        print("\(name) element (resolved) is being initialized")
    }

    deinit {
        print("\(name) element (resolved) is being deinitialized")
    }
}

var heading: OtherHTMLElement? = OtherHTMLElement(name: "h1", text: "Welcome")
_ = heading!.asHTML() // Access the lazy property
print("HTML Element (resolved) initialized and closure created.")

// Release the HTML element
heading = nil
// Expected Output: "h1 element (resolved) is being deinitialized"
print("HTML Element (resolved) reference released, deinitializer WAS called. Cycle resolved!\n")

/*:
 **When to use `weak self` vs. `unowned self` in closures:**

 -   **`weak self`**: Use when `self` might become `nil` *before* the closure is executed. The captured `self` will be an optional (`self?`), requiring optional chaining (`self?.property`) or optional binding (`if let self = self`).
 -   **`unowned self`**: Use when you are certain that the closure will *always* be executed *before* `self` is deallocated. The captured `self` will be a non-optional value, so you can access properties directly (`self.property`). If `self` is deallocated before the closure is called, a runtime error will occur.

 ---

 ## Conclusion

 ARC generally "just works," but understanding strong reference cycles and how to resolve them with **weak** and **unowned** references (including in closure capture lists) is crucial for writing robust, leak-free Swift applications.

 What other aspects of memory management or related Swift features would you like to explore?
 */
