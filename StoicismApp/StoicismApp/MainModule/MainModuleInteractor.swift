import UIKit

protocol MainModuleBusinessLogic {
    func getQuote(request: MainModule.ShowQuote.Request)
}

protocol MainModuleDataStore: AnyObject {
    var quote: Quote { get set }
}

final class MainModuleInteractor: MainModuleBusinessLogic, MainModuleDataStore {
    var quote = Quote(author: "", text: "")
    
    var presenter: MainModulePresentationLogic?
    var worker: MainModuleNetworkLogic?
  
    func getQuote(request: MainModule.ShowQuote.Request) {
        worker?.getQuoute { [weak self] result in
            switch result {
            case .success(let quoteResponse):
                self?.quote = quoteResponse.data
                self?.presenter?.presentQuote(response: quoteResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
  }
}
