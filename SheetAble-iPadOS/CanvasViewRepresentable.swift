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
        
        init(canvasView: PKCanvasView) {
            self.canvasView = canvasView
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(canvasView: PKCanvasView())
    }

    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        let toolPicker = PKToolPicker()
        
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
        
        canvasView.backgroundColor = .lightGray
        
        canvasView.becomeFirstResponder()
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Update the canvasView if needed based on SwiftUI state changes
    }

    // You can add methods here to handle actions or state changes if necessary
}
