import UIKit

@objc protocol MainModuleRoutingLogic
{
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol MainModuleDataPassing {
  var dataStore: MainModuleDataStore? { get }
}

final class MainModuleRouter: NSObject, MainModuleRoutingLogic, MainModuleDataPassing {
  weak var viewController: MainModuleViewController?
  var dataStore: MainModuleDataStore?
  
  // MARK: Routing
  
  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation
  
  //func navigateToSomewhere(source: MainModuleViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}
  
  // MARK: Passing data
  
  //func passDataToSomewhere(source: MainModuleDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
