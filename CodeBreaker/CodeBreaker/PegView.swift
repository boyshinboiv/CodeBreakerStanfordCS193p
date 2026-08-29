//
//  PegView.swift
//  CodeBreaker
//
//  Created by Moultrie-Brown on 8/18/26.
//

import SwiftUI


struct PegView: View {
    // MARK: Data In
    let peg: Peg
    
    // MARK: - Body
    
    let pegShape = Circle()
    
    
    var body: some View {
        pegShape
            .overlay {
                if peg == Code.missingPeg {
                    pegShape
                }
            }
            .contentShape(pegShape)
            .aspectRatio(1,contentMode: .fit)
            .foregroundStyle(peg)
    }
}
    
#Preview {
    PegView(peg: .blue)
}
