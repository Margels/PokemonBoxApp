//
//  UIView+Extensions.swift
//  CatchEmAll
//
//  Created by Margels on 14/06/24.
//

import Foundation
import UIKit

extension UIView {
    
    func customConstraints(
        top: NSLayoutYAxisAnchor? = nil,
        leading: NSLayoutXAxisAnchor? = nil,
        trailing: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        topPadding: CGFloat = 0,
        leadingPadding: CGFloat = 0,
        trailingPadding: CGFloat = 0,
        bottomPadding: CGFloat = 0
    ) {
        if let top = top { self.topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true }
        if let leading = leading { self.leadingAnchor.constraint(equalTo: leading, constant: leadingPadding).isActive = true }
        if let trailing = trailing { trailing.constraint(equalTo: self.trailingAnchor, constant: trailingPadding).isActive = true }
        if let bottom = bottom { bottom.constraint(equalTo: self.bottomAnchor, constant: bottomPadding).isActive = true }
    }
    
    func anchorTo(view: UIView, hPadding: CGFloat = 0, vPadding: CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: vPadding),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hPadding),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: hPadding),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: vPadding)
        ])
    }
    
    func anchorToSafeArea(of view: UILayoutGuide, hPadding: CGFloat = 0, vPadding: CGFloat = 0) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: vPadding),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hPadding),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: hPadding),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: vPadding)
        ])
    }
    
    func setSize(height: CGFloat? = nil, width: CGFloat? = nil)  {
        if let height = height { self.heightAnchor.constraint(equalToConstant: height).isActive = true }
        if let width = width { self.widthAnchor.constraint(equalToConstant: width).isActive = true }
    }
    
}
