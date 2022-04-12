import UIKit

protocol MainModuleBusinessLogic {
    func getQuote(request: MainModule.ShowQuote.Request)
}

protocol MainModuleDataStore {
    
}

final class MainModuleInteractor: MainModuleBusinessLogic, MainModuleDataStore {
    var presenter: MainModulePresentationLogic?
    var worker: MainModuleWorker?
  
    func getQuote(request: MainModule.ShowQuote.Request) {
        worker = MainModuleWorker()
        worker?.getQuoute { [weak self] result in
            switch result {
            case .success(let quoteResponse):
                self?.presenter?.presentQuote(response: quoteResponse)
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
  }
}
