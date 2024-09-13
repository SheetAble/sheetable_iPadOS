//
//  CombinationView.swift
//  SheetAble-iPadOS
//
//  Created by Valentin Zwerschke on 11.09.24.
//

import SwiftUI

struct CombinationView: View {
    var body: some View {
        ZStack {
            PDFViewPage()   

            DrawView().zIndex(1)


        }
    }
}

#Preview {
    CombinationView()
}
