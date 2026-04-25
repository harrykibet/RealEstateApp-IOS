//
//  EstatiaChipPreview.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//

import SwiftUI

#if DEBUG

#Preview("Chip - Light (Interactive)") {
    Preview.light {
        ChipPreviewContainer()
    }
}

#Preview("Chip - Dark (Interactive)") {
    Preview.dark {
        ChipPreviewContainer()
    }
}

// MARK: - Preview Container

private struct ChipPreviewContainer: View {
    
    // MARK: - State
    
    @State private var selectedFilters: Set<String> = ["2"]
    @State private var tags: [EstatiaChipItem] = [
        .init(id: "nai", title: "Nairobi"),
        .init(id: "fur", title: "Furnished"),
        .init(id: "pet", title: "Pet Friendly")
    ]
    @State private var actionCount: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Selectable
                
                section(title: "Selectable") {
                    EstatiaFlowLayout(spacing: 8, lineSpacing: 8) {
                        ForEach(filterOptions) { item in
                            EstatiaChip(
                                content: .init(title: item.title),
                                mode: .selectable(
                                    isSelected: selectedFilters.contains(item.id),
                                    onToggle: { isSelected in
                                        handleSelection(item.id, isSelected)
                                    }
                                )
                            )
                        }
                    }
                }
                
                // MARK: - Removable
                
                section(title: "Removable") {
                    EstatiaFlowLayout(spacing: 8, lineSpacing: 8) {
                        ForEach(tags) { tag in
                            EstatiaChip(
                                content: .init(title: tag.title),
                                mode: .removable {
                                    removeTag(tag.id)
                                }
                            )
                        }
                    }
                }
                
                // MARK: - Action
                
                section(title: "Action") {
                    EstatiaFlowLayout(spacing: 8, lineSpacing: 8) {
                        EstatiaChip(
                            content: .init(title: "Sort", leadingIcon: "arrow.up.arrow.down"),
                            mode: .action { actionCount += 1 }
                        )
                        
                        EstatiaChip(
                            content: .init(title: "Filter", leadingIcon: "slider.horizontal.3"),
                            mode: .action { actionCount += 1 }
                        )
                    }
                    
                    EstatiaText("Actions triggered: \(actionCount)", style: .caption)
                        .foregroundColor(.secondary)
                }
                
                // MARK: - Stress
                
                section(title: "Stress Test") {
                    EstatiaFlowLayout(spacing: 8, lineSpacing: 8) {
                        ForEach(0..<30, id: \.self) { index in
                            let id = "chip_\(index)"
                            
                            EstatiaChip(
                                content: .init(title: "Chip \(index)"),
                                size: .small,
                                mode: .selectable(
                                    isSelected: selectedFilters.contains(id),
                                    onToggle: { isSelected in
                                        handleSelection(id, isSelected)
                                    }
                                )
                            )
                        }
                    }
                }
            }
            .padding()
        }
    }
}



private extension ChipPreviewContainer {
    
    func handleSelection(_ id: String, _ isSelected: Bool) {
        if isSelected {
            selectedFilters.insert(id)
        } else {
            selectedFilters.remove(id)
        }
    }
    
    func removeTag(_ id: String) {
        tags.removeAll { $0.id == id }
    }
}

#endif
