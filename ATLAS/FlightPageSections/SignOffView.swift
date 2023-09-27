//
//  SignOffView.swift
//  ATLAS
//
//  Created by phuong phan on 27/09/2023.
//

import SwiftUI
import UIKit

struct SignOffView: View {
    @State private var isSignatureModalPresented = false
    @State private var isSignatureViewModalPresented = false
    @State private var signatureImage: UIImage?
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                isSignatureModalPresented.toggle()
            }) {
                Text("SIGN")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            Spacer()
            Button(action: {
                isSignatureViewModalPresented.toggle()
            }) {
                Text("VIEW SIGNATURE")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .sheet(isPresented: $isSignatureViewModalPresented) {
            SignatureView(image: signatureImage)
        }
        .sheet(isPresented: $isSignatureModalPresented) {
            SignatureModalView(signatureImage: $signatureImage, isSignatureModalPresented: $isSignatureModalPresented)
        }
    }
}

struct SignatureModalView: View {
    @Binding var signatureImage: UIImage?
    @State private var isDrawing = false
    @State private var drawing = Drawing()
    @Binding var isSignatureModalPresented: Bool
    @State var temp: UIImage?
    
    var body: some View {
        HStack {
            VStack {
                SignatureCanvasView(isDrawing: $isDrawing, drawing: $drawing)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
                HStack {
                    Button(action: {
                        drawing.clear()
                    }) {
                        Text("Clear")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                    Button(action: {
                        signatureImage = SignatureCanvasView(isDrawing: $isDrawing, drawing: $drawing).frame(maxWidth: .infinity, maxHeight: .infinity).snapshot()
                        isSignatureModalPresented = false
                    }) {
                        Text("Save")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
}

func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
func convertBase64ToImage(imageString: String) -> UIImage {
    let imageData = Data(base64Encoded: imageString,
                         options: Data.Base64DecodingOptions.ignoreUnknownCharacters)!
    return UIImage(data: imageData)!
}

struct Drawing {
    var points: [CGPoint] = []
    
    mutating func addPoint(_ point: CGPoint) {
        points.append(point)
    }
    
    mutating func clear() {
        points = []
    }
    
    var image: UIImage? {
        let size = CGSize(width: 300, height: 100)
        let canvasView = UIHostingController(rootView: SignatureCanvasView(isDrawing: .constant(false), drawing: .constant(self)))
        return canvasView.view.asImage(size: size)
    }
}

struct SignatureCanvasView: View {
    @Binding var isDrawing: Bool
    @Binding var drawing: Drawing
    
    var body: some View {
//        GeometryReader { geometry in
            ZStack {
                Color.white
                Path { path in
                    for index in drawing.points.indices {
                        let point = drawing.points[index]
                        
                        if index == 0 {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(Color.black, lineWidth: 2)
                .background(Color.white)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let point = value.location
                            drawing.addPoint(point)
                        }
//                        .onEnded { _ in
//                            drawing.clear() // Clear the drawing points
//                        }
                )
            }.frame(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height / 2)
//        }
    }
}

struct SignatureView: View {
    let image: UIImage?
    //@Binding var image: UIImage?
    
    var body: some View {
        if let image = image {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .navigationBarTitle("Signature")
        } else {
            Text("No signature available")
                .font(.largeTitle)
                .foregroundColor(.black)
        }
    }
}

extension UIImage {
    convenience init(view: UIView, size: CGSize) {
        UIGraphicsBeginImageContext(size)
        view.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

extension UIView {
    func asImage(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
        return nil
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.all))
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
