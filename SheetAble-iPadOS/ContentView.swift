import SwiftUI
import PDFKit
import PencilKit

struct ContentView: View {
    @State private var pdfDocument: PDFDocument?

    var body: some View {
        VStack {
            if let document = pdfDocument {
                PDFViewWrapper(pdfDocument: document)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Loading PDF...")
            }
        }
        .onAppear {
            loadPDF()
        }
    }
    
    func loadPDF() {
        guard let url = URL(string: "http://192.168.178.87:8080/data/uuid_1.pdf") else {
            print("Invalid URL")
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if let document = PDFDocument(url: url) {
                DispatchQueue.main.async {
                    self.pdfDocument = document
                }
            } else {
                print("Failed to load PDF")
            }
        }
    }
}

struct PDFViewWrapper: UIViewRepresentable {
    let pdfDocument: PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayDirection = .horizontal
        pdfView.displayMode = .singlePage
        pdfView.document = pdfDocument
        
        // Enable PencilKit drawing
        let canvasView = PKCanvasView(frame: pdfView.bounds)
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 5)
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.drawingPolicy = .anyInput
        
        pdfView.addSubview(canvasView)
        context.coordinator.canvasView = canvasView
        
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        context.coordinator.updateCanvas(for: uiView)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: PDFViewWrapper
        var canvasView: PKCanvasView?
        private var currentPageIndex: Int = 0
        
        init(_ parent: PDFViewWrapper) {
            self.parent = parent
            super.init()
        }
        
        func updateCanvas(for pdfView: PDFView) {
            guard let page = pdfView.currentPage else { return }
            
            // Adjust the canvas view to match the PDF page size and position
            let pageBounds = pdfView.convert(page.bounds(for: .mediaBox), from: page)
            canvasView?.frame = pageBounds
            
            if currentPageIndex != pdfView.document?.index(for: page) {
                currentPageIndex = pdfView.document?.index(for: page) ?? 0
                
                // Load any existing drawings for this page
                if let drawingData = page.annotation(for: "PencilDrawing")?.contents,
                   let drawing = try? PKDrawing(data: drawingData.data(using: .utf8) ?? Data()) {
                    canvasView?.drawing = drawing
                } else {
                    canvasView?.drawing = PKDrawing()
                }
            }
        }
        
        func saveDrawing(for page: PDFPage) {
            guard let drawing = canvasView?.drawing else { return }
            let drawingData = drawing.dataRepresentation()
            
            // Save the drawing as an annotation on the PDF page
            if let annotation = page.annotation(for: "PencilDrawing") {
                annotation.contents = String(data: drawingData, encoding: .utf8)
            } else {
                let annotation = PDFAnnotation(bounds: page.bounds(for: .mediaBox), forType: .widget, withProperties: nil)
                annotation.widgetFieldType = .text
                annotation.contents = String(data: drawingData, encoding: .utf8)
                annotation.fieldName = "PencilDrawing"
                page.addAnnotation(annotation)
            }
        }
    }
}

extension PDFPage {
    func annotation(for fieldName: String) -> PDFAnnotation? {
        return annotations.first { $0.fieldName == fieldName }
    }
}

#Preview {
    ContentView()
}
