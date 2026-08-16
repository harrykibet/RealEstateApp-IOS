//
//  HomeView.swift
//  home
//
//  Created by builder on 5/8/25.
//


import SwiftUI

public struct HomeView: View {
    @StateObject var viewModel: HomeViewModel

    public init(viewModel: HomeViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.properties.indices, id: \.self) { index in
                    let property = viewModel.properties[index]

                    VStack(alignment: .leading, spacing: 6) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 200)
                            .cornerRadius(10)

                        Text(property.title ?? "Untitled Property")
                            .font(.headline)
                        Text(property.county ?? "Unknown • — Beds • —")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Home")
            .task {
                await viewModel.load()
            }
        }
    }
}

#Preview {
    struct MockRepo: PropertyRepository {
        func fetchProperty(id: String) async throws -> PropertyModel { PropertyModel() }
        func fetchProperties() async throws -> [PropertyModel] { [PropertyModel()] }
        func searchProperties(query: String?, filters: PropertySearchFilters) async throws -> [PropertyModel] { [PropertyModel()] }
        func createProperty(_ property: PropertyModel) async throws -> PropertyModel { property }
        func updateProperty(_ property: PropertyModel) async throws -> PropertyModel { property }
        func deleteProperty(id: String) async throws {}
    }
    HomeView(viewModel: HomeViewModel(repository: MockRepo()))
}
