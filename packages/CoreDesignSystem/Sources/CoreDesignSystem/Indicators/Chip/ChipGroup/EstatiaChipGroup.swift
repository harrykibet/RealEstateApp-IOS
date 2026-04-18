//
//  EstatiaChipGroup.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//

import SwiftUI

public struct EstatiaChipGroup: View {
    
    private let items: [EstatiaChipItem]
    private let selectionMode: EstatiaChipSelectionMode
    @Binding private var selectedIDs: Set<String>
    
    @Environment(\.theme) private var theme
    
    public init(
        items: [EstatiaChipItem],
        selectionMode: EstatiaChipSelectionMode,
        selectedIDs: Binding<Set<String>>
    ) {
        self.items = items
        self.selectionMode = selectionMode
        self._selectedIDs = selectedIDs
    }
    
    public var body: some View {
        EstatiaFlowLayout(spacing: 8, lineSpacing: 8) {
            ForEach(items) { item in
                EstatiaChip(
                    content: .init(
                        title: item.title,
                        leadingIcon: item.leadingIcon
                    ),
                    mode: chipMode(for: item)
                )
            }
        }
    }
}

// MARK: - Selection Logic

private extension EstatiaChipGroup {

    func chipMode(for item: EstatiaChipItem) -> EstatiaChipMode {
        
        switch selectionMode {
            
        case .none:
            return .action {}
            
        case .single:
            return .selectable(
                isSelected: selectedIDs.contains(item.id),
                onToggle: { _ in
                    selectedIDs = [item.id]
                }
            )
            
        case .multiple:
            return .selectable(
                isSelected: selectedIDs.contains(item.id),
                onToggle: { isSelected in
                    handleMultiSelection(item.id, isSelected)
                }
            )
        }
    }
}

// MARK: - Multi-Select Logic

private extension EstatiaChipGroup {

    func handleMultiSelection(_ id: String, _ isSelected: Bool) {
        if isSelected {
            selectedIDs.insert(id)
        } else {
            selectedIDs.remove(id)
        }
    }
}

#if DEBUG

#Preview("ChipGroup - Light") {
    Preview.light {
        ChipGroupPreviewContainer()
    }
}

#Preview("ChipGroup - Dark") {
    Preview.dark {
        ChipGroupPreviewContainer()
    }
}

// MARK: - Container

private struct ChipGroupPreviewContainer: View {
    
    @State private var singleSelection: Set<String> = ["2"]
    @State private var multiSelection: Set<String> = ["2", "4"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Single Select
                
                section(title: "Single Selection") {
                    EstatiaChipGroup(
                        items: filterOptions,
                        selectionMode: .single,
                        selectedIDs: $singleSelection
                    )
                }
                
                Text("Selected: \(singleSelection.first ?? "None")")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // MARK: - Multi Select
                
                section(title: "Multi Selection") {
                    EstatiaChipGroup(
                        items: filterOptions,
                        selectionMode: .multiple,
                        selectedIDs: $multiSelection
                    )
                }
                
                Text("Selected: \(multiSelection.joined(separator: ", "))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // MARK: - Stress
                
                section(title: "Large Dataset") {
                    EstatiaChipGroup(
                        items: largeDataset,
                        selectionMode: .multiple,
                        selectedIDs: $multiSelection
                    )
                }
            }
            .padding()
        }
    }
}

// MARK: - Data

private var largeDataset: [EstatiaChipItem] {
    (0..<60).map {
        EstatiaChipItem(
            id: "\($0)",
            title: "Item \($0)"
        )
    }
}

#endif
