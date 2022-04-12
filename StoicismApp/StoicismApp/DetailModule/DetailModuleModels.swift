import UIKit

enum DetailModule {
    enum Detail {
        struct Request {
            let author: String
        }
        
        struct Response {
            let image: UIImage
        }
        
        struct ViewModel {
            let image: UIImage
            let quote: Quote
        }
    }
}
