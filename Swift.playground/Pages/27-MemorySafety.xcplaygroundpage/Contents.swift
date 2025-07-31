import Foundation

print("--- Understanding Conflicting Access to Memory ---")

var myNumber = 1 // Write access (instantaneous)
print("My number is \(myNumber)") // Read access (instantaneous)

print("\nMost memory accesses are instantaneous and don't conflict.")
print("Conflicts arise when memory is in a temporary, inconsistent state due to long-term accesses.\n")
print("--- Conflicting Access to In-Out Parameters ---")

var stepSize = 1

@MainActor func increment(_ number: inout Int) {
    number += stepSize // Read access to stepSize
}
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
print("Balanced scores: Player One: \(playerOneScore), Player Two: \(playerTwoScore)")

print("Passing `&playerOneScore` to both `x` and `y` in `balance` would cause a conflict.\n")
print("This is because the function needs two long-term write accesses to the *same* memory location simultaneously.\n")
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
        balance(&teammate.health, &self.health)
    }
}

var oscar = Player(name: "Oscar", health: 10, energy: 10)
var maria = Player(name: "Maria", health: 5, energy: 10)

oscar.shareHealth(with: &maria) // OK: 'self' is oscar, 'teammate' is maria (different memory)
print("Oscar's health: \(oscar.health), Maria's health: \(maria.health)") // Expected: Oscar: 7, Maria: 8

print("\nCalling `oscar.shareHealth(with: &oscar)` would cause a conflict.")
print("The mutating method `shareHealth` needs write access to `self` (oscar) for its duration.")
print("Simultaneously, `oscar` is passed as an in-out parameter, also requiring write access.")
print("This results in two overlapping write accesses to the *same* `oscar` instance.\n")

print("--- Conflicting Access to Properties of Value Types ---")

var playerInformation = (health: 10, energy: 20)

print("Trying to `balance(&playerInformation.health, &playerInformation.energy)` would cause a conflict.")
print("Both `health` and `energy` are properties of the `playerInformation` tuple.")
print("Modifying either property requires a write access to the entire `playerInformation` tuple.")
print("Thus, there are two overlapping write accesses to the *same* `playerInformation` tuple.\n")

// This also applies to struct properties stored in global variables:
var holly = Player(name: "Holly", health: 10, energy: 10)
// balance(&holly.health, &holly.energy)
// This would also cause a compile-time error similar to the tuple example.
print("The same conflict occurs for properties of a struct stored in a global variable.\n")

func demonstrateSafeAccess() {
    var localOscar = Player(name: "Oscar", health: 10, energy: 10)
    balance(&localOscar.health, &localOscar.energy) // OK - Compiler proves this is safe!
    print("Local Oscar's health: \(localOscar.health), energy: \(localOscar.energy)") // Expected: 15, 15
}
demonstrateSafeAccess()
