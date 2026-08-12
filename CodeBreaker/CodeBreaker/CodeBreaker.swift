//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Moultrie-Brown on 8/4/26.
//

import SwiftUI

typealias Peg = Color // this is basically saying "we're gonna call Color variables Peg which I actually fucking hate and wish he didn't

struct CodeBreaker {
    var masterCode: Code = Code(kind: .master) // establish the master code as typee Code with category .master (why the fuck did he call it "kind" i hate it)
    var guess: Code = Code(kind: . guess) // establish the current guess code as type Code with category .guess
    var attempts: [Code] = [Code]() // establish the past attempts codes as an array of type [Code]
    let pegChoices: [Peg] // this is an incredibly shittily worded variable that holds all of the POSSIBLE COLORS that the pegs COULD be, not any specific choices of color the player made but what the developer passed in as the COLOR SCHEME of the game
    
    init(pegChoices: [Peg] = [.red, .green, .yellow, .blue]) { // Init the color scheme with default value
        self.pegChoices = pegChoices // same shit like java if you want the param and the actual var to be the same name you gotta so the self.thing = thing
        masterCode.randomize(from: pegChoices) // defined later
        print(masterCode) // debugging purposes, idk how you even see this
    }
    
    mutating func attemptGuess() { // This func has to be called mutating because it is literally changing one or more pieces of data in the model (in this case the attempts array)
        var attempt = guess // because guess is of type Code and Code is a struct type, the data is value based, meaning no pointers involved. this declaration COPIES guess into attempt and now attempt can be mutated for free
        attempt.kind = .attempt(guess.match(against: masterCode)) // turns attempt into category .attempt, but .attempt has associated data with it which is an array of Matches. a "Match" is an enum denoting whether a peg is an exact match with the master code, an inexact match, or a nonmatch
        attempts.append(attempt) // add the current guess to the attempt array
    }
    
    mutating func changeGuessPeg(at index: Int) { // again this is changing data so it must be mutating. this is how we cycle through colors on tap
        let existingPeg = guess.pegs[index] // Find the actual peg in the pegs array of the guess code
        if let indexOfExistingPegInPegChoicesArray = pegChoices.firstIndex(of: existingPeg) { // Find the index of that peg in the "all possible peg colors" global array called pegChoices
            let newPeg = pegChoices[(indexOfExistingPegInPegChoicesArray + 1) % pegChoices.count] // Indicate the next possible color
            guess.pegs[index] = newPeg // Set it to the new color
        }
        else { // if indexOfExistingPegInPegChoicesArray could not be found (meaning there was no peg visible there yet), then set the peg color to the first color in pegChoices
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg // Turn it to the first color if pegChoices has a first element and turn it "missing" if not
        }
    }
}

struct Code { // This is the struct for the type "Code" which represents a 4-color sequence of pegs
    var kind: Kind // again, insane name, but it means the type of code that it is, either master, current guess, or past attempt
    var pegs: [Peg] = Array(repeating: Code.missingPeg, count: 4) // again, pegs are colors, so this initializes all 4 peg colors as missing until created
    
    static let missingPeg: Peg = .clear // a missing peg will just be clear and we add the grey borders in the ui file
    
    enum Kind: Equatable{ // equatable is a something idfk what its called but it makes it so you can use == on the type Kind anywhere u want
        case master
        case guess
        case attempt([Match])
        case unknown
    }
    
    mutating func randomize(from pegChoices: [Peg]) { // changing something! use mutating
        for index in pegChoices.indices {
            pegs[index] = pegChoices.randomElement() ?? Code.missingPeg // for every peg in this specific code, pick a random one from the POSSIBLE CHOIES IN THE COLOR SCHEME or return missing if you couldn't find one. this is mostly to just prevent crashes. also this will only be used for the master code
        }
    }
    
    var matches: [Match]? { // returns a type optional cuz maybe your code doesn't need matches because only past attempt codes need matches. jesus christ why did he call it Code breaker when we're writing code so when you say the word code it could mean 4 different things. fuck i hate this guy
        switch kind { // switch on the variable kind which is of type Kind
            case .attempt(let matches): return matches // the "let" here just lets the code after the colon access the associated data of the case
            default: return nil // this basically moves the "matches" array from being attached to the kind variable to being attached to the Code itself.
        }
    }
    
    func match(against otherCode: Code) -> [Match] { // This is a function that is inside of the "Code" struct, and it takes in another code. It will be called like someCode.match(against: anotherCode). It will return an array of Matches, which are enums denoting if the peg is an exact black match or an inexact white match or neither.
        var pegsToMatch = otherCode.pegs // Create an array of all the pegs needing to be checked
        let backwardsExactMatches = pegs.indices.reversed().map { index in // Create a backwards array of all pegs that are an exact match to the master code. The "map" function is a type of function that takes in another function as an argument (which here is written inline using curly braces). The map function applies that function to each item in a collection and returns a new collection with every item undergoing that process. Mapping one collection onto another through a series of steps.
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] { // This checks if the amount of pegs left is greater than the index to prevent out of bounds errors, then it checks if a peg of the master code (which would be in pegsToMatch) matches with the caller's peg (which is in pegs[]) in that position.
                pegsToMatch.remove(at: index) // If yes, remove it from the pegs to match and return Match.exact, which is then added to the backwardsExactMatches array.
                return Match.exact
            }
            else {
                return .nonmatch // If it doesn't match, return nonmatch
            }
        }
        let exactMatches = Array(backwardsExactMatches.reversed()) // Now reverse the reversed array and typecast it as an array. When you reverse something, it doesn't actually become an array because it can just retrieve information from the base array in the reverse order. It is only when we type cast as an array that an actual new array is allocated in memory and the data copied in in the reverse order.
        return pegs.indices.map { index in // This will return our collection of matches using another map function.
            if exactMatches[index] != .exact,  let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) { // Checks if the peg in exact matches is NOT exact, then checks if the peg in the master code exists somewhere else in the caller's pegs, and if it does, we know it has found an inexact match
                pegsToMatch.remove(at: index)
                return .inexact
            }
            else {
                return exactMatches[index] // If nothing else, just return what is already there.
            }
        }
    }
    /* BELOW IS THE STANDARD PROGRAMMING WAY TO CHECK A GIVEN CODE FOR HOW MANY MATCHING PEGS THERE ARE. ABOVE, HOWEVER, IS THE SPECIAL FUNCTIONAL PROGRAMMING WAY TO DO THIS.
    func match(against otherCode: Code) -> [Match] { // In order, this function takes in another code to match the parent code against.
        var results: [Match] = Array(repeating: .nonmatch, count: pegs.count) // Creates a writeable results array of matches to output
        var pegsToMatch = otherCode.pegs // Creates a writeable array of the pegs that are left to check for matches
        for index in pegs.indices.reversed() { // Do a pass to check for all pegs that are an exact match (black) and remove them from the pegsToMatch array.
            if pegsToMatch.count > index, pegsToMatch[index] == pegs[index] {
                results[index] = .exact
                pegsToMatch.remove(at: index)
            }
        }
        for index in pegs.indices { // Do a pass to check for all pegs that are an inexact match (white) and remove them from the pegsToMatch array
            if results[index] != .exact {
                if let matchIndex = pegsToMatch.firstIndex(of: pegs[index]) {
                    results[index] = .inexact
                    pegsToMatch.remove(at: matchIndex)
                }
            }
        }
        return results // return the results array (e.g. [.nonmatch, .exact, .inexact, .exact])
    } */
    
}
