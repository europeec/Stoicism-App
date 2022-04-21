import UIKit

protocol DetailModuleDisplayLogic: AnyObject {
    func display(viewModel: DetailModule.Detail.ViewModel)
    func loading()
}

final class DetailModuleViewController: UIViewController, DetailModuleDisplayLogic {
    private enum Constant {
        static let padding: CGFloat = 10
        static let imageCornerRaduis: CGFloat = 20
    }

    var interactor: DetailModuleBusinessLogic?
    var router: (NSObjectProtocol & DetailModuleRoutingLogic & DetailModuleDataPassing)?
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleToFill
        imageView.addSubview(blurredView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterialDark))
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var quoteView = QuoteView()
    
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
        let worker = DetailModuleWorker.shared
        let interactor = DetailModuleInteractor(worker: worker)
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
        
        view.backgroundColor = .clear
        view.addSubview(backgroundImageView)
        view.addSubview(imageView)
        view.addSubview(quoteView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor,
                                               constant: Constant.padding),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                constant: -Constant.padding),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: Constant.padding),
            imageView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -Constant.padding),

            quoteView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor,
                                             constant: -4 * Constant.padding)
            
        ])
        
        backgroundImageView.frame = view.bounds
        blurredView.frame = backgroundImageView.frame
        imageView.center = view.center
        quoteView.center = view.center
    }
    
    
    func getImage() {
        let author = router?.dataStore?.quote.author ?? ""
        let request = DetailModule.Detail.Request(author: author)
        interactor?.downloadImage(request: request)
    }
    
    func display(viewModel: DetailModule.Detail.ViewModel) {
        let image = viewModel.image
        let quote = viewModel.quote
        
        let isDark = image.isDark
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.blurredView.effect = UIBlurEffect(style: isDark ? .systemMaterialDark : .systemMaterialLight)
            self.backgroundImageView.image = image
            self.imageView.image = image
            self.quoteView.displayQuote(quote, blurredBackground: true)
        }
    }
    
    func loading() {
        
    }
}
