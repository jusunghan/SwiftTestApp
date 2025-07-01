//
//  UploadView.swift
//  TestApp
//
//  Created by Jusung Han on 6/19/25.
//

import SwiftUI

struct UploadView: View {
    @StateObject private var viewModel = UploadViewModel()
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false

    var body: some View {
        VStack(spacing: 20) {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
            }

            Button("Select Image") {
                showImagePicker = true
            }

            if let image = selectedImage {
                Button("Upload Image") {
                    viewModel.uploadImage(image)
                }
            }

            if viewModel.uploadProgress > 0 {
                ProgressView(value: viewModel.uploadProgress)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()
            }

            if let url = viewModel.downloadURL {
                Text("Uploaded URL:")
                Text(url.absoluteString)
                    .font(.caption)
                    .foregroundColor(.blue)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $selectedImage)
        }
        .padding()
    }
}
