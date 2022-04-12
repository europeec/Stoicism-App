import UIKit

enum NetworkError: Error {
    case dataNil, decodingError
}

final class MainModuleWorker {
    private enum Constant {
        static let urlString = "https://api.themotivate365.com/stoic-quote"
    }

    func getQuoute(completion: @escaping (Result<MainModule.ShowQuote.Response.QuoteResponse, Error>) -> Void) {
        guard let url = URL(string: Constant.urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.dataNil))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(MainModule.ShowQuote.Response.QuoteResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }
        
        task.resume()
  }
}
