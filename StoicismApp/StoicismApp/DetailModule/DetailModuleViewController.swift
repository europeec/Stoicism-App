import UIKit

protocol DetailModuleDisplayLogic: AnyObject {
    func display(viewModel: DetailModule.Detail.ViewModel)
    func loading()
}

final class DetailModuleViewController: UIViewController, DetailModuleDisplayLogic {
    var interactor: DetailModuleBusinessLogic?
    var router: (NSObjectProtocol & DetailModuleRoutingLogic & DetailModuleDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = DetailModuleInteractor()
        let presenter = DetailModulePresenter()
        let router = DetailModuleRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage()
    }
    
    
    func getImage() {
        let author = router?.dataStore?.quote.author ?? ""
        let request = DetailModule.Detail.Request(author: author)
        interactor?.downloadImage(request: request)
    }
    
    func display(viewModel: DetailModule.Detail.ViewModel) {
        print(viewModel)
    }
    
    func loading() {
        
    }
}
