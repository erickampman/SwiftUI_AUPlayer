/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Small extensions to simplify view handling in the demo app.
*/

#if os(iOS)
import UIKit
typealias EView = UIView
#elseif os(macOS)
import AppKit
typealias EView = NSView
#endif

public extension EView {
    func pinToSuperview() {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor)
        ])
    }
}
