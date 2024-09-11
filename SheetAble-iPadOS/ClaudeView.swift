//
//  ClaudeView.swift
//  SheetAble-iPadOS
//
//  Created by Valentin Zwerschke on 04.09.24.
//

import SwiftUI
import PencilKit
import PDFKit


struct ClaudeView: View {
    @State private var canvasView = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    @State private var pdfView = PDFView()
    @State private var pdfDocument: PDFDocument?

    var body: some View {
        ZStack {
            // PDF View
            PDFViewWrapper(pdfDocument: $pdfDocument)
                .edgesIgnoringSafeArea(.all)

            // PencilKit Canvas
            PencilKitCanvasView(canvasView: $canvasView, toolPicker: $toolPicker)
                .edgesIgnoringSafeArea(.all)

            // PencilKit Tool Picker
            if let window = UIApplication.shared.keyWindow {
                PKToolbar(toolPicker: $toolPicker, window: window)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.001)) // Transparent background to capture touches
            }
        }
        .onAppear {
            loadPDF(from: "http://192.168.0.198:8080/data/uuid_1.pdf")
        }
    }

    func loadPDF(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        pdfDocument = PDFDocument(url: url)
    }
}

struct PDFViewWrapper: UIViewRepresentable {
    @Binding var pdfDocument: PDFDocument?

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
    }
}

struct PencilKitCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var toolPicker: PKToolPicker

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput
        return canvasView
    }

    func updateUIView(_ view: PKCanvasView, context: Context) {
        view.tool = toolPicker.selectedTool
    }
}

struct PKToolbar: UIViewControllerRepresentable {
    @Binding var toolPicker: PKToolPicker
    let window: UIWindow

    func makeUIViewController(context: Context) -> PKToolbarViewController {
        let viewController = PKToolbarViewController(toolPicker: toolPicker)
        viewController.toolPicker.addObserver(window as! PKToolPickerObserver)
        return viewController
    }

    func updateUIViewController(_ viewController: PKToolbarViewController, context: Context) {
        self.viewController.toolPicker = toolPicker
    }
}

// PKToolbarViewController is a custom view controller that displays the PencilKit toolbar
class PKToolbarViewController: UIViewController {
    let toolPicker: PKToolPicker

    init(toolPicker: PKToolPicker) {
        self.toolPicker = toolPicker
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = toolPicker.toolbar
    }
}
