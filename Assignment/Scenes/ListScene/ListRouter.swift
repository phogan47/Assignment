import UIKit

protocol ListRouterProtocol {
	func routeToDetail(for movieId: Int)
}

class ListRouter: ListRouterProtocol {

	private weak var view: ListViewProtocol?
	private weak var interactor: ListInteractorProtocol?

	init(view: ListViewProtocol, interactor: ListInteractorProtocol?) {
		self.view = view
		self.interactor = interactor
	}

	func routeToDetail(for movieId: Int) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		if let detailVC = storyboard.instantiateViewController(withIdentifier: DetailViewController.nibName) as? DetailViewController {
			passDataToNextScene(destination: detailVC, movieId: movieId)
			navigate(to: detailVC)
		}
	}

	private func passDataToNextScene(destination: UIViewController?, movieId: Int) {
		if let view = destination as? DetailViewController,
			var dataStore = view.router?.dataStore {
			dataStore.movieId = movieId
		}
	}

	private func navigate(to destination: UIViewController) {
		if let viewController = view as? UIViewController {
			if let navController = viewController.navigationController {
				navController.pushViewController(destination, animated: true)
			} else {
				viewController.present(destination, animated: true, completion: nil)
			}
		}
	}

}
