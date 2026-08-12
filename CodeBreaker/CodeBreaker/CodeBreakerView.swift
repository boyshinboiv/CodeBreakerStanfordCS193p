//
//  CodeBreakerView.swift
//  CodeBreaker
//
//  Created by Moultrie-Brown on 7/15/26.
//

import SwiftUI // This is required for all UI to work
struct CodeBreakerView: View { // This is our whole UI. It is contained in this struct
    @State var game = CodeBreaker(pegChoices: [.gray, .black, .teal, .orange]) // Import the model that runs all our code. MUST have the @State signifier to show the compiler that this variable must be mutable. Since all Views are, by definition, immutable, the @State tag tells the compiler to store this variable in the heap using references instead of directly like the other View structs.
    var body: some View { // All view structs must have this variable in them
        VStack { // a vertical View stack
            view(for: game.masterCode) // "view" is a horribly named function defined below that returns a view depicting a "Code" which is a 4-peg sequence. Here, we call it to say "display the master code!"
            ScrollView { // a view stack that scrolls
                view(for: game.guess) // Hey "view" function, show us the current guess!
                ForEach(game.attempts.indices.reversed(), id: \.self) { index in
                    view(for: game.attempts[index]) // Show us all the previous attempts!
                }
            }
            
        }
        .padding() // padding so it doesn't look like shit.
    }
    
    var guessButton: some View { // Guess button view that will be called later
        Button("Guess") { // Button view which must have text and then code to run on click
            withAnimation { // insane fucking view builder thing that just auto animates whatevers inside
                game.attemptGuess() // this is a function in the model CodeBreaker
            }
        }
        .font(.system(size: 80)) // A few view modifers to make things easier
        .minimumScaleFactor(0.1)
    }
    func view(for code: Code) -> some View { //Takes in a code (meaning a sequence of pegs with some category) and returns a View of the pegs in question
        HStack {
            ForEach(code.pegs.indices, id: \.self) { index in // Iterates through an array of indices representing the pegs, "index" is the stock iterator variable that gets passed in to the following code using closure notation
                RoundedRectangle(cornerRadius: 10) // hey draw a rectangle on the screen
                    .overlay { // on top of the rectangle, draw this shit
                        if code.pegs[index] == Code.missingPeg { // if there is no peg, draw an outline to show there is no peg color chosen yet
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color.gray)
                        }
                    }
                    .contentShape(Rectangle()) // hey its a rectangle
                    .aspectRatio(1,contentMode: .fit) // make it 1x1 and make it fit to the space allocated rather than use it all
                    .foregroundStyle(code.pegs[index]) // pegs are just colors so this sets the foregroundStyle to whatever color we chose
                    .onTapGesture { // View modifier that triggers when you tap the View
                        if code.kind == .guess { // If the code we're clicking on is our guess, the let us change the peg by cycling through colors
                            game.changeGuessPeg(at: index)
                        }
                    }
            }
            Rectangle() // This is the guess button or the black and white match pegs
                .foregroundStyle(.clear)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    if let matches = code.matches { // If the matches exists for the code in question draw the black and white pegs
                        MatchMarkers(matches: matches)
                    }
                    else {
                        if code.kind == .guess { // If the matches don't exist it's either a master code or a current guess so draw the guess button next to the current guess
                            guessButton
                        }
                    }
                }
                }
            
        }
    }
#Preview { // show me now
    CodeBreakerView()
}

