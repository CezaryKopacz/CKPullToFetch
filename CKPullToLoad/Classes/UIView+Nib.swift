//
//  UIView+Nib.swift
//  CKPullToLoad
//
//  Created by Cezary Kopacz on 01.03.2019.
//  Copyright © 2019 CezaryKopacz. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: self, options: nil)![0] as! T
    }
}
