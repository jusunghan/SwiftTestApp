//
//  UploadViewModel.swift
//  TestApp
//
//  Created by Jusung Han on 6/19/25.
//

import FirebaseStorage
import SwiftUI

class UploadViewModel: ObservableObject {
    @Published var uploadProgress: Double = 0.0
    @Published var downloadURL: URL?

    func uploadImage(_ image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }

        let fileName = UUID().uuidString + ".jpg"
        let ref = Storage.storage().reference().child("uploads/\(fileName)")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let uploadTask = ref.putData(imageData, metadata: metadata)

        // Monitor progress
        uploadTask.observe(.progress) { snapshot in
            let percent = Double(snapshot.progress?.fractionCompleted ?? 0)
            DispatchQueue.main.async {
                self.uploadProgress = percent
            }
        }

        // Completion
        uploadTask.observe(.success) { _ in
            ref.downloadURL { url, error in
                DispatchQueue.main.async {
                    self.downloadURL = url
                }
            }
        }

        uploadTask.observe(.failure) { snapshot in
            print("Upload failed: \(snapshot.error?.localizedDescription ?? "Unknown error")")
        }
    }
}
