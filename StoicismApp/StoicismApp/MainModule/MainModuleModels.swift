import UIKit

struct Quote: Decodable {
    let author: String
    let text: String
    
    enum CodingKeys: String, CodingKey {
        case author
        case text = "quote"
    }
}

enum MainModule {
  enum ShowQuote {
      struct Request {}

      struct Response: Decodable {
          let data: Quote
      }

      struct ViewModel {
          var quote: Quote
      }
  }
}
