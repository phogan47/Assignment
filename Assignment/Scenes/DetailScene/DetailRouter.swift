import Foundation

protocol DetailDataStoreProtocol {
	var movieId: Int? { get set }
}

protocol DetailRouterProtocol {
	var dataStore: DetailDataStoreProtocol? { get }
}

class DetailRouter: DetailRouterProtocol {
	private weak var view: DetailViewProtocol?
	private weak var interactor: DetailInteractorProtocol?
	var dataStore: DetailDataStoreProtocol?

	init(view: DetailViewProtocol, interactor: DetailInteractorProtocol?, dataStore: DetailDataStoreProtocol) {
		self.view = view
		self.interactor = interactor
		self.dataStore = dataStore
	}

}
