//
//  EstatiaChipMode.swift
//  CoreDesignSystem
//
//  Created by builder on 4/18/26.
//


public enum EstatiaChipMode {
    case action(() -> Void)
    case selectable(isSelected: Bool, onToggle: (Bool) -> Void)
    case removable(onRemove: () -> Void)
}