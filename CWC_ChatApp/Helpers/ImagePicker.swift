//
//  ImagePicker.swift
//  CWC_ChatApp
//
//  Created by Juan Lebrija on 06/02/24.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable{
    @Binding var selectedImage : UIImage?
    @Binding var isPickerShowing : Bool
    
    var source: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source //will be deprecated
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
    func makeCoordinator() -> Coordinator{
        return Coordinator(self)
    }
}
class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var parent : ImagePicker
    
    init(_ picker : ImagePicker){
        self.parent = picker
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //run code when user has selected image
        print("image selected")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            //get image
            DispatchQueue.main.async {
                self.parent.selectedImage = image
            }
        }
        //dismiss picker
        parent.isPickerShowing = false
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled")
        parent.isPickerShowing = false
    }
}
