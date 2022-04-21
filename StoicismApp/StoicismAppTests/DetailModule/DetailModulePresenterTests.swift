@testable import StoicismApp
import XCTest

class DetailModulePresenterTests: XCTestCase {
    private var sut: DetailModulePresenter!
    private var view: DetailModuleDisplayLogicSpy!
    
    override func setUp() {
        super.setUp()
        
        sut = DetailModulePresenter()
        view = DetailModuleDisplayLogicSpy()
        sut.viewController = view
    }
    
    func testPresenImage() {
        let image = UIImage()
        let response = DetailModule.Detail.Response(image: image)
        let quote = Quote(author: "Author", text: "Text")
        sut.presentImage(response: response, quote: quote)
        
        XCTAssert(view.isDisplaing, "View did not displaing")
    }
    
    func testViewLoading() {
        sut.loading()
        XCTAssert(view.isLoading, "View did not set state loading")
    }
}

private class DetailModuleDisplayLogicSpy: DetailModuleDisplayLogic {
    var isLoading = false
    var isDisplaing = false
    
    func display(viewModel: DetailModule.Detail.ViewModel) {
        isDisplaing = true
    }
    
    func loading() {
        isLoading = true
    }
}
