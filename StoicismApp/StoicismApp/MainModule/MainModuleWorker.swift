import UIKit

protocol MainModuleNetworkLogic {
    func getQuoute(completion: @escaping (Result<MainModule.ShowQuote.Response, Error>) -> Void)
}

final class MainModuleWorker: MainModuleNetworkLogic {
    private enum Constant {
        static let urlString = "https://api.themotivate365.com/stoic-quote"
    }

    func getQuoute(completion: @escaping (Result<MainModule.ShowQuote.Response, Error>) -> Void) {
        guard let url = URL(string: Constant.urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                    return
                }
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.dataNil))
                }

                return
            }
            
            do {
                let response = try JSONDecoder().decode(MainModule.ShowQuote.Response.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response))
                    return
                }
            } catch {
                completion(.failure(NetworkError.decodingError))
            }
        }
        
        task.resume()
  }
}
