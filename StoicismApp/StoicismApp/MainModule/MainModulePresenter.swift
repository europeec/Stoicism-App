import UIKit

protocol MainModulePresentationLogic {
    func presentQuote(response: MainModule.ShowQuote.Response.QuoteResponse)
}

final class MainModulePresenter: MainModulePresentationLogic {
    weak var viewController: MainModuleDisplayLogic?
  
    func presentQuote(response: MainModule.ShowQuote.Response.QuoteResponse) {
        let quote = response.data
        let viewModel = MainModule.ShowQuote.ViewModel(quote: quote)
        
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayQuote(viewModel: viewModel)
        }
    }
}
