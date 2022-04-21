import UIKit

struct ImageNetworkWorkerModel: Decodable {
    let imageName: String
    let results: [URL]
    
    enum CodingKeys: String, CodingKey {
        case imageName = "image_name"
        case results
    }
}

protocol DetailModuleNetworkLogic {
    func downloadImage(request: DetailModule.Detail.Request,
                       completion: @escaping(Result<DetailModule.Detail.Response, Error>) -> Void)
}

final class DetailModuleWorker: DetailModuleNetworkLogic {
    private enum Constant {
        static let urlString = "https://imsea.herokuapp.com/api/1?q="
    }
    
    static let shared = DetailModuleWorker()

    private var imageCache = NSCache<NSString, AnyObject>()
    
    func downloadImage(request: DetailModule.Detail.Request,
                       completion: @escaping(Result<DetailModule.Detail.Response, Error>) -> Void) {
        let endPoint = "stoicism \(request.author)"
        let urlString = Constant.urlString.appending(endPoint).replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalideURL))
            return
        }
        
        if let cachedImage = self.imageCache.object(forKey: urlString as NSString) as? UIImage {
            let response = DetailModule.Detail.Response(image: cachedImage)
            DispatchQueue.main.async {
                completion(.success(response))
            }
        } else {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                if let error = error {
                    completion(.failure(error))
                }
                
                guard let data = data else {
                    completion(.failure(NetworkError.dataNil))
                    return
                }
                
                do {
                    let dataImages = try JSONDecoder().decode(ImageNetworkWorkerModel.self, from: data)
                    if let imageURL = dataImages.results.first {
                        self.downloadImage(from: imageURL) { result in
                            switch result {
                            case .success(let image):
                                self.imageCache.setObject(image, forKey: urlString as NSString)
                                let response = DetailModule.Detail.Response(image: image)
                                completion(.success(response))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                            
                        }
                    } else {
                        completion(.failure(NetworkError.invalideURL))
                    }
                } catch {
                    completion(.failure(NetworkError.decodingError))
                }
            }
            
            task.resume()
        }
    }
    
    private func downloadImage(from url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.dataNil))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(NetworkError.imageCreatingError))
                return
            }
            
            completion(.success(image))
        }
        
        task.resume()
    }
}
