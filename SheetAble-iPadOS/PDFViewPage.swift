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
    @State private var currentPage: Int = 0
    
    let pdfURL = URL(string: "https://www.sldttc.org/allpdf/21583473018.pdf")!
    
    var body: some View {
            VStack {
                if isLoading {
                    ProgressView("Loading PDF...")
                        .progressViewStyle(CircularProgressViewStyle())
                } else if let pdfDocument = pdfDocument {
                    VStack {
                                        // Navigation buttons for moving between pages
                                        HStack {
                                            Button(action: previousPage) {
                                                Text("Previous")
                                            }
                                            .disabled(currentPage == 0) // Disable if on the first page
                                            
                                            Spacer()
                                            
                                            Button(action: nextPage) {
                                                Text("Next")
                                            }
                                            .disabled(currentPage >= (pdfDocument.pageCount - 1)) // Disable if on the last page
                                        }
                                        .padding()
                                        
                                        PDFKitView(pdfDocument: pdfDocument, currentPage: $currentPage)
                                            .edgesIgnoringSafeArea(.all) // Makes the PDF full screen
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
            }
        }
        
        func nextPage() {
            if let pdfDocument = pdfDocument, currentPage < pdfDocument.pageCount - 1 {
                currentPage += 1
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
