//
//  MatchMarkers.swift
//  CodeBreaker
//
//  Created by Moultrie-Brown on 7/24/26.
//

import SwiftUI
enum Match {
    case nonmatch
    case exact
    case inexact
}

struct MatchMarkers: View {
    var matches: [Match] // Creates an array of type Match, which is defined above. Interestingly, since all Swift variables must be initialized to a value, anytime MatchMarkers is called, you have to pass in a "matches" array to initialize it. Despite it not having standard func(parameter) syntax, "matches" is a parameter that needs an argument passed into it when calling MatchMarkers (probably because it's not a function! It's a struct View).
    var body: some View {
        HStack{
            VStack{
                matchMarker(peg: 0)
                matchMarker(peg: 1)
            }
            VStack{
                matchMarker(peg: 2)
                matchMarker(peg: 3)
            }
        }
    }
    // The function below is a way to draw the match markers in CodeBreakerView. The pin number is passed in and is compared to the number of exact and inexact matches in the total 4-color code passed in to the MatchMarkers struct. What this does is count the number of exact matches and then if the peg in question is below that number, we know we haven't drawn all of the exact pegs yet and need to draw one more. Once the exact count is below the current peg number, we know we made all the exact pegs and need to draw inexact pegs. Once that is done and there are still pegs left, we draw them clear.
    func matchMarker(peg: Int) -> some View {
        /* Okay so the two definitions below are extremely fucked and really hard to understand on their own. We're going to make a step-by-step guide on how we got here.
         
         We start with a different definition
         
         let exactCount: Int = matches.count(where: isExact)
         
         func isExact(match: Match) -> Bool {
            return match == Match.exact
         }
         
         This definition is a lot simpler. ".count" is a function that can be called from any collection, in this case an array of type Match. In this case, we want to count how many of the Match variables in the array are of type Match.exact. ".count" is a function that takes one argument: another function that takes in the same type (Match) and returns a boolean. .count will use this function to determine what gets counted and what gets skipped. In this case, we wrote a function to check if something is exact, and the .count function will run that for each thing in the array to count how many instances of Match.exact there are.
         
         There are a few simplifications we can make here already.
         
         let exactCount = matches.count(where: isExact)
         
         func isExact(match: Match) -> Bool {
            match == .exact
         }
         
         All we did here was remove certain keywords that the compiler and the programmer can infer or assume. Since we know we're counting things, we know exactCount will be an integer, so we don't need to explicitly say it. Since we know "match" is of the type Match, we don't need to make it obvious that the thing we're comparing it to is of type Match as well, .exact will do. Finally, since the function is only one line, it is inferred that there is the word "return" in front of it so we can delete it. Stay with me now.
         
         Now we can turn this function into an inline function instead of declaring it outside of it.
         
         let exactCount = matches.count(where: { (match: Match) -> Bool in
            match == .exact
         })
         
         What we have done is take the "isExact" and replace the function call in .count with the function itself. In inline notation, the arguments also go inside the curly braces and are seperated from the code of the function using the keyword "in". It is to say, the curly braces are the function, everything before "in" is arguments and return type, and everythin after "in" is code. These arguments IN this code, you see. This would be good enough, however, functional programming languages are insane and made to torment you.
         
         We will now decompose it even further
         
         let exactCount = matches.count (where: {match in match == .exact})
         
         Now, we have removed all of the type information from the argument portion of the inline function. We do this because Swift infers the types of both the arguments and the return type because the ".count" function can't take in anything else. The .count function MUST take in one argument of the matching type from the array and it MUST return a boolean. Swift knows this and allows us to remove those identifiers because it is inferred that the argument will be a "Match" and the return type will be a Bool because that is the only way .count operates. So now, in our inline function, we have just the argument "match" which is used to name the array item we are passing into the function code for comparison. Again, we have the keyword "in" to seperate the arguments and code.
         
         We're almost done.
         
         let exactCount = matches.count (where: {$0 == .exact})
         
         In this new iteration of the function, the named argument "match" has been removed, and instead, we have "$0". The $ operator is used to denote an argument. Because ".count" only has one argument, and both the compiler and the programmer know that it will ALWAYS have one argument, we do not even have to name it. Instead, any time we need to reference what would be the "match" variable in the code, we can just use $0 to denote "the first argument." If we had others, we would use $1, $2, etc.
         
         One more step.
         
         let exactCount = matches.count {$0 == exact}
         
         Since we have only one argument/piece of the .count function left, we can use what is called "trailing closure notation" and just straight up removed the parentheses and just have the curly braces. We do this with VStack all the time, where the only argument left is the content, and so we replace (content: {code}) with {code}.
         We are now done.
        */
        let exactCount = matches.count {$0 == .exact}
        let foundCount = matches.count {$0 != .nonmatch}
        return Circle()
            .fill(exactCount > peg ? Color.primary : Color.clear)
            .strokeBorder(foundCount > peg ? Color.primary : Color.clear, lineWidth: 2)
            .aspectRatio(1,contentMode: .fit)
    }
}

#Preview {
    MatchMarkers(matches: [.exact,.inexact,.exact,.inexact])
}
