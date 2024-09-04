//
//  SheetView.swift
//  SheetAble Client
//
//  Created by Valentin Zwerschke on 11.06.24.
//

import SwiftUI

struct SheetView: View {
    let sheet: Sheet
    var pdfURL: URL? {
        Bundle.main.url(forResource: "example", withExtension: "pdf")
    }

    
    var body: some View {
           VStack {
               Text("Hello Sheet: \(sheet.name)")
           }
           .padding()
       }
}

#Preview {
    SheetView(sheet: Sheet(name: "Bachi", age: 100))
}
