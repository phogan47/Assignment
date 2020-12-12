//
//  ListViewMock.swift
//  AssignmentTests
//
//  Created by Patrick Hogan on 17/12/2020.
//

import Foundation

@testable import Assignment

class ListViewMock: ListViewProtocol {

	var displayListCalled = false
	var displayErrorCalled = false

	func displayList(_ viewObject: ListViewObject) {
		displayListCalled = true
	}

	func displayError(error: CommonAPIError) {
		displayErrorCalled = true
	}

}
