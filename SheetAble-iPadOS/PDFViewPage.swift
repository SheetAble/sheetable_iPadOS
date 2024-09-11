//
//  PDFViewPage.swift
//  SheetAble-iPadOS
//
//  Created by Valentin Zwerschke on 11.09.24.
//

import SwiftUI
import PDFKit

struct PDFViewPage: View {
    @State private var pdfDocument: PDFDocument? = nil
    @State private var isLoading: Bool = true
    let pdfURL = URL(string: "https://pdfobject.com/pdf/sample.pdf")! //Your PDF URL

    
    
    var body: some View {
            VStack {
                if isLoading {
                    ProgressView("Loading PDF...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let pdfDocument = pdfDocument {
                    PDFKitView(pdfDocument: pdfDocument)
                        .edgesIgnoringSafeArea(.all) // Makes the PDF full screen
                } else {
                    Text("Failed to load PDF.")
                }
            }
            .onAppear {
                downloadPDF(from: pdfURL)
            }
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

#Preview {
    PDFViewPage()
}
