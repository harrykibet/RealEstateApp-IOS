//
//  HomeView.swift
//  home
//
//  Created by builder on 5/8/25.
//


import SwiftUI

public struct HomeView: View {
    public init() {}
    public var body: some View {
        NavigationView {
            List {
                ForEach(0..<10) { index in
                    VStack(alignment: .leading, spacing: 6) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 200)
                            .cornerRadius(10)

                        Text("Property Title \(index + 1)")
                            .font(.headline)
                        Text("Location • 2 Beds • $1200/month")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Home")
        }
    }
}
#Preview {
    HomeView()
}
