//
//  BorderedView.swift
//  NavLinkProblem
//
//  Created by Eric Kampman on 5/3/21.
//

import Cocoa

class BorderedView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

		let r = bounds.insetBy(dx: 1, dy: 1)
		let bc = NSBezierPath.init(rect: r)
		borderColor.set()
		bc.stroke()
    }
	@IBInspectable var borderColor = NSColor.black
}
