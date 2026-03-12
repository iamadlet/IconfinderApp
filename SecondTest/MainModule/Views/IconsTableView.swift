import UIKit
import SnapKit

final class IconsTableView: UIView {
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(IconCell.self, forCellReuseIdentifier: IconCell.reuseIdentifier)
        tableView.rowHeight = 100
        return tableView
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
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
    }
}
