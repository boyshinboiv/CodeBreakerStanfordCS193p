//
//  CodeBreaker.swift
//  CodeBreaker
//
//  Created by Moultrie-Brown on 8/4/26.
//

import SwiftUI

typealias Peg = Color

struct CodeBreaker {
    // MARK: Data In
    var masterCode: Code = Code(kind: .master(isHidden: true))
    var guess: Code = Code(kind: . guess)
    var attempts: [Code] = [Code]()
    let pegChoices: [Peg]
    
    // MARK: Init
    init(pegChoices: [Peg] = [.red, .green, .yellow, .blue]) {
        self.pegChoices = pegChoices
        masterCode.randomize(from: pegChoices)
        print(masterCode)
    }
    
    var isOver: Bool {
        attempts.last?.pegs == masterCode.pegs
    }
    
    mutating func attemptGuess() {
        var attempt = guess
        attempt.kind = .attempt(guess.match(against: masterCode))
        attempts.append(attempt)
        guess.reset()
        if isOver {
            masterCode.kind = .master(isHidden: false)
        }
    }
    
    mutating func setGuessPeg(_ peg: Peg, at index: Int) {
        guard guess.pegs.indices.contains(index) else { return }
        guess.pegs[index] = peg
    }
    
    mutating func changeGuessPeg(at index: Int) {
        let existingPeg = guess.pegs[index]
        if let indexOfExistingPegInPegChoicesArray = pegChoices.firstIndex(of: existingPeg) {
            let newPeg = pegChoices[(indexOfExistingPegInPegChoicesArray + 1) % pegChoices.count]
            guess.pegs[index] = newPeg
        }
        else {
            guess.pegs[index] = pegChoices.first ?? Code.missingPeg
        }
    }
}
