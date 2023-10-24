import SwiftUI
import CoreImage.CIFilterBuiltins

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.isPresented) private var isPresented
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage
    @Binding var outputImage: UIImage
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> some UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        if isPresented {
//            
//        } else {
//            uiViewController.dismiss(animated: false)
//        }
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                applyGrayFilter(image)
//                applyMonochromeFilter(image)
                applyCIMonochromeFilter(image)
                parent.selectedImage = image
                picker.dismiss(animated: true)
            }
        }
        
        func applyGrayFilter(_ image: UIImage) {
            let filter = GrayscaleFilter()
            if let cgImage = image.cgImage {
                filter.inputImage = CIImage(cgImage: cgImage)
                if let output = filter.outputImage {
                    let context = CIContext()
                    if let outputCGImage = context.createCGImage(output, from: output.extent) {
                        parent.outputImage = UIImage(cgImage: outputCGImage)
                    }
                }
            }
        }
        
        func applyMonochromeFilter(_ image: UIImage) {
            let filter = MonochromeFilter()
            if let cgImage = image.cgImage {
                filter.inputImage = CIImage(cgImage: cgImage)
                filter.inputTintColor = .green
                if let output = filter.outputImage {
                    let context = CIContext()
                    if let outputCGImage = context.createCGImage(output, from: output.extent) {
                        parent.outputImage = UIImage(cgImage: outputCGImage)
                    }
                }
            }
        }
        
        func applyCIMonochromeFilter(_ image: UIImage) {
            let ciImage = CIImage(image: image)
            let filter = CIFilter.colorMonochrome()
            // 設定CIFilter物件
            filter.inputImage = ciImage
            filter.color = CIColor.black
            filter.intensity = 0.8
//            if let outputCIImage = filter.outputImage {
//                let filterImage = UIImage(ciImage: outputCIImage)
//                parent.outputImage = filterImage
//            }
            if let output = filter.outputImage {
                let context = CIContext()
                if let outputCGImage = context.createCGImage(output, from: output.extent) {
                    parent.outputImage = UIImage(cgImage: outputCGImage)
                }
            }
        }
    }
}
