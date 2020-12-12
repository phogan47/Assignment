//
//  AssignmentUITests.swift
//  AssignmentUITests
//
//  Created by Patrick Hogan on 18/11/2020.
//

import TABTestKit

class AssignmentUITests: TABTestCase {

	private let listScreen = ListScreen()
	private let movieDetailScreen = DetailScreen()

	override func preLaunchSetup(_ launch: @escaping () -> Void) {
		launch()
	}

	func testListHappyPath() {
		Scenario("I want to run the app and see a list of") {
			Given(I: see(listScreen))
			And(the: state(of: listScreen.movieList, is: .exists))
		}

		Scenario("When I tap on the last movie in the list I want to see details about that movie") {
			Given(I: see(listScreen))
			And(the: state(of: listScreen.movieList, is: .exists))
			And(I: scroll(listScreen.movieList, .downwards, until: listScreen.lastCell, is: .visible))
			When(I: tap(listScreen.lastCell))
			Then(I: see(movieDetailScreen))
		}

	}

}
