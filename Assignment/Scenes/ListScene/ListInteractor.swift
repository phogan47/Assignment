import Foundation
import Alamofire

protocol ListInteractorProtocol: class {
	func getLatest()
}

enum ParamKeys: String {
	case apiKey = "api_key"
}

class ListInteractor: ListInteractorProtocol {

	private let presenter: ListPresenterProtocol
	private let dataProvider: DataProviderProtocol

	init(presenter: ListPresenterProtocol, dataProvider: DataProviderProtocol = DataProvider()) {
		self.presenter = presenter
		self.dataProvider = dataProvider
	}

	func getLatest() {
		dataProvider.request(
			with: ListRequest(
				baseURL: Config.baseURL,
				params: [ParamKeys.apiKey.rawValue: Config.apiKey]
			)
		) { [weak self] result in
			switch result {
			case .success(let dataResponse):
				do {
					let listResponse = try JSONDecoder().decode(ListResponse.self, from: dataResponse.data)
					self?.presenter.didGetList(response: listResponse)
				} catch {
					self?.presenter.didFailToGetList(error: CommonAPIError.parseFailed(error))
				}
			case .failure(let error):
				self?.presenter.didFailToGetList(error: CommonAPIError.resolveError(error))
			}
		}
	}
}

struct ListRequest: RequestSpec {
	var baseURLString: String
	var path: String?
	var method: HTTPMethod = .get
	var headers: [String: String]?
	var params: [String: Any]?
	var parameterEncoding: ParameterEncoding = URLEncoding.default
	var allowOffline = true

	init(baseURL: String, params: [String: Any]) {
		baseURLString = baseURL
		self.params = params
		path = "3/movie/now_playing"
	}
}

struct ListResponse: Codable {
	let results: [MovieResponse]

	init(results: [MovieResponse]) {
		self.results = results
	}
}

struct MovieResponse: Codable {
	let movieId: Int
	let title: String
	let posterPath: String
	let rating: Double

	enum CodingKeys: String, CodingKey {
		case movieId = "id"
		case title = "original_title"
		case posterPath = "poster_path"
		case rating = "vote_average"
	}

	init(
		movieId: Int,
		title: String,
		posterPath: String,
		rating: Double
	) {
		self.movieId = movieId
		self.title = title
		self.posterPath = posterPath
		self.rating = rating
	}

}
