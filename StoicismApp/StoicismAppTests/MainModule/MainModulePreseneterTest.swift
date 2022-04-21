@testable import StoicismApp
import XCTest

class MainModulePreseneterTest: XCTestCase {
    private var sut: MainModulePresenter!
    private var view: MainModuleDisplayLogicSpy!
    
    override func setUp() {
        super.setUp()
        sut = MainModulePresenter()
        view = MainModuleDisplayLogicSpy()
        sut.viewController = view
    }
    
    func testPresentingQuote() {
        let quote = Quote(author: "Author", text: "Text")
        let response = MainModule.ShowQuote.Response(data: quote)
        
        sut.presentQuote(response: response)
        XCTAssert(view.isMainThread, "View on non-main thread")
        XCTAssert(view.viewModel != nil, "View model didn`t passed to view")
        XCTAssert(isEqual(viewModel: view.viewModel,
                          response: response), "Wrong mapping")
    }
    
    private func isEqual(viewModel: MainModule.ShowQuote.ViewModel,
                    response: MainModule.ShowQuote.Response) -> Bool {
        return viewModel.quote.author == response.data.author
               && viewModel.quote.text == response.data.text
    }
}

private class MainModuleDisplayLogicSpy: MainModuleDisplayLogic {
    var viewModel: MainModule.ShowQuote.ViewModel!
    var isMainThread: Bool!
    
    func displayQuote(viewModel: MainModule.ShowQuote.ViewModel) {
        self.viewModel = viewModel
        self.isMainThread = Thread.isMainThread
    }
}
