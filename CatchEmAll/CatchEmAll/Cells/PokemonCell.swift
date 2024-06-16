//
//  PokemonCell.swift
//  CatchEmAll
//
//  Created by Margels on 14/06/24.
//

import Foundation
import UIKit

final class PokemonCell: UITableViewCell {
    
    private lazy var containerStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.distribution = .fill
        sv.axis = .horizontal
        return sv
    }()
    
    private lazy var iconImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.distribution = .fill
        sv.axis = .vertical
        return sv
    }()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return l
    }()
    
    private lazy var typeStackView: UIStackView = {
        let sv = UIStackView()
        sv.spacing = 4
        sv.distribution = .fill
        sv.axis = .horizontal
        return sv
    }()
    
    private lazy var spacerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.textAlignment = .left
        l.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        l.textColor = .secondaryLabel
        return l
    }()
    
    static let identifier = "PokemonCell"
    
    var titleText: String = "" { didSet { didUpdateTitleText() } }
    var imageUrl: URL? = nil { didSet { didUpdateIconImage() } }
    var types: [PokemonTypeModel] = [] { didSet { didUpdateTypes() } }
    var descriptionText: String? { didSet { didUpdateDescriptionText() } }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setUpView()
        self.setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpView() {
        self.contentView.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(iconImage)
        containerStackView.addArrangedSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(typeStackView)
        verticalStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setUpConstraints() {
        containerStackView.anchorTo(view: self.contentView, hPadding: 20, vPadding: 20)
        iconImage.setSize(width: 75)
        typeStackView.setSize(height: 20)
    }
    
    func config(with model: PokemonDetailsModel) {
        
        titleText = model.name.capitalized
        imageUrl = model.photoUrl
        types = model.types
        descriptionText = model.description
        
        self.setNeedsLayout()
    }
    
    private func didUpdateTitleText() {
        titleLabel.text = titleText
    }
    
    private func didUpdateIconImage() {
        self.iconImage.image = nil
        if let url = imageUrl {
          URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let imageData = data else { return }
            DispatchQueue.main.async {
                self.iconImage.image = UIImage(data: imageData)
            }
          }.resume()
        }
    }
    
    private func didUpdateTypes() {
        self.typeStackView.subviews.forEach { $0.removeFromSuperview() }
        for type in types {
            // Create label
            let view = BadgeView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.text = type.type.name.capitalized
            // Add to stack view
            let index = self.typeStackView.arrangedSubviews.count-1
            self.typeStackView.insertArrangedSubview(view, at: index >= 0 ? index : 0)
        }
        self.typeStackView.addArrangedSubview(spacerView)
    }
    
    private func didUpdateDescriptionText() {
        descriptionLabel.text = descriptionText?.replacingOccurrences(of: "\n", with: " ")
    }
}


