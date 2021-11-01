//
//  inputphoto.swift
//  PrivateLibrary
//
//  Created by 강희영 on 2021/11/01.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseStorage
struct ImagePicker: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
    UIGraphicsBeginImageContextWithOptions(targetSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
}


func upload_Image(image:UIImage){
    let image : UIImage = resizeImage(image: image, targetSize: CGSize(width: 512, height: 512))
    if let imageData = image.jpegData(compressionQuality: 1){
        let storage = Storage.storage()
        storage.reference().child("temp").putData(imageData, metadata: nil){
            (_, err) in
            if let err = err {
                print("an error has occurred - \(err.localizedDescription)")
            } else {
                print("image uploaded successfully")
            }
        }
    } else {
        print("coldn't unwrap/case image to data")
    }
}

//func download_Image(image:UIImage){
//    Storage.storage().reference().child("temp").getData(maxSize: 1 * 512 * 512) {
//        (imageData, err) in
//        if let err = err {
//            print("an error has occurred - \(err.localizedDescription)")
//        } else {
//            if let imageData = imageData {
//                image = UIImage(data: imageData)
//            } else {
//                print("an error has occurred")
//            }
//        }
//    }
//}


struct inputphoto: View {
    
    @State private var isShowPhotoLibrary = false
    @State private var uploadImage : UIImage?
    @State private var downloadImage : UIImage?
    
    
    var body: some View {
        VStack {
            
            if uploadImage != nil {
                Image(uiImage: uploadImage!)
                    .resizable()
                //                .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: 300, height: 300)
            }
            if downloadImage != nil {
                Image(uiImage: downloadImage!)
                    .resizable()
                //                .scaledToFill()
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 7)
                
            }
            
            Button(action: {
                self.isShowPhotoLibrary = true
            }) {
                HStack {
                    Image(systemName: "photo")
                        .font(.system(size: 20))
                    
                    Text("Photo library")
                        .font(.headline)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            }
            Button(action: {
                if let thisimage = uploadImage {
                    upload_Image(image: thisimage)
                }
            }) {
                Text("upload Image")
            }
            
            Button(action: {
                Storage.storage().reference().child("temp").getData(maxSize: 100 * 200 * 200) {
                    (imageData, err) in
                    if let err = err {
                        print("an error has occurred - \(err.localizedDescription)")
                    } else {
                        if let imageData = imageData {
                            self.downloadImage = UIImage(data: imageData)
                        } else {
                            print("an error has occurred")
                        }
                    }
                }
            }) {
                Text("Download Image")
            }
        }
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$uploadImage)
        }
    }
}


struct inputphoto_Previews: PreviewProvider {
    static var previews: some View {
        inputphoto()
    }
}

