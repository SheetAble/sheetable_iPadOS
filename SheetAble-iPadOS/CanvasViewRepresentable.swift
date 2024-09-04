//
//  CanvasViewRepresentable.swift
//  SheetAble-iPadOS
//
//  Created by Valentin Zwerschke on 04.09.24.
//

import SwiftUI
import PencilKit

/// This is needed to use PencilKit (a UIkit class) inside of SwiftUI
struct CanvasView: UIViewRepresentable {
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
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.backgroundColor = .white
        
        // Setup tool picker
        let toolPicker = PKToolPicker()
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        
        // Make canvas view the first responder so the tool picker is shown
        canvasView.becomeFirstResponder()
        
        // Set the toolPicker to the coordinator for later updates
        context.coordinator.toolPicker = toolPicker
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Here you might handle updates if your view's state changes
    }
}
