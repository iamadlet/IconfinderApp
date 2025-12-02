//
//  MainView.swift
//  SecondTest
//
//  Created by Адлет Жумагалиев on 25.11.2025.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    func showError()
    func showEmpty(text: String)
    func showLoading()
    func hideLoading()
    func showIcons()
}

final class MainViewController: ViewController {
    private let presenter: MainPresenterProtocol
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var mainView: MainView = {
        let view = MainView(presenter: presenter)
        return view
    }()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.iconsTableView.tableView.delegate = self
        mainView.iconsTableView.tableView.dataSource = self
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getIcons().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: IconCell.reuseIdentifier) as? IconCell else {
            return UITableViewCell()
        }
        
        let icon = presenter.getIcons()[indexPath.row]
        cell.configureCell(with: icon)
        
        return cell
    }
}

extension MainViewController: MainViewProtocol {
    func showError() {
        hideLoading()
    }
    
    func showEmpty(text: String) {
        mainView.emptyView.isHidden = false
        mainView.iconsTableView.bringSubviewToFront(mainView.emptyView)
    }
    
    func showLoading() {
        <#code#>
    }
    
    func hideLoading() {
        <#code#>
    }
    
    func showIcons() {
        <#code#>
    }
    
    
}
