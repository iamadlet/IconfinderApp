//
//  MainView.swift
//  SecondTest
//
//  Created by Адлет Жумагалиев on 03.12.2025.
//

import Foundation
import UIKit

final class MainView: UIView {
    
    init() {
        super.init(frame: .zero)
        commonIni()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var loadingView: LoadingView = {
        let view = LoadingView()
        view.isHidden = true
        return view
    }()
    
    lazy var emptyView: EmptyView = {
        let view = EmptyView()
        view.isHidden = true
        return view
    }()
    
    lazy var iconsTableView: IconsTableView = {
        let view = IconsTableView()
        view.isHidden = true
        return view
    }()
    
    let textfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Search icons"
        return textfield
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.alpha = 0
        return button
    }()
    
    func setSearchMode(active: Bool) {
        if active {
            UIView.animate(withDuration: 0.3) {
                self.cancelButton.alpha = 1
                self.textfield.snp.remakeConstraints { make in
                    make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
                    make.leading.equalToSuperview().offset(16)
                    make.trailing.equalTo(self.cancelButton.snp.leading).offset(-8)
                    make.height.equalTo(36)
                }
                self.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.cancelButton.alpha = 0
                self.textfield.snp.remakeConstraints { make in
                    make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
                    make.leading.equalToSuperview().offset(16)
                    make.trailing.equalToSuperview().offset(-16)
                    make.height.equalTo(36)
                }
                self.layoutIfNeeded()
            }
        }
    }
}

private extension MainView {
    func commonIni() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(loadingView)
        addSubview(emptyView)
        addSubview(iconsTableView)
        addSubview(textfield)
        addSubview(cancelButton)
    }
    
    func setupConstraints() {
        textfield.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(textfield)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(60)
        }
        
        [iconsTableView, emptyView, loadingView].forEach { view in
            view.snp.makeConstraints { make in
                make.top.equalTo(textfield.snp.bottom).offset(10)
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
}
