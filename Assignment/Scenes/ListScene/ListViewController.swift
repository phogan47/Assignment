import UIKit

protocol ListViewProtocol: class {
	func displayList(_ viewObject: ListViewObject)
	func displayError(error: CommonAPIError)
}

class ListViewController: UIViewController {

	@IBOutlet weak var listTable: UITableView!

	private var router: ListRouterProtocol?
	private var interactor: ListInteractorProtocol?
	private let refreshControl = UIRefreshControl()

	private var viewObject: ListViewObject?

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		initScene()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		initScene()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Latest Movies"
		setupTable()
		getList()
	}

	private func initScene() {
		let presenter = ListPresenter(view: self)
		interactor = ListInteractor(presenter: presenter)
		router = ListRouter(view: self, interactor: interactor)
	}

	private func setupTable() {
		ListViewTableCell.register(for: listTable)
		listTable.dataSource = self
		listTable.delegate = self
		listTable.isHidden = true
		listTable.isMultipleTouchEnabled = false
		listTable.separatorStyle = .none
		listTable.backgroundColor = .black
		listTable.rowHeight = ListViewTableCell.rowHeight
		listTable.accessibilityIdentifier = "MOVIE_LIST"

		// Add Refresh Control to Table View
		if #available(iOS 10.0, *) {
			listTable.refreshControl = refreshControl
		} else {
			listTable.addSubview(refreshControl)
		}
		refreshControl.backgroundColor = .black
		refreshControl.addTarget(self, action: #selector(getList), for: .valueChanged)
	}
}

// MARK: ListInteractorProtocol methods
extension ListViewController {
	@objc private func getList() {
		showSpinnerTransparentBackground()
		interactor?.getLatest()
	}
}

// MARK: ListViewProtocol methods
extension ListViewController: ListViewProtocol {
	func displayList(_ viewObject: ListViewObject) {
		self.viewObject = viewObject
		listTable?.reloadData()
		listTable.isHidden = false
		hideSpinner()
		refreshControl.endRefreshing()
	}

	func displayError(error: CommonAPIError) {
		hideSpinner()
		refreshControl.endRefreshing()
		listTable.isHidden = false
		switch error {
		case .connectionFailed:
			displayError(title: "Device Offline", message: "Please check internet settings and try again. (Pull down to refresh!)")
		default:
			displayError(title: "Oops!", message: "Something went wrong attempting access latest movies")
		}
	}
}

// MARK: ListViewRouter methods
extension ListViewController {
	private func goToDetail(for movie: Movie) {
		router?.routeToDetail(for: movie.movieId)
	}
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewObject?.movies.count ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
			let movie = viewObject?.movies[indexPath.row],
			let cell = tableView.dequeueReusableCell(withIdentifier: ListViewTableCell.nibName, for: indexPath) as? ListViewTableCell
		else {
			return UITableViewCell()
		}
		cell.configure(movie)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let movie = viewObject?.movies[indexPath.row] else { return }
		goToDetail(for: movie)
	}
}

extension String {
	var localize: String {
		return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, comment: "")
	}
}
