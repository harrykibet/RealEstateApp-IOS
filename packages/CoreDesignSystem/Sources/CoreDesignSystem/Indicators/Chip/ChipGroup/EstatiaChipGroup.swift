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
        flowLayout {
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
