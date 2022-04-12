import UIKit

protocol DetailModulePresentationLogic {
    func presentImage(response: DetailModule.Detail.Response, quote: Quote)
    func loading()
}

final class DetailModulePresenter: DetailModulePresentationLogic {
    weak var viewController: DetailModuleDisplayLogic?
    
    // MARK: Do something
    
    func presentImage(response: DetailModule.Detail.Response, quote: Quote) {
        let image = response.image
        let viewModel = DetailModule.Detail.ViewModel(image: image, quote: quote)
        viewController?.display(viewModel: viewModel)
    }
    
    func loading() {
        viewController?.loading()
    }
}
