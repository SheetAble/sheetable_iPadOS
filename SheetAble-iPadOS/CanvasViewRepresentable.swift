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

        /// Initializes the Coordinator with a PKCanvasView instance.
        init(canvasView: PKCanvasView) {
            self.canvasView = canvasView
        }
    }
    
    /// Creates a Coordinator instance for managing interactions.
    func makeCoordinator() -> Coordinator {
        let canvasView = PKCanvasView() // Create a new PKCanvasView
        return Coordinator(canvasView: canvasView) // Return a Coordinator initialized with this canvas view
    }
    
    /// Creates and configures the PKCanvasView and PKToolPicker.
    /// This method is called when the SwiftUI view is created.
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView() // Create a new PKCanvasView instance
        canvasView.backgroundColor = .white // Set the background color of the canvas view

        // Create a PKToolPicker instance
        let toolPicker = PKToolPicker()
        // Initially hide the tool picker; it will be shown later in a compact form
        toolPicker.setVisible(false, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView) // Add the canvas view as an observer to the tool picker
        
        // Make the canvas view the first responder so the tool picker can appear
        canvasView.becomeFirstResponder()
        
        // Ensure the tool picker appears in its compact form after a short delay
        // This allows the canvas view to become the first responder before showing the tool picker
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            toolPicker.setVisible(true, forFirstResponder: canvasView) // Make the tool picker visible
        }
        
        // Set the toolPicker to the coordinator for later use (if needed)
        context.coordinator.toolPicker = toolPicker
        
        return canvasView // Return the configured canvas view
    }
    
    /// Updates the PKCanvasView when SwiftUI state changes.
    /// This method is called whenever SwiftUI determines the view needs to be updated.
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // No updates are needed in this example, but you can handle updates if the view's state changes
    }
}
