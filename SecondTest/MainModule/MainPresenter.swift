//
//  MainPresenter.swift
//  SecondTest
//
//  Created by Адлет Жумагалиев on 25.11.2025.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    var isLoading: Bool { get }
    var isEmpty: Bool { get }
    func loadIcons(term: String)
    func stopLoadingIcons()
    func didSelectIcon(at index: Int)
    func getIcons() -> [IconModel]
}

final class MainPresenter: MainPresenterProtocol {
    var isLoading: Bool = false
    var isEmpty: Bool = true
    private var icons: [IconModel] = []
    
    weak var view: MainViewProtocol?
    
    private let service: IconServiceProtocol
    
    init(service: IconServiceProtocol) {
        self.service = service
    }
    
    func loadIcons(term: String) {
        guard !term.isEmpty else {
            self.icons = []
            self.isEmpty = true
            view?.showEmpty(text: "Start searching icons")
            return
        }
        
        isLoading = true
        view?.showLoading()
        
        let request = IconRequest(term: term)
        
        service.fetchIcons(request: request) { [weak self] result in
            guard let self = self else { return }
            
            self.isLoading = false
            self.view?.hideLoading()
            
            switch result {
            case .success(let icons):
                self.icons = icons
                self.isEmpty = icons.isEmpty
                
                if self.isEmpty {
                    self.view?.showEmpty(text: "No Icons found")
                } else {
                    self.view?.showIcons()
                }
                
            case .failure(let error):
                print("Error: \(error)")
                self.view?.showIcons()
            }
        }
    }
    
    func stopLoadingIcons() {
        
    }
    
    func didSelectIcon(at index: Int) {
        // TODO: - Метод для скачивания иконки
    }
    
    func getIcons() -> [IconModel] {
        return self.icons
    }
}
