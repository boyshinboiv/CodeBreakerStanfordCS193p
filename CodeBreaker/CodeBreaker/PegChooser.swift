//
//  PegChooser.swift
//  CodeBreaker
//
//  Created by Moultrie-Brown on 8/18/26.
//

import SwiftUI

struct PegChooser: View {
    //MARK: Data In
    let choices: [Peg]
    let onChoose: ((Peg) -> Void)?
    
    // MARK: - Body
    var body: some View {
            HStack {
                ForEach(choices, id: \.self) { peg in
                    Button {
                        onChoose?(peg)
                    } label: {
                        PegView(peg: peg)
                    }
                }
            }
    }
}

//#Preview {
//    PegChooser()
//}
