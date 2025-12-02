//
//  MainView.swift
//  SecondTest
//
//  Created by Адлет Жумагалиев on 25.11.2025.
//

import UIKit
import SnapKit

final class IconsTableView: UIView {
    private var presenter: MainPresenterProtocol
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IconCell.self, forCellReuseIdentifier: IconCell.reuseIdentifier)
        return tableView
    }()
    
    let textfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Search icons"
        return textfield
    }()
}

extension IconsTableView {
    func commonInit() {
        backgroundColor = .systemBackground
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(tableView)
        addSubview(textfield)
    }
    
    func setupConstraints() {
        textfield.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textfield).offset(16)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
    }
}
