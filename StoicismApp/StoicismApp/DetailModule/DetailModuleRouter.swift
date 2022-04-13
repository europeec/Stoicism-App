import UIKit

@objc protocol DetailModuleRoutingLogic {
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol DetailModuleDataPassing {
  var dataStore: DetailModuleDataStore? { get }
}

final class DetailModuleRouter: NSObject, DetailModuleRoutingLogic, DetailModuleDataPassing {
  weak var viewController: DetailModuleViewController?
  var dataStore: DetailModuleDataStore?
  
}
