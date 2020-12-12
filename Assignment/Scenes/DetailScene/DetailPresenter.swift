import Foundation

protocol DetailPresenterProtocol: class {
	func didGetDetails(response: MovieDetailResponse)
	func didFailToGetDetails(error: CommonAPIError)
}

class DetailPresenter {

	private weak var view: DetailViewProtocol?

	init(view: DetailViewProtocol) {
		self.view = view
	}
}

extension DetailPresenter: DetailPresenterProtocol {

	func didGetDetails(response: MovieDetailResponse) {
		let movieDetail = MovieDetail(
			movieId: response.movieId,
			name: response.title,
			overview: response.overview,
			posterPath: response.posterPath,
			backdropPath: response.backdropPath,
			releaseDate: response.releaseDate
		)
		view?.displayDetails(DetailViewObject(movieDetail: movieDetail))
	}

	func didFailToGetDetails(error: CommonAPIError) {
		view?.displayError(error: error)
		safeprint(error.localizedDescription)
	}
}

struct DetailViewObject {
	let movieDetail: MovieDetail
}

struct MovieDetail {
	let movieId: Int
	let name: String
	let overview: String
	let posterPath: String
	let backdropPath: String
	let releaseDate: String
}

extension MovieDetail {
	var posterUrl: URL? {
		return URL(string: Config.imageBaseURL + posterPath)
	}

	var backdropUrl: URL? {
		return URL(string: Config.imageBaseURL + backdropPath)
	}

	var releaseDateDisplayString: String {
		//TODO: Lets format this into something a bit nicer for the user
		return "In cinemas from: \(releaseDate)"
	}
}
