//
//  EstatiaSegmentedControl.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

//
//  EstatiaSegmentedControl.swift
//  CoreDesignSystem
//

import SwiftUI

public struct EstatiaSegmentedControl<Value: Hashable, Content: View>: View {
    
    // MARK: - Properties
    
    @Binding private var selection: Value
    private let items: [Value]
    private let content: (Value, Bool) -> Content
    
    @Environment(\.theme) private var theme
    
    // MARK: - Init
    
    public init(
        selection: Binding<Value>,
        items: [Value],
        @ViewBuilder content: @escaping (Value, Bool) -> Content
    ) {
        self._selection = selection
        self.items = items
        self.content = content
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 4) {
            ForEach(items, id: \.self) { item in
                segment(for: item)
            }
        }
        .padding(4)
        .background(theme.colors.surfaceVariant)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Segment
    
    private func segment(for item: Value) -> some View {
        let isSelected = item == selection
        
        return Button {
            selection = item
        } label: {
            content(item, isSelected)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    isSelected
                    ? theme.colors.surface
                    : Color.clear
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }
}

#if DEBUG

private struct EstatiaSegmentedControlPreviewContent: View {
    
    @State private var selectedTab: AppTab = .home
    
    var body: some View {
        VStack(spacing: 24) {
            
            // Default
            EstatiaSegmentedControl(
                selection: $selectedTab,
                items: AppTab.allCases
            ) { item, isSelected in
                Text(item.title)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundColor(
                        isSelected
                        ? Color.primary
                        : Color.secondary
                    )
            }
            
            // Debug output (VERY useful)
            Text("Selected: \(selectedTab.title)")
                .font(.caption)
        }
    }
}

#Preview("Segmented - Light") {
    Preview.light {
        Preview.padded {
            EstatiaSegmentedControlPreviewContent()
        }
    }
}

#Preview("Segmented - Dark") {
    Preview.dark {
        Preview.padded {
            EstatiaSegmentedControlPreviewContent()
        }
    }
}

#endif
