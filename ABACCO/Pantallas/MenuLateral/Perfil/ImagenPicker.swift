//
//  SwiftUIView.swift
//  ABACCO
//
//  Created by Jaime Jimenez sanchez on 20/5/25.
//

import Foundation
import SwiftUI

struct ImagenPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation //permitimos poder cerrar la vista al seleccionar
    @Binding var image: UIImage? //recibimos una imagen
    
    func makeCoordinator() -> Coordinator {
        return ImagenPicker.Coordinator(img: self)
    }
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagenPicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagenPicker>) {
        //
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        var img: ImagenPicker
        
        init(img: ImagenPicker) {
            self.img = img
        }
        
        //función que cierra la seleccion
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            //
            self.img.presentation.wrappedValue.dismiss()
        }
        
        //asignamos la imagen al biding
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                img.image = uiImage
            }
            self.img.presentation.wrappedValue.dismiss()
        }
    }
    
}


