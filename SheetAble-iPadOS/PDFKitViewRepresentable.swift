//
//  PDFKitViewRepresentable.swift
//  SheetAble-iPadOS
//
//  Created by Valentin Zwerschke on 11.09.24.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let pdfDocument: PDFDocument?
    @Binding var currentPage: Int


    func makeUIView(context: Context) -> PDFView {
            let pdfView = PDFView()
            pdfView.autoScales = true
            pdfView.displayMode = .singlePage // Show one page at a time
            pdfView.displayDirection = .horizontal // Optional: horizontal page swipe
            pdfView.displaysAsBook = true // Makes the pages look like a book when swiping
            
            // TODO: remove this?
            pdfView.isUserInteractionEnabled = false

            return pdfView
        }

  
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = pdfDocument
        
        // Display the current page
        if let pdfDocument = pdfDocument, currentPage < pdfDocument.pageCount {
            let page = pdfDocument.page(at: currentPage)
            uiView.go(to: page!)
        }
    }
}
