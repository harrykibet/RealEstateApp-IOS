//
//  ImageDecoder 2.swift
//  CoreImagePipeline
//
//  Created by builder on 4/28/26.
//

import Foundation
import UIKit


public protocol ImageDecoder {
    func decode(_ data: Data, targetSize: CGSize?) throws -> UIImage
    
    func decodeProgressive(
        partialData: Data,
        isFinal: Bool
    ) -> UIImage?
}
