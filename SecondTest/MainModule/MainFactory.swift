//
//  MainFactory.swift
//  SecondTest
//
//  Created by Адлет Жумагалиев on 25.11.2025.
//

import UIKit

final class MainFactory {
    func make() -> UIViewController {
        let host = "https://api.freepik.com"
        let networkClient = NetworkClient(host: host)
        let service = IconService(networkClient: networkClient)
        
        let presenter = MainPresenter(service: service)
        
        let vc = MainViewController(presenter: presenter)
        
        return vc
    }
}
