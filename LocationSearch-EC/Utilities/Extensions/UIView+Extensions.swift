//
//  UIView+Extensions.swift
//  LocationSearch-EC
//
//  Created by Mac Mini 2 on 10/24/20.
//

import UIKit

extension UIView {
    public func addTapGesture(tapNumber: Int = 1, target: AnyObject, action: Selector) {
       let tap = UITapGestureRecognizer(target: target, action: action)
       tap.numberOfTapsRequired = tapNumber
       addGestureRecognizer(tap)
       isUserInteractionEnabled = true
   }
}
