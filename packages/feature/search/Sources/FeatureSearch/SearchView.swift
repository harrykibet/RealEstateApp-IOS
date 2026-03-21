//
//  SearchView.swift
//  search
//
//  Created by builder on 5/8/25.
//

import SwiftUI

public struct SearchView: View {
    public init() {}

    @State private var searchText = ""

    public var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Custom Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search properties...", text: $searchText)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray6))
                )
                .padding(.horizontal)
                .padding(.top, 12)

                // Results List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(0..<5, id: \.self) { index in
                            SearchResultCard(title: "Search Result \(index + 1)",
                                             subtitle: "Sample location and description")
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Search")
                        .font(.title3.bold())
                }
            }
        }
    }
}

// MARK: - Custom Card View
struct SearchResultCard: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    SearchView()
}
