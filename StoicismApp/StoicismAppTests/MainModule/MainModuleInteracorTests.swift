@testable import StoicismApp
import XCTest

class MainModuleInteracorTests: XCTestCase {
    private var sut: (MainModuleInteractor & MainModuleDataStore)!
    private var worker: MainModuleWorkerSpy!
    private var presenter: MainModulePresenterSpy!

    override func setUp() {
        super.setUp()
        print("setup")

        sut = MainModuleInteractor()
        worker = MainModuleWorkerSpy()
        presenter = MainModulePresenterSpy()
        sut.worker = worker
        sut.presenter = presenter
    }
    
    func testSuccessGetQuote() {
        let quote = Quote(author: "Author", text: "Text")
        let response = MainModule.ShowQuote.Response(data: quote)
    
        let result: Result<MainModule.ShowQuote.Response, Error> = .success(response)
        worker.result = result
        sut.getQuote(request: MainModule.ShowQuote.Request())
        XCTAssert(presenter.response != nil, "Data didn`t passed to presenter")
    }
    
    func testFailureGetQuote() {
        let result: Result<MainModule.ShowQuote.Response, Error> = .failure(NetworkError.invalideURL)
        worker.result = result
        sut.getQuote(request: MainModule.ShowQuote.Request())
        
        XCTAssert(presenter.response == nil, "Data passed to presenter uncorrectly")
    }
}

// MARK: Mocks

private class MainModuleWorkerSpy: MainModuleNetworkLogic {
    var result: Result<MainModule.ShowQuote.Response, Error>!
    
    func getQuoute(completion: @escaping (Result<MainModule.ShowQuote.Response, Error>) -> Void) {
        completion(result)
    }
}

private class MainModulePresenterSpy: MainModulePresentationLogic {
    var response: MainModule.ShowQuote.Response?
    
    func presentQuote(response: MainModule.ShowQuote.Response) {
        self.response = response
    }
}

