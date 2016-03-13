//
//  BorderedButton.swift
//  On The Map
//
//  Created by Joseph Vallillo on 3/6/16.
//  Copyright © 2016 Joseph Vallillo. All rights reserved.
//

import UIKit

//MARK: - BorderedButton: UIButton
class BorderedButton: UIButton {

    //MARK: IBInspectable
    @IBInspectable var backingColor: UIColor = UIColor.clearColor() {
        didSet {
            backgroundColor = backingColor
        }
    }
    
    @IBInspectable var highlightColor: UIColor = UIColor.clearColor() {
        didSet {
            if state == .Highlighted {
                backgroundColor = highlightColor
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 4.0 {
        didSet {
            layer.masksToBounds = true
            layer.cornerRadius = cornerRadius
        }
    }
    
    //MARK: Tracking
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        backgroundColor = highlightColor
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        backgroundColor = backingColor
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?) {
        backgroundColor = backingColor
    }
    
}
