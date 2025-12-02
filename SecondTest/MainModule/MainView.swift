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
        let view = IconsTableView(presenter: presenter)
        view.isHidden = true
        return view
    }()
}
