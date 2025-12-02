import UIKit
import SnapKit

final class EmptyView: UIView {
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "Start searching icons"
        return label
    }()
    
    let image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        return image
    }()
    
    let textfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Search icons"
        return textfield
    }()
}


private extension EmptyView {
    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(label)
        addSubview(image)
        addSubview(textfield)
    }
    
    func setupConstraints() {
        textfield.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        image.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
    }
}
