import UIKit

protocol DetailModulePresentationLogic {
    func presentImage(response: DetailModule.Detail.Response, quote: Quote)
    func loading()
}

final class DetailModulePresenter: DetailModulePresentationLogic {
    weak var viewController: DetailModuleDisplayLogic?
    
    func presentImage(response: DetailModule.Detail.Response, quote: Quote) {
        DispatchQueue.main.async { [weak self] in
            let image = response.image
            let viewModel = DetailModule.Detail.ViewModel(image: image, quote: quote)
            self?.viewController?.display(viewModel: viewModel)
        }
    }
    
    func loading() {
        viewController?.loading()
    }
}
