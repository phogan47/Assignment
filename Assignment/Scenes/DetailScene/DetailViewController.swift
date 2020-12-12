import UIKit

protocol DetailViewProtocol: class {
	func displayDetails(_ viewObject: DetailViewObject)
	func displayError(error: CommonAPIError)
}

class DetailViewController: UIViewController {

	@IBOutlet private weak var posterImageView: UIImageView!
	@IBOutlet private weak var imageSpinner: UIActivityIndicatorView!

	@IBOutlet private weak var descriptionLabel: UILabel! {
		didSet {
			descriptionLabel.textColor = UIColor.white
			descriptionLabel.font = .systemFont(ofSize: 16)
		}
	}

	@IBOutlet private weak var titleLabel: UILabel! {
		didSet {
			titleLabel.textColor = Config.Colors.mainTheme
			titleLabel.font = .systemFont(ofSize: 20)
		}
	}

	@IBOutlet private weak var releaseLabel: UILabel! {
		didSet {
			releaseLabel.textColor = Config.Colors.mainTheme
			releaseLabel.font = .systemFont(ofSize: 20)
		}
	}

	private var interactor: DetailInteractorProtocol?
	private var imageService: ImageServiceProtocol?
	private var posterUrl: URL?
	var router: DetailRouterProtocol?

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
		title = "Movie Details"
		loadMovie()
		imageSpinner.isHidden = true
		imageService = ImageService {
			self.loadImage()
			//self.reloadImage()
		}

	}

	private func reloadImage() {
		imageSpinner.isHidden = true
		imageSpinner.stopAnimating()
		loadImage()
	}

	private func initScene() {
		let presenter = DetailPresenter(view: self)
		let interactor = DetailInteractor(presenter: presenter)
		router = DetailRouter(view: self, interactor: interactor, dataStore: interactor)
		self.interactor = interactor
	}

}

// MARK: DetailInteractorProtocol methods
extension DetailViewController {
	private func loadMovie() {
		showSpinnerTransparentBackground()
		interactor?.getDetails()
	}
}

extension DetailViewController: DetailViewProtocol {
	func displayDetails(_ viewObject: DetailViewObject) {
		hideSpinner()
		descriptionLabel.text = viewObject.movieDetail.overview
		titleLabel.text = viewObject.movieDetail.name
		posterUrl = viewObject.movieDetail.backdropUrl
		releaseLabel.text = viewObject.movieDetail.releaseDateDisplayString
		imageSpinner.isHidden = false
		imageSpinner.startAnimating()
		loadImage()
	}

	func displayError(error: CommonAPIError) {
		hideSpinner()
		switch error {
		case .connectionFailed:
			displayError(title: "Device Offline", message: "Please check internet settings and try again.")
		default:
			displayError(title: "Oops!", message: "Something went wrong attempting access movie details")
		}
	}

	private func loadImage() {
		if let myUrl = posterUrl {
			if let image = imageService?.getImage(url: myUrl) {
				self.imageSpinner.isHidden = true
				self.imageSpinner.stopAnimating()
				self.posterImageView.image = image
			}
		}
	}

}
