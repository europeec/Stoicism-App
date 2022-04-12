import UIKit

protocol MainModuleDisplayLogic: AnyObject {
    func displayQuote(viewModel: MainModule.ShowQuote.ViewModel)
}

final class MainModuleViewController: UIViewController, MainModuleDisplayLogic {
    private enum Constant {
        static let paddingQuote: CGFloat = 15
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    var interactor: MainModuleBusinessLogic?
    var router: (NSObjectProtocol & MainModuleRoutingLogic & MainModuleDataPassing)?
    
    private lazy var quoteView = QuoteView()
    
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
        
        view.backgroundColor = .systemBackground
        view.addSubview(quoteView)
        
        let tapRegocginzer = UITapGestureRecognizer(target: self, action: #selector(tappedOnView))
        view.addGestureRecognizer(tapRegocginzer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            quoteView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quoteView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            quoteView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                             constant: -2 * Constant.paddingQuote)
        ])
    }
    
    private func getQuote() {
        let request = MainModule.ShowQuote.Request()
        interactor?.getQuote(request: request)
    }
    
    func displayQuote(viewModel: MainModule.ShowQuote.ViewModel) {
        let quote = viewModel.quote
        quoteView.displayQuote(quote)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake {
            getQuote()
        }
    }
    
    @objc private func tappedOnView() {
        router?.routeToDetail()
    }
}
