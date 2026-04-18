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
    
    // MARK: - State (simulate ViewModel)
    
    @State private var selectedFilters: Set<String> = ["2 Bedroom"]
    @State private var tags: [String] = ["Nairobi", "Furnished", "Pet Friendly"]
    @State private var actionCount: Int = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Selectable Chips
                
                section(title: "Selectable") {
                    flowLayout {
                        ForEach(filterOptions, id: \.self) { option in
                            EstatiaChip(
                                content: .init(title: option),
                                mode: .selectable(
                                    isSelected: selectedFilters.contains(option),
                                    onToggle: { isSelected in
                                        handleSelection(option, isSelected)
                                    }
                                )
                            )
                        }
                    }
                }
                
                // MARK: - Removable Chips
                
                section(title: "Removable") {
                    flowLayout {
                        ForEach(tags, id: \.self) { tag in
                            EstatiaChip(
                                content: .init(title: tag),
                                mode: .removable {
                                    removeTag(tag)
                                }
                            )
                        }
                    }
                }
                
                // MARK: - Action Chips
                
                section(title: "Action") {
                    flowLayout {
                        EstatiaChip(
                            content: .init(title: "Sort", leadingIcon: "arrow.up.arrow.down"),
                            mode: .action {
                                actionCount += 1
                            }
                        )
                        
                        EstatiaChip(
                            content: .init(title: "Filter", leadingIcon: "slider.horizontal.3"),
                            mode: .action {
                                actionCount += 1
                            }
                        )
                    }
                    
                    Text("Actions triggered: \(actionCount)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // MARK: - Stress Test
                
                section(title: "Stress Test (Rapid Toggle)") {
                    flowLayout {
                        ForEach(0..<20, id: \.self) { index in
                            let title = "Chip \(index)"
                            
                            EstatiaChip(
                                content: .init(title: title),
                                size: .small,
                                mode: .selectable(
                                    isSelected: selectedFilters.contains(title),
                                    onToggle: { isSelected in
                                        handleSelection(title, isSelected)
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

private func section<Content: View>(
    title: String,
    @ViewBuilder content: () -> Content
) -> some View {
    VStack(alignment: .leading, spacing: 12) {
        Text(title)
            .font(.headline)
        content()
    }
}

private func flowLayout<Content: View>(
    @ViewBuilder content: () -> Content
) -> some View {
    LazyVGrid(
        columns: [GridItem(.adaptive(minimum: 80), spacing: 8)],
        alignment: .leading,
        spacing: 8
    ) {
        content()
    }
}

private let filterOptions = [
    "1 Bedroom", "2 Bedroom", "3 Bedroom",
    "Furnished", "Unfurnished", "Pet Friendly"
]

private extension ChipPreviewContainer {
    
    func handleSelection(_ option: String, _ isSelected: Bool) {
        if isSelected {
            selectedFilters.insert(option)
        } else {
            selectedFilters.remove(option)
        }
    }
    
    func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
}

#endif

