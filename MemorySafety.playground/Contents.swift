import UIKit

/*:
 # Conflicting Access to Memory

 Swift prioritizes **memory safety** by preventing unsafe behaviors like using uninitialized variables, accessing deallocated memory, or out-of-bounds array access. A key aspect of this is ensuring **exclusive access** to memory locations when modifications occur.

 ## Definition

 **Conflicting access to memory** happens when different parts of your code try to access the same location in memory at the same time, and at least one of those accesses is a write. Swift guarantees that such conflicts result in a compile-time or runtime error on a single thread.

 ### Characteristics of Conflicting Access:
 A conflict occurs if two accesses meet ALL of these conditions:
 1.  They are **not both reads**, and are **not both atomic** operations.
 2.  They access the **same location in memory**.
 3.  Their **durations overlap**.

 -   **Read vs. Write:** A write access changes memory; a read access doesn't.
 -   **Location:** Refers to a variable, constant, or property.
 -   **Duration:**
    -   **Instantaneous:** Most accesses are instantaneous (e.g., `var x = 1; print(x)`). Other code cannot run during this access.
    -   **Long-term:** Accesses that span the execution of other code, allowing overlap (e.g., in-out parameters, mutating methods).

 */
print("--- Understanding Conflicting Access to Memory ---")

var myNumber = 1 // Write access (instantaneous)
print("My number is \(myNumber)") // Read access (instantaneous)

print("\nMost memory accesses are instantaneous and don't conflict.")
print("Conflicts arise when memory is in a temporary, inconsistent state due to long-term accesses.\n")

/*:
 ---

 ## Conflicting Access to In-Out Parameters

 A function has **long-term write access** to all of its **in-out parameters** (`inout`). This write access begins after all non-in-out parameters are evaluated and lasts for the entire function call.

 ### Scenario 1: Accessing the original variable passed as `inout`

 */
print("--- Conflicting Access to In-Out Parameters ---")

var stepSize = 1

@MainActor func increment(_ number: inout Int) {
    number += stepSize // Read access to stepSize
}

// increment(&stepSize)
// This line would cause a compile-time error:
// "Conflicting accesses to 'stepSize'
//  Simultaneous accesses to 0x... because 'stepSize' is an inout argument and is also used in the called function"

print("Trying to `increment(&stepSize)` would cause a conflict!")
print("`stepSize` is modified as an in-out parameter, and also read from within the function body.")
print("The write access to the in-out parameter overlaps with the read access to the global variable.\n")

// How to fix this conflict: Make an explicit copy
var copyOfStepSize = stepSize
increment(&copyOfStepSize)
stepSize = copyOfStepSize
print("After fix: stepSize is now \(stepSize)") // Expected: 2
print("Making a copy resolves the conflict because the read of `stepSize` ends before the write to `copyOfStepSize` begins.\n")

/*:
 ### Scenario 2: Passing a single variable to multiple `inout` parameters

 */
func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}

var playerOneScore = 42
var playerTwoScore = 30

balance(&playerOneScore, &playerTwoScore) // OK, different memory locations
print("Balanced scores: Player One: \(playerOneScore), Player Two: \(playerTwoScore)") // Expected: 36, 36

// balance(&playerOneScore, &playerOneScore)
// This line would cause a compile-time error:
// "Conflicting accesses to 'playerOneScore'
//  Simultaneous accesses to 0x... because 'playerOneScore' is an inout argument and is also used as an inout argument"

print("Passing `&playerOneScore` to both `x` and `y` in `balance` would cause a conflict.\n")
print("This is because the function needs two long-term write accesses to the *same* memory location simultaneously.\n")

/*:
 ---

 ## Conflicting Access to `self` in Mutating Methods

 A **mutating method** on a **structure** (or enum) has **long-term write access** to `self` for the entire duration of the method call.

 */
print("--- Conflicting Access to `self` in Mutating Methods ---")

struct Player {
    var name: String
    var health: Int
    var energy: Int
    static let maxHealth = 10

