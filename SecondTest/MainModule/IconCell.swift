//
//  IconCell.swift
//  SecondTest
//
//  Created by Адлет Жумагалиев on 25.11.2025.
//

import UIKit
import Kingfisher

final class IconCell: UITableViewCell {
    
    static let reuseIdentifier = "IconCell"
    private let iconName: String
    private let maxIconWidth: String
    private let maxIconHeight: String
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private lazy var maxIconSize: UILabel = {
        let label = UILabel()
        return label
    }()
    
    // TODO: - Сделать Collection View с массивом из тэгов (макс. 10 тегов, если их больше)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IconCell {
    func configureCell(with icon: IconModel) {
        let url = URL(string: icon.imageURL)
        iconImage.kf.setImage(with: url)
        maxIconSize.text = "max. size: \(icon.width)x\(icon.height)"
    }
    
    private func setupSubviews() {
        contentView.addSubview(iconImage)
        contentView.addSubview(maxIconSize)
    }
}
