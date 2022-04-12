import UIKit

protocol DetailModuleBusinessLogic {
    func downloadImage(request: DetailModule.Detail.Request)
}

protocol DetailModuleDataStore {
    var image: UIImage { get set }
    var quote: Quote { get set }
}

final class DetailModuleInteractor: DetailModuleBusinessLogic, DetailModuleDataStore {
    var image: UIImage = .init()
    var quote: Quote = .init(author: "", text: "")
    
    var presenter: DetailModulePresentationLogic?
    var worker: DetailModuleWorker?

    func downloadImage(request: DetailModule.Detail.Request) {
        guard let presenter = presenter else { return }
        presenter.loading()
        
        worker = DetailModuleWorker()
        worker?.downloadImage(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                presenter.presentImage(response: response, quote: self.quote)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}