    mutating func restoreHealth() {
        health = Player.maxHealth // Write access to self.health (part of self)
    }

    mutating func shareHealth(with teammate: inout Player) {
        // Here, `self` is one player, `teammate` is another.
        // `self` (Player 1) has a long-term write access, and `teammate` (Player 2) also has one.
        // If they are different instances, it's fine.
        balance(&teammate.health, &self.health)
    }
}

var oscar = Player(name: "Oscar", health: 10, energy: 10)
var maria = Player(name: "Maria", health: 5, energy: 10)

oscar.shareHealth(with: &maria) // OK: 'self' is oscar, 'teammate' is maria (different memory)
print("Oscar's health: \(oscar.health), Maria's health: \(maria.health)") // Expected: Oscar: 7, Maria: 8

// oscar.shareHealth(with: &oscar)
// This line would cause a compile-time error:
// "Conflicting accesses to 'oscar'
//  Simultaneous accesses to 0x... because 'oscar' is an inout argument and is also used as 'self' property"

print("\nCalling `oscar.shareHealth(with: &oscar)` would cause a conflict.")
print("The mutating method `shareHealth` needs write access to `self` (oscar) for its duration.")
print("Simultaneously, `oscar` is passed as an in-out parameter, also requiring write access.")
print("This results in two overlapping write accesses to the *same* `oscar` instance.\n")

/*:
 ---

 ## Conflicting Access to Properties of Value Types

 When you modify a property of a **value type** (struct, tuple, enum), you are implicitly mutating the **entire value**. This means write access to one property requires write access to the whole value.

 */
print("--- Conflicting Access to Properties of Value Types ---")

var playerInformation = (health: 10, energy: 20)

// balance(&playerInformation.health, &playerInformation.energy)
// This line would cause a compile-time error:
// "Conflicting accesses to 'playerInformation'
//  Simultaneous accesses to 0x... because 'playerInformation.health' is an inout argument and is also used as an inout argument"

print("Trying to `balance(&playerInformation.health, &playerInformation.energy)` would cause a conflict.")
print("Both `health` and `energy` are properties of the `playerInformation` tuple.")
print("Modifying either property requires a write access to the entire `playerInformation` tuple.")
print("Thus, there are two overlapping write accesses to the *same* `playerInformation` tuple.\n")

// This also applies to struct properties stored in global variables:
var holly = Player(name: "Holly", health: 10, energy: 10)
// balance(&holly.health, &holly.energy)
// This would also cause a compile-time error similar to the tuple example.
print("The same conflict occurs for properties of a struct stored in a global variable.\n")

/*:
 ### Compiler's Smartness: Safe Overlapping Access

 Swift's compiler can sometimes prove that overlapping access to properties of a structure is safe and allows it, even if it technically violates exclusive access. This happens if:

 1.  You're accessing only **stored properties** (not computed properties or class properties).
 2.  The structure is the value of a **local variable** (not a global variable).
 3.  The structure is **not captured by any closures**, or only by non-escaping closures.

 */
func demonstrateSafeAccess() {
    var localOscar = Player(name: "Oscar", health: 10, energy: 10)
    balance(&localOscar.health, &localOscar.energy) // OK - Compiler proves this is safe!
    print("Local Oscar's health: \(localOscar.health), energy: \(localOscar.energy)") // Expected: 15, 15
}

print("--- Compiler's Smartness: Safe Overlapping Access ---")
demonstrateSafeAccess()
print("When a struct is a local variable, the compiler can analyze that modifying `health` and `energy` simultaneously is safe because they are independent stored properties within the same instance.\n")

/*:
 ---

 ## Conclusion

 Swift's memory safety features, including the prevention of conflicting access, are designed to help you write robust and predictable code. By understanding the concepts of instantaneous vs. long-term access, and the specific scenarios involving in-out parameters and mutating methods on value types, you can proactively avoid common memory access errors and ensure your applications run smoothly.

 What other aspects of Swift's memory model or safety features would you like to explore?
 */
