//
//  CodeView.swift
//  CodeBreaker
//
//  Created by Moultrie-Brown on 8/18/26.
//

import SwiftUI

struct CodeView: View {
    //MARK: Data In
    let code: Code
    
    //MARK: Data Owned by Others
    @Binding var selection: Int
    
    
    //MARK: - Body
    var body: some View {
        ForEach(code.pegs.indices, id: \.self) { index in
            PegView(peg: code.pegs[index])
                .padding(Selection.border)
                .background {
                    if selection == index, code.kind == .guess {
                        Selection.shape
                            .foregroundStyle(Color.gray(0.85))
                    }
                }
                .overlay {
                    Selection.shape.foregroundStyle(code.isHidden ? Color.gray : .clear)
                }
                .onTapGesture {
                    if code.kind == .guess {
                        selection = index
                    }
                }
        }
    }
}
//#Preview {
//    CodeView()
//}
