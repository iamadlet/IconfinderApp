import UIKit
import SnapKit

final class LoadingView: UIView {
    
    private var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.style = .large
        loadingIndicator.color = .blue
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        loadingIndicator.accessibilityIdentifier = "loadingId"
        loadingIndicator.isAccessibilityElement = true
        return loadingIndicator
    }()
    
    private let textfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Search icons"
        return textfield
    }()
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension LoadingView {
    
    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(loadingIndicator)
        addSubview(textfield)
    }
    
    func setupConstraints() {
        textfield.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
