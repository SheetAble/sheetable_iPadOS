//
//  CanvasViewRepresentable.swift
//  SheetAble-iPadOS
//
//  Created by Valentin Zwerschke on 04.09.24.
//

import SwiftUI
import PencilKit

/// A SwiftUI view wrapper for PKCanvasView, which integrates PencilKit's drawing capabilities.
struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    let toolPicker: PKToolPicker // Pass the tool picker from the parent view

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 5.0

        // Setup PKCanvasView
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 1)
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.drawingPolicy = .anyInput

        // Add the canvas view to the scroll view
        scrollView.addSubview(canvasView)
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            canvasView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            canvasView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            canvasView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            canvasView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])

        // Attach the tool picker
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        DispatchQueue.main.async {
            canvasView.becomeFirstResponder()
        }

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // No need to apply transforms to the canvas itself; scrollView handles zoom
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: CanvasView

        init(_ parent: CanvasView) {
            self.parent = parent
        }

        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return parent.canvasView // No need for 'self' here, it's not inside a closure
        }

        func scrollViewDidZoom(_ scrollView: UIScrollView) {
            // Ensure the tool picker remains active after zooming
            if let window = parent.canvasView.window,
               let toolPicker = PKToolPicker.shared(for: window) {
                toolPicker.setVisible(true, forFirstResponder: parent.canvasView)
                
                // Explicitly using 'self' here because it's inside a closure
                DispatchQueue.main.async {
                    self.parent.canvasView.becomeFirstResponder() // 'self' is required here
                }
            }
        }
    }
}
