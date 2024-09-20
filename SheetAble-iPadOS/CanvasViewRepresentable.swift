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
    
    func makeUIView(context: Context) -> PKCanvasView {
        // Initialize the tool and tool picker
        let canvas = canvasView
        canvas.tool = PKInkingTool(.pen, color: .black, width: 1)
        canvas.backgroundColor = .clear
        canvas.isOpaque = false
        
        let toolPicker = PKToolPicker()
        toolPicker.setVisible(true, forFirstResponder: canvas)
        toolPicker.addObserver(canvas)
        
        DispatchQueue.main.async {
            canvas.becomeFirstResponder()
        }
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Ensure the tool picker remains visible
        if let window = uiView.window,
           let toolPicker = PKToolPicker.shared(for: window) {
            toolPicker.setVisible(true, forFirstResponder: uiView)
            toolPicker.addObserver(uiView)
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
        }
    }
}
