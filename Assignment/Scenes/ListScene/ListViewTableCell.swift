import UIKit

class ListViewTableCell: UITableViewCell {

	static let rowHeight: CGFloat = 120.0

	@IBOutlet weak var nameValue: UILabel! {
		didSet {
			nameValue.textColor = Config.Colors.mainTheme
			nameValue.font = .systemFont(ofSize: 22)
		}
	}

	@IBOutlet weak var actorLabel: UILabel! {
		didSet {
			actorLabel.textColor = UIColor.lightGray
			actorLabel.font = .systemFont(ofSize: 16)
		}
	}

	@IBOutlet weak var actorValue: UILabel! {
		didSet {
			actorValue.textColor = UIColor.white
			actorValue.font = .systemFont(ofSize: 16, weight: .bold)
		}
	}

	@IBOutlet weak var thumbNail: UIImageView!

	private var imageService: ImageServiceProtocol?
	private var thumbNailUrl: URL?

	override func awakeFromNib() {
		super.awakeFromNib()
		selectionStyle = .none
		thumbNail.layer.borderWidth = 1
		thumbNail.layer.borderColor = UIColor.black.cgColor
		thumbNail.layer.cornerRadius = (ListViewTableCell.rowHeight - 20.0) / 2.0
		thumbNail.clipsToBounds = true
		imageService = ImageService {
			self.loadImage()
		}
	}

	func configure(_ movie: Movie) {
		thumbNailUrl = movie.thumbNailUrl
		nameValue.text = movie.name
		actorLabel.text = "viewer rating:"
		actorValue.text = movie.rating
		loadImage()
	}

	private func loadImage() {
		if let myUrl = thumbNailUrl {
			self.thumbNail.image = imageService?.getImage(url: myUrl)
		}
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		thumbNail.image = nil
		thumbNailUrl = nil
	}
}
