import UIKit

final class MainFactory {
    func make() -> UIViewController {
        let host = "api.freepik.com"
        let networkClient = NetworkClient(host: host, token: Secrets.apiKey)
        let service = IconService(networkClient: networkClient)
        
        let imageDownloadService = ImageDownloadService()
        let photoLibraryService = PhotoLibraryService()
        let iconSaveService = IconSaveService(
            imageDownloadService: imageDownloadService,
            photoLibraryService: photoLibraryService
        )
        
        let executor = CancellableExecutor()
        
        let presenter = MainPresenter(
            service: service,
            iconSaveService: iconSaveService,
            executor: executor
        )
        
        let vc = MainViewController(presenter: presenter)
        presenter.view = vc
        
        return vc
    }
}
