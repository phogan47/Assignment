//
//  ListSceneInteractorTests.swift
//  AssignmentTests
//
//  Created by Patrick Hogan on 17/12/2020.
//

import XCTest
@testable import Assignment

class ListScenePresenterTests: XCTestCase {

	private var mockView: ListViewMock!
	private var presenter: ListPresenterProtocol!

	override func setUpWithError() throws {
		super.setUp()
		mockView = ListViewMock()
		presenter = ListPresenter(view: mockView)
	}

	override func tearDownWithError() throws {
		mockView = nil
		presenter = nil
		super.tearDown()
	}

	func testDidGetList() throws {
		let dummyResponse = ListResponse(results: [MovieResponse(movieId: 1, title: "", posterPath: "", rating: 3.4)])
		presenter.didGetList(response: dummyResponse)
		XCTAssertTrue(mockView.displayListCalled)
	}

	func testDidFailToGetList() {
		presenter.didFailToGetList(error: CommonAPIError.connectionFailed)
		XCTAssertTrue(mockView.displayErrorCalled)
	}

}
