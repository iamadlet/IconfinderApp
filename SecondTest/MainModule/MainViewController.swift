import UIKit

protocol MainViewProtocol: AnyObject {
    func showError()
    func showEmpty(text: String)
    func showLoading()
    func hideLoading()
    func showIcons()
    func scrollToTop()
    func showMessage(title: String, message: String)
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
        mainView.textfield.delegate = self
        mainView.cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        
        print("MainViewController Loaded")
        showEmpty(text: "Start Searching icons")
    }
    
    // MARK: - Не нужен уже этот метод
    @objc private func textFieldDidChange(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        presenter.loadIcons(term: text)
    }
    
    @objc private func cancelTapped() {
        mainView.textfield.text = ""
        mainView.textfield.resignFirstResponder()
        mainView.setSearchMode(active: false)
        self.hideLoading()
        self.showEmpty(text: "Start searching again")
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
        
        let icon = presenter.icon(at: indexPath.row)
        cell.configureCell(with: icon)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectIcon(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController: MainViewProtocol {
    func showError() {
        mainView.emptyView.isHidden = true
        mainView.loadingView.isHidden = true
        mainView.iconsTableView.isHidden = true
        mainView.errorView.isHidden = false
        mainView.bringSubviewToFront(mainView.errorView)
    }
    
    func showEmpty(text: String) {
        mainView.loadingView.isHidden = true
        mainView.iconsTableView.isHidden = true
        mainView.errorView.isHidden = true
        mainView.emptyView.isHidden = false
        mainView.bringSubviewToFront(mainView.emptyView)
    }
    
    func showLoading() {
        mainView.emptyView.isHidden = true
        mainView.iconsTableView.isHidden = true
        mainView.errorView.isHidden = true
        mainView.loadingView.isHidden = false
        mainView.bringSubviewToFront(mainView.loadingView)
    }
    
    func hideLoading() {
        mainView.loadingView.isHidden = true
    }
    
    func showIcons() {
        if !Thread.isMainThread {
            print("🚨 [FATAL ERROR] showIcons вызван НЕ из главного потока!")
        }
        
        print("👀 [MainVC] Показываю таблицу и обновляю данные")
        
        mainView.loadingView.isHidden = true
        mainView.emptyView.isHidden = true
        mainView.errorView.isHidden = true
        mainView.iconsTableView.isHidden = false
        
        mainView.iconsTableView.tableView.reloadData()
        
        mainView.bringSubviewToFront(mainView.iconsTableView)
        scrollToTop()
    }
    
    func scrollToTop() {
        guard presenter.getIcons().count > 0 else { return }
        let indexPath = IndexPath(row: 0, section: 0)
        mainView.iconsTableView.tableView.scrollToRow(
            at: indexPath,
            at: .top,
            animated: true
        )
    }
    
    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension MainViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainView.setSearchMode(active: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let text = textField.text, !text.isEmpty {
            presenter.loadIcons(term: text)
        }
        
        return true
    }
}
