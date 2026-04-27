//
//  EstatiaImage.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI

public struct EstatiaImage: View {
    
    private let image: Image
    private let contentMode: ContentMode
    
    public init(
        image: Image,
        contentMode: ContentMode = .fill
    ) {
        self.image = image
        self.contentMode = contentMode
    }
    
    public var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: contentMode)
            .clipped()
    }
}
