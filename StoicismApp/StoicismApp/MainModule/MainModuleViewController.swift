import UIKit

protocol MainModuleDisplayLogic: AnyObject {
    func displayQuote(viewModel: MainModule.ShowQuote.ViewModel)
}

final class MainModuleViewController: UIViewController, MainModuleDisplayLogic {
    private enum Constant {
        static let paddingQuote: CGFloat = 15
    }
    
    var interactor: MainModuleBusinessLogic?
    var router: (NSObjectProtocol & MainModuleRoutingLogic & MainModuleDataPassing)?
    
    private lazy var quoteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = MainModuleInteractor()
        let presenter = MainModulePresenter()
        let router = MainModuleRouter()
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
        getQuote()
        
        view.addSubview(quoteLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            quoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quoteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            quoteLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -2 * Constant.paddingQuote)
        ])
    }
        
    private func getQuote() {
        let request = MainModule.ShowQuote.Request()
        interactor?.getQuote(request: request)
    }
    
    func displayQuote(viewModel: MainModule.ShowQuote.ViewModel) {
        let quote = viewModel.quote
        let author = quote.author
        let text = quote.text
        
        DispatchQueue.main.async {
            self.quoteLabel.text = author + " " + text
        }
    }
}
