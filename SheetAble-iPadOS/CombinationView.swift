//
//  CombinationView.swift
//  SheetAble-iPadOS
//
//  Created by Valentin Zwerschke on 11.09.24.
//

import SwiftUI
import PDFKit
import PencilKit

//struct CombinationView: View {
//    var body: some View {
//        ZStack {
//            PDFViewPage()   
//
//            DrawView().zIndex(1)
//
//        }
//    }
//}
//
//#Preview {
//    CombinationView()
//}

struct CombinationView: View {
    @State private var pdfDocument: PDFDocument? = nil
    @State private var isLoading: Bool = true
    @State private var currentPage: Int = 0
    @State private var canvasView: PKCanvasView = PKCanvasView()
    
    // Manage the tool picker at this level
    private let toolPicker = PKToolPicker()

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
                        PDFKitView(pdfDocument: pdfDocument, currentPage: $currentPage)
                        CanvasView(canvasView: $canvasView)
                            .onAppear {
                                attachToolPicker()
                            }
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
        canvasView.drawing = PKDrawing()
        attachToolPicker() // Reattach the tool picker each time
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
    
    // Attach tool picker to the canvas view
    func attachToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        DispatchQueue.main.async {
            canvasView.becomeFirstResponder()
        }
    }
}

