//
//  ReadPoint.swift
//  funny-class
//
//  Created by vzyw on 12/17/16.
//  Copyright © 2016 vzyw. All rights reserved.
//

import UIKit

//@IBDesignable
class ReadPoint: UILabel {

    @IBInspectable var topPadding: CGFloat = 0 {
        didSet {
            updatePadding()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet {
            updatePadding()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet {
            updatePadding()
        }
    }
    
    @IBInspectable var bottomPadding: CGFloat = 0 {
        didSet {
            updatePadding()
        }
    }
    
    private func updatePadding() {
        contentInset = UIEdgeInsetsMake(topPadding, leftPadding, bottomPadding, rightPadding)
    }
    
    var contentInset: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    
    convenience init(insets: UIEdgeInsets = .zero, text: String? = nil) {
        self.init(frame: .zero)
        contentInset = insets
        self.text = text
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + contentInset.left + contentInset.right, height: size.height + contentInset.top + contentInset.bottom)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, contentInset))
    }
}
