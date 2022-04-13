import UIKit

final class QuoteView: UIView {
    private enum Constant {
        static let authorFontSize: CGFloat = 12
        static let quoteImageViewSide: CGFloat = 15
        static let padding: CGFloat = 7
        static let cornerRadius: CGFloat = 10
    }

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: Constant.authorFontSize)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var openQuote = makeImageView(systemName: "quote.opening")
    private lazy var closedQuote = makeImageView(systemName: "quote.closing")

    private lazy var blurBackgroundView: UIView = {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        blur.layer.cornerRadius = Constant.cornerRadius
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.isHidden = true
        blur.clipsToBounds = true
        return blur
    }()

    private var blurredBackground = false
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .clear
        addSubview(blurBackgroundView)
        addSubview(textLabel)
        addSubview(authorLabel)
        addSubview(openQuote)
        addSubview(closedQuote)
        
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        return nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            openQuote.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.padding),
            openQuote.topAnchor.constraint(equalTo: topAnchor, constant: Constant.padding),
            openQuote.widthAnchor.constraint(equalToConstant: Constant.quoteImageViewSide),
            
            textLabel.leadingAnchor.constraint(equalTo: openQuote.trailingAnchor, constant: Constant.padding),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.padding),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constant.padding),
            
            closedQuote.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.padding),
            closedQuote.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constant.padding),
            closedQuote.widthAnchor.constraint(equalToConstant: Constant.quoteImageViewSide),
            
            authorLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: closedQuote.leadingAnchor, constant: -Constant.padding),
            authorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.padding)
        ])
        
        blurBackgroundView.frame = bounds
    }
    
    func displayQuote(_ quote: Quote, blurredBackground blurred: Bool = false) {
        authorLabel.text = quote.author
        textLabel.text = quote.text
        blurBackgroundView.isHidden = !blurred
    }

    private func makeImageView(systemName: String) -> UIImageView {
        let image = UIImage(systemName: systemName)
        let imageView = UIImageView(image: image)
        imageView.frame.size = CGSize(width: Constant.quoteImageViewSide, height: Constant.quoteImageViewSide)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
