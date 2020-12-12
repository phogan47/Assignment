//
//  ListPresenterMock.swift
//  AssignmentTests
//
//  Created by Patrick Hogan on 17/12/2020.
//

import Foundation
@testable import Assignment

class ListPresenterMock: ListPresenterProtocol {

	var didGetListCalled = false
	var didFailToGetListCalled = false
	var listResponse: ListResponse?
	var error: CommonAPIError?
	
	func didGetList(response: ListResponse) {
		didGetListCalled = true
		listResponse = response
	}

	func didFailToGetList(error: CommonAPIError) {
		didFailToGetListCalled = true
		self.error = error
	}

}
