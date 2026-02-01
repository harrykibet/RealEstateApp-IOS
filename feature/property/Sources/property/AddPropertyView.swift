//
//  AddPropertyView.swift
//  property
//
//  Created by builder on 5/8/25.
//

import SwiftUI

public struct AddPropertyView: View {
    @StateObject private var viewModel = AddPropertyViewModel()

    public init(viewModel: AddPropertyViewModel = AddPropertyViewModel()) {
            _viewModel = StateObject(wrappedValue: viewModel)
        }
    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Info")) {
                    TextField("Title", text: Binding(
                        get: { viewModel.property.title ?? "" },
                        set: { viewModel.property.title = $0 }
                    ))

                    TextField("Address", text: Binding(
                        get: { viewModel.property.address ?? "" },
                        set: { viewModel.property.address = $0 }
                    ))

                    TextField("County", text: Binding(
                        get: { viewModel.property.county ?? "" },
                        set: { viewModel.property.county = $0 }
                    ))

                    TextField("Price", text: Binding(
                        get: { String(viewModel.property.price ?? 0) },
                        set: { viewModel.property.price = Double($0) ?? 0 }
                    ))
                    .keyboardType(.decimalPad)
                }

                Section(header: Text("Details")) {
                    TextEditor(text: Binding(
                        get: { viewModel.property.description ?? "" },
                        set: { viewModel.property.description = $0 }
                    ))
                    .frame(minHeight: 100)

                    TextField("Bedrooms", text: Binding(
                        get: { String(viewModel.property.bedrooms ?? 0) },
                        set: { viewModel.property.bedrooms = Int($0) ?? 0 }
                    ))
                    .keyboardType(.numberPad)

                    TextField("Bathrooms", text: Binding(
                        get: { String(viewModel.property.bathrooms ?? 0) },
                        set: { viewModel.property.bathrooms = Int($0) ?? 0 }
                    ))
                    .keyboardType(.numberPad)

                    TextField("Area Size", text: Binding(
                        get: { String(viewModel.property.areaSize ?? 0) },
                        set: { viewModel.property.areaSize = Double($0) ?? 0 }
                    ))
                    .keyboardType(.decimalPad)
                }

                Section(header: Text("Contact Info")) {
                    TextField("Contact Phone", text: Binding(
                        get: { viewModel.property.contactPhone ?? "" },
                        set: { viewModel.property.contactPhone = $0 }
                    ))

                    TextField("Contact Email", text: Binding(
                        get: { viewModel.property.contactEmail ?? "" },
                        set: { viewModel.property.contactEmail = $0 }
                    ))
                }

                Section(header: Text("Availability & Terms")) {
                    TextField("Available From", text: Binding(
                        get: { viewModel.property.availableFrom ?? "" },
                        set: { viewModel.property.availableFrom = $0 }
                    ))

                    TextField("Lease Terms", text: Binding(
                        get: { viewModel.property.leaseTerms ?? "" },
                        set: { viewModel.property.leaseTerms = $0 }
                    ))

                    Toggle("Is Available?", isOn: Binding(
                        get: { viewModel.property.available },
                        set: { viewModel.property.available = $0 }
                    ))
                }

                Section {
                    Button("Submit Property") {
                        // TODO: Submit logic
                        print(viewModel.property)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                }
            }
            .navigationTitle("Add Property")
        }
    }
}

#Preview {
    let mockViewModel = AddPropertyViewModel()
    mockViewModel.property.title = "Sample Apartment"
    mockViewModel.property.address = "123 Nairobi St"
    mockViewModel.property.county = "Nairobi"
    mockViewModel.property.price = 45000
    mockViewModel.property.description = "Spacious and well-lit apartment"
    mockViewModel.property.bedrooms = 2
    mockViewModel.property.bathrooms = 1
    mockViewModel.property.areaSize = 85.0
    mockViewModel.property.contactPhone = "0700000000"
    mockViewModel.property.contactEmail = "agent@example.com"
    mockViewModel.property.availableFrom = "2025-06-01"
    mockViewModel.property.leaseTerms = "1 year"
    mockViewModel.property.available = true

    return AddPropertyView(viewModel: mockViewModel)
}
