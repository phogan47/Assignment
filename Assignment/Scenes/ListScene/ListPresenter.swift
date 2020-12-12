import Foundation

protocol ListPresenterProtocol: class {
	func didGetList(response: ListResponse)
	func didFailToGetList(error: CommonAPIError)
}

class ListPresenter {

	private weak var view: ListViewProtocol?

	init(view: ListViewProtocol) {
		self.view = view
	}
}

extension ListPresenter: ListPresenterProtocol {
	func didGetList(response: ListResponse) {
		view?.displayList(
			ListViewObject(movies: response.results.map {
				Movie(
					movieId: $0.movieId,
					name: $0.title,
					thumbnail: $0.posterPath,
					rating: "\($0.rating)"
				)
			})
		)
	}

	func didFailToGetList(error: CommonAPIError) {
		view?.displayError(error: error)
		safeprint(error.localizedDescription)
	}
}

struct ListViewObject {
	let movies: [Movie]
}

struct Movie {
	let movieId: Int
	let name: String
	let thumbnail: String
	let rating: String
}

extension Movie {
	var thumbNailUrl: URL? {
		return URL(string: Config.imageBaseURL + thumbnail)
	}
}
