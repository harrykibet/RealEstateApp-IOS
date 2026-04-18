//
//  EstatiaChipGroup.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//


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