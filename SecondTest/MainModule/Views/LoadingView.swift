import UIKit
import SnapKit

final class LoadingView: UIView {
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
}

private extension LoadingView {
    
    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(loadingIndicator)
    }
    
    func setupConstraints() {
        loadingIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
}
