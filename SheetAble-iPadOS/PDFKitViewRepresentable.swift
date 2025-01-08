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
    @Binding var zoomScale: CGFloat // Add a zoomScale binding

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.displaysAsBook = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = pdfDocument
        
        if let pdfDocument = pdfDocument, currentPage < pdfDocument.pageCount {
            if let page = pdfDocument.page(at: currentPage) {
                uiView.go(to: page)
            }
        }

        // Set zoom scale based on the binding
        uiView.scaleFactor = zoomScale
    }
}
