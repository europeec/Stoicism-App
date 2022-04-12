import UIKit

final class QuoteView: UIView {
    private enum Constant {
        static let authorFontSize: CGFloat = 12
        static let quoteImageViewSide: CGFloat = 15
        static let padding: CGFloat = 7
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

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
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
            openQuote.leadingAnchor.constraint(equalTo: leadingAnchor),
            openQuote.topAnchor.constraint(equalTo: topAnchor),
            openQuote.widthAnchor.constraint(equalToConstant: Constant.quoteImageViewSide),
            
            textLabel.leadingAnchor.constraint(equalTo: openQuote.trailingAnchor, constant: Constant.padding),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constant.padding),
            
            closedQuote.bottomAnchor.constraint(equalTo: bottomAnchor),
            closedQuote.trailingAnchor.constraint(equalTo: trailingAnchor),
            closedQuote.widthAnchor.constraint(equalToConstant: Constant.quoteImageViewSide),
            
            authorLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            authorLabel.trailingAnchor.constraint(equalTo: closedQuote.leadingAnchor, constant: -Constant.padding),
            authorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constant.padding)
        ])
    }
    
    func displayQuote(_ quote: Quote) {
        authorLabel.text = quote.author
        textLabel.text = quote.text
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
