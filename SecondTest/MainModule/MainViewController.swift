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
    
    private lazy var mainView = MainView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.iconsTableView.tableView.delegate = self
        mainView.iconsTableView.tableView.dataSource = self
        mainView.textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        mainView.textfield.addTarget(self, action: #selector(cancelTapped), for: .editingDidBegin)
        
        print("MainViewController Loaded")
        showEmpty(text: "Start Searching")
    }
    
    @objc private func textFieldDidChange(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        presenter.loadIcons(term: text)
    }
    
    @objc private func cancelTapped() {
        mainView.textfield.text = ""
        mainView.textfield.resignFirstResponder()
        mainView.setSearchMode(active: false)
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
        
    }
    
    func hideLoading() {
        
    }
    
    func showIcons() {
        
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainView.setSearchMode(active: true)
    }
}
