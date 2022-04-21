@testable import StoicismApp
import XCTest

class DetailModuleInteractorTests: XCTestCase {
    private var sut: DetailModuleInteractor!
    private var worker: DetailModuleNetworkLogicSpy!
    private var presenter: DetailModulePresentationLogicSpy!
    
    override func setUp() {
        super.setUp()
        
        let quote = Quote(author: "Author", text: "Text")
        worker = DetailModuleNetworkLogicSpy()
        sut = DetailModuleInteractor(worker: worker)
        presenter = DetailModulePresentationLogicSpy()
        
        sut.quote = quote
        sut.worker = worker
        sut.presenter = presenter
    }
    
    func testSuccessResponse() {
        let image = UIImage()
        let response = DetailModule.Detail.Response(image: image)
        let result: (Result<DetailModule.Detail.Response, Error>) = .success(response)
        worker.response = result
        
        let request = DetailModule.Detail.Request(author: "")
        sut.downloadImage(request: request)
        XCTAssert(presenter.isLoading, "Presenter did not set state loading")
        XCTAssert(self.isEqualResponses(response, self.presenter.response),
                  "Wrong data")
        
    }
    
    func testFailureResponse() {
        let image = UIImage()
        let response = DetailModule.Detail.Response(image: image)
        let result: (Result<DetailModule.Detail.Response, Error>) = .failure(NetworkError.invalideURL)
        worker.response = result
        
        let request = DetailModule.Detail.Request(author: "")
        sut.downloadImage(request: request)
        XCTAssert(presenter.isLoading, "Presenter did not set state loading")
        XCTAssert(self.presenter.response == nil, "Data passed to presenter uncorrectly")
    }
    
    private func isEqualResponses(_ lhs: DetailModule.Detail.Response,
                                  _ rhs: DetailModule.Detail.Response) -> Bool {
        return lhs.image == rhs.image
    }
}

private class DetailModuleNetworkLogicSpy: DetailModuleNetworkLogic {
    var response: (Result<DetailModule.Detail.Response, Error>)!

    func downloadImage(request: DetailModule.Detail.Request, completion: @escaping (Result<DetailModule.Detail.Response, Error>) -> Void) {
        
        completion(self.response)
    }
    
    
}

private class DetailModulePresentationLogicSpy: DetailModulePresentationLogic {
    var isLoading = false
    var response: DetailModule.Detail.Response!

    func presentImage(response: DetailModule.Detail.Response, quote: Quote) {
        self.response = response
    }
    
    func loading() {
        isLoading = true
    }
}
