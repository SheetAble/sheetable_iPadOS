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
    /// Coordinator class to manage interactions between UIKit and SwiftUI.
    class Coordinator: NSObject {
        var canvasView: PKCanvasView
        var toolPicker: PKToolPicker?

        init(canvasView: PKCanvasView) {
            self.canvasView = canvasView
        }
    }

    func makeCoordinator() -> Coordinator {
        let canvasView = PKCanvasView()
        return Coordinator(canvasView: canvasView)
    }

    
    /// Creates and configures the PKCanvasView and PKToolPicker.
    /// This method is called when the SwiftUI view is created.
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.backgroundColor = .clear

        // Create a new tool picker instance
        let toolPicker = PKToolPicker()
        toolPicker.setVisible(true, forFirstResponder: canvasView) // Make the tool picker visible
        toolPicker.addObserver(canvasView) // Add the canvas view as an observer for the tool picker

        DispatchQueue.main.async {
            canvasView.becomeFirstResponder() // Ensure the canvas view becomes the first responder
        }

        // Store the tool picker in the coordinator for further updates
        context.coordinator.toolPicker = toolPicker
        
        return canvasView
    }
    
    /// Updates the PKCanvasView when SwiftUI state changes.
    /// This method is called whenever SwiftUI determines the view needs to be updated.
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
            if let toolPicker = context.coordinator.toolPicker {
                toolPicker.setVisible(true, forFirstResponder: uiView)
                uiView.becomeFirstResponder() // Ensure the canvas stays first responder when updated
            }
        }

}
