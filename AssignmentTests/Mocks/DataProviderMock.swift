//
//  DataProviderMock.swift
//  AssignmentTests
//
//  Created by Patrick Hogan on 17/12/2020.
//

import Foundation
import Alamofire
@testable import Assignment

class DataProviderMock: DataProviderProtocol {

	var simulatedResponse: Data?
	var simulatedError: CommonAPIError?
	var requestCalled = false
	var testError: Error = NSError(domain: "TEST_ERROR", code: 999, userInfo: nil)

	func request(with spec: RequestSpec, _ completionHandler: @escaping (Result<DataProviderResponse>) -> Void) {
		requestCalled = true
		if let error = simulatedError {
			completionHandler(Result.failure(error))
		} else if let data = simulatedResponse {
			let response = DataProviderResponse(data: data, response: nil)
			completionHandler(Result.success(response))
		} else {
			completionHandler(Result.failure(testError))
		}
	}

	static func loadMockJson(filename: String) -> Data? {
		if let filePath = Bundle(for: DataProviderMock.self).path(forResource: filename, ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
				return data
			} catch {
				print("** FAILED TO PARSE MOCK JSON: \(error) **")
			}
		}
		return nil
	}
}
