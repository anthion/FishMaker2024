//
//  File.swift
//  FishMaker2024
//
//  Created by Anthony Heath on 11/27/24.
//

import SwiftUI

class LightFieldViewModel: ObservableObject {
    @Published var displayImage: UIImage?
    private var lightFieldData: LightFieldData?
    
    func loadTestImage() {
        guard let image = UIImage(named: "IMG_0444") else {
            print("Failed to load bundled test image")
            return
        }
        
        do {
            // Create a temporary URL since our init expects one
            guard let data = image.jpegData(compressionQuality: 1.0) else { return }
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("temp.jpg")
            try data.write(to: tempURL)
            
            let lightField = try LightFieldData(imageURL: tempURL)
            self.lightFieldData = lightField
            self.displayImage = lightField.getRawImage()
            
            try? FileManager.default.removeItem(at: tempURL)
        } catch {
            print("Failed to process image: \(error)")
        }
    }
}
