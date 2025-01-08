//
//  CombinationView.swift
//  SheetAble-iPadOS
//
//  Created by Valentin Zwerschke on 11.09.24.
//

import SwiftUI
import PDFKit
import PencilKit


struct CombinationView: View {
    @State private var pdfDocument: PDFDocument? = nil
    @State private var isLoading: Bool = true
    @State private var currentPage: Int = 0
    @State private var canvasView: PKCanvasView = PKCanvasView()
    @State private var zoomScale: CGFloat = 1.0 // Add zoom scale state

    private let toolPicker = PKToolPicker() // Manage tool picker at this level

    let pdfURL = URL(string: "https://www.sldttc.org/allpdf/21583473018.pdf")!
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Loading PDF...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let pdfDocument = pdfDocument {
                VStack {
                    HStack {
                        Button(action: previousPage) {
                            Text("Previous")
                        }
                        .disabled(currentPage == 0)
                        
                        Spacer()
                        
                        Button(action: nextPage) {
                            Text("Next")
                        }
                        .disabled(currentPage >= (pdfDocument.pageCount - 1))
                    }
                    .padding()

                    ZStack {
                        // PDF View with zoomScale binding
                        PDFKitView(pdfDocument: pdfDocument, currentPage: $currentPage, zoomScale: $zoomScale)
                        
                        // Canvas View with Scroll for Zoom and ToolPicker
                        CanvasView(canvasView: $canvasView, toolPicker: toolPicker)
                    }
                }
            } else {
                Text("Failed to load PDF.")
            }
        }
        .onAppear {
            downloadPDF(from: pdfURL)
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            currentPage -= 1
            updateCanvas()
        }
    }
    
    func nextPage() {
        if let pdfDocument = pdfDocument, currentPage < pdfDocument.pageCount - 1 {
            currentPage += 1
            updateCanvas()
        }
    }
    
    func updateCanvas() {
        canvasView.drawing = PKDrawing() // Reset the canvas content for new pages
    }
    
    func downloadPDF(from url: URL) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let document = PDFDocument(data: data) {
                DispatchQueue.main.async {
                    self.pdfDocument = document
                    self.isLoading = false
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                print("Failed to load PDF: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
}
