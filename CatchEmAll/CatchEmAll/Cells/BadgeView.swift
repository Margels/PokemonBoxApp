//
//  BadgeView.swift
//  CatchEmAll
//
//  Created by Margels on 15/06/24.
//

import Foundation
import UIKit

final class BadgeView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        l.textColor = .secondaryLabel
        return l
    }()
    
    var text: String = "" { didSet { didUpdateTitleLabelText() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
        setUpConstraints()
        setUpAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpLayout() {
        addSubview(titleLabel)
    }
    
    private func setUpConstraints() {
        titleLabel.anchorTo(view: self, hPadding: 4, vPadding: 2)
    }
    
    private func setUpAppearance() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 4
    }
    
    private func didUpdateTitleLabelText() {
        titleLabel.text = text
    }
    
}
