import UIKit
import SnapKit
import Kingfisher

final class IconCell: UITableViewCell {
    
    static let reuseIdentifier = "IconCell"
    
    private lazy var iconImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var maxIconSize: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }
    
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
    
    
    // MARK: - Решение проблемы с переиспользованием ячейки
    override func prepareForReuse() {
        super.prepareForReuse()
        
        iconImage.kf.cancelDownloadTask()
        iconImage.image = nil
    }
    
    private func setupSubviews() {
        contentView.addSubview(iconImage)
        contentView.addSubview(maxIconSize)
    }
    
    private func setupConstraints() {
        iconImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
        }
        
        maxIconSize.snp.makeConstraints { make in
            make.leading.equalTo(iconImage.snp.trailing).offset(16)
            make.top.equalTo(iconImage).offset(8)
        }
    }
}
