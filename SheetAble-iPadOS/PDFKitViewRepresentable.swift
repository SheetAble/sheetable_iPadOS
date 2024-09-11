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

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true // Automatically scale PDF to fit the view
        pdfView.displayMode = .singlePage // Optional: shows one page at a time
        pdfView.displayDirection = .horizontal // Optional: horizontal page swipe
        pdfView.document = pdfDocument
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = pdfDocument
    }
}
