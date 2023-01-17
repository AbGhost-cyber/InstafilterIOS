//
//  ContentView.swift
//  InstafilterIOS
//
//  Created by dremobaba on 2023/1/17.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var uiImage: UIImage?
    @State private var showingImagePicker = false
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showFilterSheet = false
    @State private var processedImage: UIImage?
    @State private var showingAlert = false
    @State private var alertMsg = ""
    
    let context = CIContext()
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    Text("Tap to select a picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    image?
                        .resizable()
                        .scaledToFit()
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _ in
                            applyProcessing()
                        }
                }
                .padding(.vertical)
                HStack {
                    Button("Change Filter") {
                        showFilterSheet = true
                    }
                    Spacer()
                    Button("Save", action: save)
                }
            }
            .onChange(of: uiImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $uiImage)
            }
            .confirmationDialog("Select a filter", isPresented: $showFilterSheet) {
                Button("Crystallize") {setFilter(CIFilter.crystallize())}
                Button("Edges") {setFilter(CIFilter.edges())}
                Button("Guassian Blur") {setFilter(CIFilter.gaussianBlur())}
                Button("Pixellate") {setFilter(CIFilter.pixellate())}
                Button("Sepia Tone") {setFilter(CIFilter.sepiaTone())}
                Button("Unsharp Mask") {setFilter(CIFilter.unsharpMask())}
                Button("Vignette") {setFilter(CIFilter.vignette())}
                Button("Cancel", role: .cancel) {}
            }
            .alert(alertMsg, isPresented: $showingAlert) {
                Button("OK") {}
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Insta Filter")
        }
    }
    
    func loadImage() {
        guard let inputImage = uiImage else { return }
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func setFilter(_ filter: CIFilter) {
        self.currentFilter = filter
        loadImage()
    }
    
    func save() {
        guard let processedImage = processedImage else { return }
       ImageSaver()
        .writeToPhotoAlbum(image: processedImage)
        .onComplete = { error in
           showingAlert = true
            alertMsg = error == nil ? "Successfully saved your filtered photo ✅" : "couldn't save image ❌, check if photo access permission is permitted"
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(Float(filterIntensity), forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(Float(filterIntensity * 200), forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(Float(filterIntensity * 10), forKey: kCIInputScaleKey)
        }
        guard let outputImage = currentFilter.outputImage else { return }
        if let cgImg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgImg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
