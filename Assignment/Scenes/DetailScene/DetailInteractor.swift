import Foundation
import Alamofire

protocol DetailInteractorProtocol: class {
	func getDetails()
}

class DetailInteractor: DetailInteractorProtocol, DetailDataStoreProtocol {

	private let presenter: DetailPresenterProtocol
	private let dataProvider: DataProviderProtocol
	var movieId: Int?

	init(presenter: DetailPresenterProtocol, dataProvider: DataProviderProtocol = DataProvider()) {
		self.presenter = presenter
		self.dataProvider = dataProvider
	}

	func getDetails() {

		guard let movieId = self.movieId else {
			presenter.didFailToGetDetails(error: CommonAPIError.invalidRequest)
			return
		}

		dataProvider.request(
			with: DetailRequest(
				baseURL: Config.baseURL,
				movieId: movieId,
				queryParams: [ParamKeys.apiKey.rawValue: Config.apiKey]
			)
		) { [weak self] result in
			switch result {
			case .success(let dataResponse):
				do {
					let detailResponse = try JSONDecoder().decode(MovieDetailResponse.self, from: dataResponse.data)
					self?.presenter.didGetDetails(response: detailResponse)
				} catch {
					self?.presenter.didFailToGetDetails(error: CommonAPIError.parseFailed(error))
				}
			case .failure(let error):
				self?.presenter.didFailToGetDetails(error: CommonAPIError.resolveError(error))
			}
		}
	}
}

struct DetailRequest: RequestSpec {
	var baseURLString: String
	var path: String?
	var method: HTTPMethod = .get
	var headers: [String: String]?
	var params: [String: Any]?
	var parameterEncoding: ParameterEncoding = URLEncoding.default
	var allowOffline = true

	init(baseURL: String, movieId: Int, queryParams: [String: Any]) {
		baseURLString = baseURL
		self.params = queryParams
		path = "3/movie/\(movieId)"
	}
}

struct MovieDetailResponse: Codable {
	let movieId: Int
	let title: String
	let posterPath: String
	let backdropPath: String
	let overview: String
	let releaseDate: String
	let runtime: Int

	enum CodingKeys: String, CodingKey {
		case title, overview, runtime
		case movieId = "id"
		case posterPath = "poster_path"
		case backdropPath = "backdrop_path"
		case releaseDate = "release_date"
	}
}
