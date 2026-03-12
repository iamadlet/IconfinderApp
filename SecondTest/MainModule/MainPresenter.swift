import Foundation

protocol MainPresenterProtocol: AnyObject {
    var isEmpty: Bool { get }
    func loadIcons(term: String)
    func stopLoadingIcons()
    func didSelectIcon(at index: Int)
    func getIcons() -> [IconModel]
    func icon(at index: Int) -> IconModel
}

final class MainPresenter: MainPresenterProtocol {
    var isEmpty: Bool = true
    private var icons: [IconModel] = []
    
    weak var view: MainViewProtocol?
    
    var numberOfIcons: Int {
        icons.count
    }
    
    private let service: IconServiceProtocol
    private let iconSaveService: IconSaveServiceProtocol
    private let executor: CancellableExecutorProtocol
    
    init(service: IconServiceProtocol, iconSaveService: IconSaveServiceProtocol, executor: CancellableExecutorProtocol) {
        self.service = service
        self.iconSaveService = iconSaveService
        self.executor = executor
    }
    
    private func performLoadIcons(term: String) {
        guard !term.isEmpty else {
            DispatchQueue.main.async {
                self.icons = []
                self.isEmpty = true
                self.view?.showEmpty(text: "Start searching icons")
            }
            return
        }
        
        DispatchQueue.main.async {
            self.view?.showLoading()
        }
        
        let request = IconRequest(term: term)
        
        service.fetchIcons(request: request) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let icons):
                    self.icons = icons
                    self.isEmpty = icons.isEmpty
                    
                    if icons.isEmpty {
                        self.view?.showEmpty(text: "No icons found")
                    } else {
                        self.view?.showIcons()
                    }
                    
                case .failure(let error):
                    print("Error: \(error)")
                    self.view?.showError()
                }
            }
        }
    }
    
    func loadIcons(term: String) {
        executor.execute(delay: .milliseconds(400)) { [weak self] token in
            guard let self = self else { return }
            guard !token.isCancelled else { return }
            
            self.performLoadIcons(term: term)
        }
    }
    
    func stopLoadingIcons() {
        executor.cancel()
    }
    
    func didSelectIcon(at index: Int) {
        let icon = icons[index]
        
        iconSaveService.saveIcon(from: icon.imageURL) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success:
                    self.view?.showMessage(title: "Success", message: "Icon saved to photos")
                case .failure(let error):
                    switch error {
                    case .accessDenied:
                        self.view?.showMessage(title: "Access denied", message: "Allow access to photos in settings")
                    case .downloadFailed:
                        self.view?.showMessage(title: "Error", message: "Failed to download icon")
                    case .saveFailed:
                        self.view?.showMessage(title: "Error", message: "Failed to save icon")
                    }
                }
            }
        }
    }
    
    func getIcons() -> [IconModel] {
        return self.icons
    }
    
    func icon(at index: Int) -> IconModel {
        return self.icons[index]
    }
}
