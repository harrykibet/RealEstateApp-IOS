//
//  AuthBackground.swift
//  FeatureAuth
//
//  Created by builder on 6/12/26.
//

import SwiftUI


struct AuthBackground: View {

    let content: () -> Content

    var body: some View {

        ZStack {

            LinearGradient(...)

            content()
        }
    }
}
