import UIKit

@objc protocol MainModuleRoutingLogic {
    func routeToDetail()
}

protocol MainModuleDataPassing {
  var dataStore: MainModuleDataStore? { get }
}

final class MainModuleRouter: NSObject, MainModuleRoutingLogic, MainModuleDataPassing {
  weak var viewController: MainModuleViewController?
  var dataStore: MainModuleDataStore?
  
    func routeToDetail() {
        guard let quote = dataStore?.quote else { return }
        let detailViewController = DetailModuleViewController()
        guard var destinationDataStore = detailViewController.router?.dataStore else { return }
        destinationDataStore.quote = quote
        print(detailViewController)
        viewController?.present(detailViewController, animated: true)
    }
}
