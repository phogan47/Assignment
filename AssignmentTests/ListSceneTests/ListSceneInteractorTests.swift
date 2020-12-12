//
//  ListSceneInteractorTests.swift
//  AssignmentTests
//
//  Created by Patrick Hogan on 17/12/2020.
//

import XCTest
@testable import Assignment

class ListSceneInteractorTests: XCTestCase {

	private var mockPresenter: ListPresenterMock!
	private var mockDataProvider: DataProviderMock!
	private var interactor: ListInteractor!

    override func setUpWithError() throws {
		super.setUp()
		mockPresenter = ListPresenterMock()
		mockDataProvider = DataProviderMock()
		interactor = ListInteractor(presenter: mockPresenter, dataProvider: mockDataProvider)
    }

    override func tearDownWithError() throws {
		mockPresenter = nil
		interactor = nil
		mockDataProvider = nil
		super.tearDown()
    }

    func testGetLatestSuccess() throws {
		mockDataProvider.simulatedResponse = DataProviderMock.loadMockJson(filename: "latestMovies")
		interactor.getLatest()
		XCTAssertTrue(mockDataProvider.requestCalled, "Data provider not called")
		XCTAssertTrue(mockPresenter.didGetListCalled, "Failed to call presenter after successfully retrieving data")
		XCTAssertEqual(mockPresenter.listResponse?.results.count, 20, "Incorrect number of movies returned")
    }

	func testGetLatestErrorMakingRequest() throws {
		mockDataProvider.simulatedError = CommonAPIError.invalidRequest
		interactor.getLatest()
		XCTAssertTrue(mockDataProvider.requestCalled, "Data provider not called")
		XCTAssertFalse(mockPresenter.didGetListCalled, "Presenter happy path should not be called after after error retrieving data")
		XCTAssertTrue(mockPresenter.didFailToGetListCalled, "Presenter error handling failed to get called after error retrieving data")
		XCTAssertEqual(mockPresenter.error, CommonAPIError.invalidRequest)
	}

	func testGetLatestErrorParsingResponse() throws {
		mockDataProvider.simulatedResponse = DataProviderMock.loadMockJson(filename: "latestMoviesINVALID")
		interactor.getLatest()
		XCTAssertTrue(mockDataProvider.requestCalled, "Data provider not called")
		XCTAssertFalse(mockPresenter.didGetListCalled, "Presenter happy path should not be called after after error retrieving data")
		XCTAssertTrue(mockPresenter.didFailToGetListCalled, "Presenter error handling failed to get called after error retrieving data")
	}

}
