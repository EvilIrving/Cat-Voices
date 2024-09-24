//
//  CustomSlider.swift
//  CatVoices
//
//  Created by Actor on 2024/9/18.
//

import SwiftUI
import UIKit

struct CustomSlider: UIViewRepresentable {
    @Binding var value: Double

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = Float(value)
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }

    class Coordinator: NSObject {
        var parent: CustomSlider

        init(_ parent: CustomSlider) {
            self.parent = parent
        }

        @objc func valueChanged(sender: UISlider) {
            parent.value = Double(sender.value)
        }
    }
}
