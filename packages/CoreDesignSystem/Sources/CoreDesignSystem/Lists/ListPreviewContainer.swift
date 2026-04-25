//
//  ListPreviewContainer.swift
//  CoreDesignSystem
//
//  Created by builder on 4/21/26.
//


import SwiftUI

#if DEBUG

#Preview("List - Light (Interactive)") {
    Preview.light {
        ListPreviewContainer()
    }
}

#Preview("List - Dark (Interactive)") {
    Preview.dark {
        ListPreviewContainer()
    }
}

// MARK: - Preview Container

private struct ListPreviewContainer: View {
    
    @State private var isEnabled: Bool = true
    
    var body: some View {
        EstatiaList {
            
            // MARK: - Section 1 (Basic)
            
            EstatiaListSection(
                header: {
                    sectionHeader("Basic")
                },
                content: {
                    EstatiaListItem {
                        EstatiaIconButton(systemImage: "house", action: {})
                    } content: {
                        titleSubtitle("Home", "Primary destination")
                    } trailing: {
                        chevron()
                    }
                    
                    EstatiaDivider(inset: 56)
                    
                    EstatiaListItem {
                        EstatiaIconButton(systemImage: "heart",
                             action: {})
                    } content: {
                        titleSubtitle("Favorites", "Saved properties")
                    } trailing: {
                        chevron()
                    }
                },
                footer: {
                    sectionFooter("Simple navigation items")
                }
            )
            
            // MARK: - Section 2 (Controls)
            
            EstatiaListSection(
                header: {
                    sectionHeader("Controls")
                },
                content: {
                    EstatiaListItem {
                        EstatiaIconButton(systemImage: "bell", action: {})
                    } content: {
                        title("Notifications")
                    } trailing: {
                        EstatiaToggle(isOn: $isEnabled)
                            .labelsHidden()
                    }
                    
                    EstatiaDivider(inset: 56)
                    
                    EstatiaListItem {
                        EstatiaIconButton(systemImage: "moon", action: {})
                    } content: {
                        title("Dark Mode")
                    } trailing: {
                        EstatiaToggle(isOn: .constant(true))
                            .labelsHidden()
                    }
                },
                footer: {
                    sectionFooter("Interactive controls inside list")
                }
            )
            
            // MARK: - Section 3 (Dense List)
            
            EstatiaListSection(
                header: {
                    sectionHeader("Dense")
                },
                content: {
                    ForEach(0..<10, id: \.self) { index in
                        EstatiaListItem {
                            icon("building.2")
                        } content: {
                            title("Property \(index + 1)")
                        } trailing: {
                            price("$\(1000 + index * 50)")
                        }
                        
                        if index < 9 {
                            EstatiaDivider(inset: 56)
                        }
                    }
                },
                footer: {
                    sectionFooter("Stress test for spacing & performance")
                }
            )
        }
    }
}

private func sectionHeader(_ text: String) -> some View {
    Text(text)
        .font(.caption)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
        .padding(.top, 12)
}

private func sectionFooter(_ text: String) -> some View {
    Text(text)
        .font(.caption2)
        .foregroundStyle(.secondary)
        .padding(.horizontal)
        .padding(.bottom, 12)
}

private func title(_ text: String) -> some View {
    Text(text)
        .font(.body)
}

private func titleSubtitle(_ title: String, _ subtitle: String) -> some View {
    VStack(alignment: .leading, spacing: 2) {
        Text(title)
            .font(.body)
        
        Text(subtitle)
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}

private func icon(_ systemName: String) -> some View {
    Image(systemName: systemName)
        .frame(width: 24, height: 24)
}

private func chevron() -> some View {
    Image(systemName: "chevron.right")
        .font(.caption)
        .foregroundStyle(.secondary)
}

private func price(_ value: String) -> some View {
    Text(value)
        .font(.subheadline)
        .foregroundStyle(.primary)
}

#endif
