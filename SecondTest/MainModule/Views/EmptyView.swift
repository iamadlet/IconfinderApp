import UIKit
import SnapKit

final class EmptyView: UIView {
    
    private var text: String
    
    init(text: String) {
        self.text = text
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        image.tintColor = .secondaryLabel
        return image
    }()
}


private extension EmptyView {
    func commonInit() {
        backgroundColor = .systemBackground
        label.text = text
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
