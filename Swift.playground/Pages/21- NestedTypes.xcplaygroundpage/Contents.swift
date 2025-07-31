//: [Previous](@previous)

import Foundation

struct BlackjackCard {
    /// Represents the suit of a playing card.
    enum Suit: Character {
        case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
    }

    /// Represents the rank of a playing card, and its associated values in Blackjack.
    enum Rank: Int {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace

        /// A nested structure to hold the possible values of a card.
        struct Values {
            let first: Int
            let second: Int? // Optional for cards that only have one value
        }

        /// A computed property that returns the Blackjack value(s) for the rank.
        var values: Values {
            switch self {
            case .ace:
                return Values(first: 1, second: 11)
            case .jack, .queen, .king:
                return Values(first: 10, second: nil)
            default:
                return Values(first: self.rawValue, second: nil)
            }
        }
    }

    // Properties of the BlackjackCard
    let rank: Rank
    let suit: Suit

    /// A computed property to provide a descriptive string of the card.
    var description: String {
        var output = "suit is \(suit.rawValue),"
        output += " value is \(rank.values.first)"
        if let second = rank.values.second {
            output += " or \(second)"
        }
        return output
    }
}

let theAceOfSpades = BlackjackCard(rank: .ace, suit: .spades)
print("theAceOfSpades: \(theAceOfSpades.description)")

let heartsSymbol = BlackjackCard.Suit.hearts.rawValue
print("Hearts Symbol: \(heartsSymbol)")
// Expected Output: "Hearts Symbol: ♡"

let tenOfDiamonds = BlackjackCard(rank: .ten, suit: .diamonds)
print("Ten of Diamonds: \(tenOfDiamonds.description)")
// Expected Output: "Ten of Diamonds: suit is ♢, value is 10"

let kingOfClubs = BlackjackCard(rank: .king, suit: .clubs)
print("King of Clubs: \(kingOfClubs.description)")
// Expected Output: "King of Clubs: suit is ♣, value is 10"
