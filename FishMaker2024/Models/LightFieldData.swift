//
//  LightFieldData.swift
//  FishMaker2024
//
//  Created by Anthony Heath on 11/27/24.
//

import Foundation
import UIKit

struct LightFieldParameters {
    // Physical array properties
    static let physicalArrayWidth = 82
    static let physicalArrayHeight = 73
    static let lensletSizeMM: Float = 1.6
    
    // Captured image properties
    static let imageWidth = 4608
    static let imageHeight = 3456
    static let visibleArrayWidth = 80  // approximate
    static let visibleArrayHeight = 60 // approximate
    
    // Derived properties
    static let pixelsPerLenslet: Float = Float(imageWidth) / Float(visibleArrayWidth)
}

class LightFieldData {
    // Raw image data
    private var rawImage: UIImage?
    private var imageData: CGImage?
    
    // Calibration state
    private var rotationAngle: Float = 0.0
    private var firstLensletOffset: CGPoint = .zero
    
    init(imageURL: URL) throws {
        guard let image = UIImage(contentsOfFile: imageURL.path) else {
            throw LightFieldError.imageLoadFailed
        }
        self.rawImage = image
        self.imageData = image.cgImage
    }
    
    // Basic access methods
    func getRawImage() -> UIImage? {
        return rawImage
    }
    
    // Get region for specific lenslet
    func getLensletRegion(x: Int, y: Int) -> CGRect? {
        guard x >= 0 && x < LightFieldParameters.visibleArrayWidth,
              y >= 0 && y < LightFieldParameters.visibleArrayHeight else {
            return nil
        }
        
        // TODO: Apply rotation and offset transforms
        let lensletSize = LightFieldParameters.pixelsPerLenslet
        
        return CGRect(x: CGFloat(Float(x) * lensletSize),
                     y: CGFloat(Float(y) * lensletSize),
                     width: CGFloat(lensletSize),
                     height: CGFloat(lensletSize))
    }
}

enum LightFieldError: Error {
    case imageLoadFailed
    case invalidLensletIndex
    case calibrationRequired
    // Add more error cases as needed
}
