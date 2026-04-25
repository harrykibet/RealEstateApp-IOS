//
//  EstatiaBadgePreview.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//

import SwiftUI

#if DEBUG

#Preview("Badge - Light") {
    Preview.light {
        badgePreviewContent
    }
}

#Preview("Badge - Dark") {
    Preview.dark {
        badgePreviewContent
    }
}

// MARK: - Preview Content

private var badgePreviewContent: some View {
    VStack(spacing: 20) {
        
        // MARK: - Text Badges
        
        VStack(alignment: .leading, spacing: 12) {
            EstatiaText("Text", style: .caption)
            
            HStack(spacing: 12) {
                EstatiaBadge(content: .text("New"), style: .primary)
                EstatiaBadge(content: .text("Featured"), style: .secondary)
                EstatiaBadge(content: .text("Verified"), style: .success)
                EstatiaBadge(content: .text("Pending"), style: .warning)
                EstatiaBadge(content: .text("Rejected"), style: .error)
                EstatiaBadge(content: .text("Neutral"), style: .neutral)
            }
        }
        
        // MARK: - Count Badges
        
        VStack(alignment: .leading, spacing: 12) {
            EstatiaText("Count", style: .caption)
            
            HStack(spacing: 12) {
                EstatiaBadge(content: .count(5), style: .primary)
                EstatiaBadge(content: .count(42), style: .success)
                EstatiaBadge(content: .count(120), style: .warning)
                EstatiaBadge(content: .count(999), style: .error)
            }
        }
        
        // MARK: - Icon Badges
        
        VStack(alignment: .leading, spacing: 12) {
            EstatiaText("Icon", style: .caption)
            
            HStack(spacing: 12) {
                EstatiaBadge(content: .icon(systemName: "star.fill"), style: .primary)
                EstatiaBadge(content: .icon(systemName: "checkmark.seal.fill"), style: .success)
                EstatiaBadge(content: .icon(systemName: "exclamationmark.triangle.fill"), style: .warning)
            }
        }
        
        // MARK: - Sizes
        
        VStack(alignment: .leading, spacing: 12) {
            EstatiaText("Sizes", style: .caption)
            
            HStack(spacing: 12) {
                EstatiaBadge(content: .text("Small"), size: .small)
                EstatiaBadge(content: .text("Medium"), size: .medium)
                EstatiaBadge(content: .text("Large"), size: .large)
            }
        }
        
        // MARK: - Mixed (Real-world scenarios)
        
        VStack(alignment: .leading, spacing: 12) {
            EstatiaText("Real Use Cases", style: .caption)
            
            HStack(spacing: 12) {
                EstatiaBadge(
                    content: .count(5),
                    style: .error,
                    accessibilityLabel: "5 unread notifications"
                )
                
                EstatiaBadge(
                    content: .text("New"),
                    style: .primary
                )
                
                EstatiaBadge(
                    content: .icon(systemName: "checkmark.seal.fill"),
                    style: .success,
                    accessibilityLabel: "Verified property"
                )
            }
        }
    }
    .padding()
}

#endif
