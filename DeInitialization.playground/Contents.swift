import UIKit

/*
Deinitialization is the process of cleaning up a class instance just before it is deallocated from memory. You use a deinitializer (deinit) to perform any custom cleanup tasks such as closing files, releasing resources, or returning borrowed items. Deinitializers are only available for class types and are called automatically when an instance is about to be destroyed.

Key Points
Written with deinit { } and takes no parameters.
Called automatically before an instance is deallocated.
You cannot call a deinitializer yourself.
Superclass deinitializers are called automatically after subclass deinitializers.
You can access properties in the deinitializer since the instance is still valid.
*/
actor Bank {
    static var coinsInBank = 10_000

    static func distribute(coins requested: Int) -> Int {
        let coinsToGive = min(requested, coinsInBank)
        coinsInBank -= coinsToGive
        return coinsToGive
    }

    static func receive(coins: Int) {
        coinsInBank += coins
    }
}

class Player {
    var coinsInPurse: Int

    init(coins: Int) {
        coinsInPurse = Bank.distribute(coins: coins)
    }

    func win(coins: Int) {
        coinsInPurse += Bank.distribute(coins: coins)
    }

    deinit {
        Bank.receive(coins: coinsInPurse)  // Return coins when player leaves
    }
}

var player: Player? = Player(coins: 100)
print("Player starts with \(player!.coinsInPurse) coins.")
print("Coins left in bank: \(Bank.coinsInBank)")

player!.win(coins: 2000)
print("Player now has \(player!.coinsInPurse) coins.")
print("Coins left in bank: \(Bank.coinsInBank)")

player = nil  // Player leaves the game, triggers deinit
print("Player left the game.")
print("Coins back in bank: \(Bank.coinsInBank)")

