//
//  ContentView.swift
//  InstafilterIOS
//
//  Created by dremobaba on 2023/1/17.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var uiImage: UIImage?
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
            
            Button("Select Image") {
                showingImagePicker = true
            }
            Button("Save Image") {
                guard let outputImage = uiImage else {return}
                ImageSaver()
                    .writeToPhotoAlbum(image: outputImage)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $uiImage)
        }
        .onChange(of: uiImage) { _ in
            loadImage()
        }
    }
    
    func loadImage() {
        guard let inputImage = uiImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
