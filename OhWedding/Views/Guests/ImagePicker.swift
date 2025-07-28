//
//  ImagePicker.swift
//  OhWedding
//
//  Created by Buikliskii Vladimir on 28.07.2025.
//

import SwiftUI
import PhotosUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    enum Source {
        case camera, photoLibrary
    }

    @Environment(\.presentationMode) var presentationMode
    var source: Source
    var onImagePicked: (UIImage) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        switch source {
        case .camera:
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                return UIImagePickerController()
            }
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = context.coordinator
            return picker

        case .photoLibrary:
            var config = PHPickerConfiguration()
            config.filter = .images
            config.selectionLimit = 1
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = context.coordinator
            return picker
        }
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PHPickerViewControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else {
                parent.presentationMode.wrappedValue.dismiss()
                return
            }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                if let uiImage = image as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.onImagePicked(uiImage)
                    }
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

