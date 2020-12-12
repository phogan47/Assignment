import Foundation
import Alamofire

protocol DataProviderProtocol {
	func request(with spec: RequestSpec, _ completionHandler: @escaping (Result<DataProviderResponse>) -> Void)
}

struct DataProviderResponse {
	public let data: Data
	public let response: URLResponse?

	public init(data: Data, response: URLResponse?) {
		self.data = data
		self.response = response
	}
}

protocol RequestSpec {

	var baseURLString: String { get }
	var path: String? { get }
	var method: HTTPMethod { get }
	var headers: [String: String]? { get }
	var params: [String: Any]? { get }
	var parameterEncoding: ParameterEncoding { get }
}

extension RequestSpec {

	var url: String {
		var localString = self.baseURLString
		localString.append(self.path ?? "")
		return localString
	}
}

class DataProvider: DataProviderProtocol {

	enum Error: Swift.Error {
		case noDataReceived
	}

	func request(with spec: RequestSpec, _ completionHandler: @escaping (Result<DataProviderResponse>) -> Void) {
		APIManager.sharedManager.request(spec.url, method: spec.method, parameters: spec.params, encoding: spec.parameterEncoding, headers: spec.headers)
			.validate()
			.responseJSON { (response) in
				switch response.result {
				case .success:
					if let error = response.error { completionHandler(.failure(error)); return }
					guard let data = response.data else {
						completionHandler(.failure(Error.noDataReceived))
						return
					}
					completionHandler(.success(DataProviderResponse(data: data, response: response.response)))
				case .failure(let error):
					completionHandler(Result.failure(error))
				}
			}
	}

}

extension DataProvider {

	static func getMethod(stringMethod: String?) -> HTTPMethod {
		guard let method = HTTPMethod(rawValue: (stringMethod ?? "get").uppercased()) else {
			return .get
		}
		return method
	}
}

private class APIManager: Alamofire.SessionManager {

	static let sharedManager: SessionManager = {
		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForRequest = 30
		configuration.timeoutIntervalForResource = 30
		let manager = Alamofire.SessionManager(configuration: configuration, delegate: SessionManager.default.delegate)
		return manager
	}()

	override init(configuration: URLSessionConfiguration, delegate: SessionDelegate, serverTrustPolicyManager: ServerTrustPolicyManager? = nil) {
		super.init(configuration: configuration, delegate: delegate, serverTrustPolicyManager: serverTrustPolicyManager)
	}

	required public init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

enum CommonAPIError: Error, Equatable {
	case parseResponseFailed(_ error: Error)
	case backendFailure(_ error: Error)
	case connectionFailed
	case requestTimedOut
	case invalidRequest
	case unknown

	static func parseFailed(_ error: Error) -> CommonAPIError {
		safeprint("PARSING ERROR: \(String(describing: error))")
		return CommonAPIError.parseResponseFailed(error)
	}

	static func resolveError(_ error: Error) -> CommonAPIError {
		safeprint(error.localizedDescription)
		switch (error as NSError).code {
		case NSURLErrorCannotConnectToHost,
			 NSURLErrorCannotFindHost,
			 NSURLErrorNetworkConnectionLost,
			 NSURLErrorSecureConnectionFailed,
			 NSURLErrorNotConnectedToInternet:
			return .connectionFailed
		case NSURLErrorTimedOut:
			return .requestTimedOut
		default:
			if (error as? CommonAPIError) == invalidRequest {
				return .invalidRequest
			} else {
				return backendFailure(error)
			}
		}
	}

	static func == (lhs: CommonAPIError, rhs: CommonAPIError) -> Bool {
		switch (lhs, rhs) {
		case let (.backendFailure(errorA), .backendFailure(errorB)):
			return (errorA as NSError).code  == (errorB as NSError).code
		case (.parseResponseFailed, .parseResponseFailed):
			return true
		default:
			return (lhs as NSError).code == (rhs as NSError).code
		}
	}
}
