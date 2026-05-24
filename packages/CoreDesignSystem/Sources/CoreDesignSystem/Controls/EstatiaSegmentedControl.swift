//
//  EstatiaSegmentedControl.swift
//  CoreDesignSystem
//
//  Created by builder on 4/12/26.
//

import SwiftUI


public struct EstatiaSegmentedControl<
    Value: Identifiable & Hashable,
    Content: View
>: View {
    
    @Binding private var selection: Value
    
    private let items: [Value]
    private let content: (Value, Bool) -> Content
    
    @Environment(\.theme) private var theme
    
    public init(
        selection: Binding<Value>,
        items: [Value],
        @ViewBuilder content: @escaping (Value, Bool) -> Content
    ) {
        self._selection = selection
        self.items = items
        self.content = content
    }
    
    public var body: some View {
        HStack(spacing: 4) {
            ForEach(items) { item in
                segment(for: item)
            }
        }
        .padding(4)
        .background(theme.colors.surfaceVariant)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private func segment(for item: Value) -> some View {
        
        let isSelected = item == selection
        
        return Button {
            withAnimation(.smooth(duration: 0.2)) {
                selection = item
            }
        } label: {
            content(item, isSelected)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    isSelected
                    ? theme.colors.surface
                    : .clear
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(
            isSelected
            ? [.isSelected]
            : []
        )
    }
}


#if DEBUG

private let tabPresentation: [AppTabID: TabPresentation] = [
    .home: .init(titleKey: "Home"),
    .explore: .init(titleKey: "Explore"),
    .saved: .init(titleKey: "Saved"),
    .inbox: .init(titleKey: "Inbox"),
    .profile: .init(titleKey: "Profile")
]


private struct EstatiaSegmentedControlPreviewContent: View {
    
    @State private var selectedTab: AppTabID = .home
    
    var body: some View {
        VStack(spacing: 24) {
            
            EstatiaSegmentedControl(
                selection: $selectedTab,
                items: AppTabID.allCases
            ) { item, isSelected in
                
                let presentation = tabPresentation[item]
                
                EstatiaText(presentation?.titleKey ?? "")
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(
                        isSelected
                        ? Color.primary
                        : Color.secondary
                    )
            }
            
            EstatiaText(
                "Selected: \(tabPresentation[selectedTab]?.titleKey ?? "")",
                style: .caption
            )
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
