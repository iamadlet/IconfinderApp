import UIKit
import SnapKit

final class ErrorView: UIView {
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Oops! Something went wrong"
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "exclamationmark.triangle"))
        image.tintColor = .secondaryLabel
        return image
    }()
    
}

private extension ErrorView {
    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(label)
        addSubview(image)
    }
    
    func setupConstraints() {
        image.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.size.equalTo(150)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
    }
}
