//
//  FooterView.swift
//  CKPullToLoadFooterView
//
//  Created by Cezary Kopacz on 01.03.2019.
//  Copyright © 2019 CezaryKopacz. All rights reserved.
//

import UIKit

class CKPullToLoadFooterView: UIView, CKPullToLoadFooterBase {
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    var state: FooterState = .pull {
        didSet {
            self.animateArrow()
            switch self.state {
            case .pull:
                self.setText(self.pullText)
            case .release:
                self.setText(self.releaseText)
            }
        }
    }

    func setText(_ text: String) {
        UIView.beginAnimations(nil, context: nil)
        UIView.transition(with: msgLabel,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.msgLabel.text = text
        }, completion: nil)
        
        UIView.commitAnimations()
    }

    func setHeight(_ height: CGFloat) {
        self.heightConstraint.constant = height
        self.animateFontSize()
    }
    
    private func animateArrow() {
        UIView.transition(with: self.arrowImageView, duration: 0.25, options: .curveLinear, animations: {
            self.arrowImageView.transform = CGAffineTransform.init(rotationAngle: self.state == .release ? CGFloat(179.9999).degreesToRadians : CGFloat(0).degreesToRadians)
        }, completion: nil)
        
    }
    
    private func animateFontSize() {
        let oryginalOffset = (self.heightConstraint.constant - self.frame.size.height/2)
        let scaleFactor = oryginalOffset / 100
        self.msgLabel.transform = CGAffineTransform.init(scaleX: 1, y: 1.0 + scaleFactor)
    }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
