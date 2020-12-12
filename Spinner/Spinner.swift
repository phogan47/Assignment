import UIKit
import SwiftyGif

private let animationDuration: TimeInterval = 0.5
private let transparentBackground: CGFloat = 0.0

protocol Spinnerable {
	func showSpinnerInView(_ view: UIView, hasTransparentBackground: Bool)
	func hideSpinnerInView(_ view: UIView)
}

extension Spinnerable {

	func showSpinnerInView(_ view: UIView, hasTransparentBackground: Bool) {
		let backgroundAlpha = hasTransparentBackground ? transparentBackground : 1.0
		let spinner = Spinner(backgroundAlpha)
		spinner.loader?.alpha = 0
		view.addSubviewFillingParent(spinner)
		UIView.animate(withDuration: animationDuration) {
			spinner.loader?.alpha = 1.0
		}
	}

	func hideSpinnerInView(_ view: UIView) {
		for subview in view.subviews where subview is Spinner {
			UIView.animate(withDuration: animationDuration,
						   animations: {
							subview.alpha = 0.0
						   },
						   completion: { _ in
							subview.removeFromSuperview()
						   }
			)
		}
	}

}

extension UIViewController: Spinnerable {

	public func showSpinner() {
		showSpinnerInView(self.view, hasTransparentBackground: false)
	}

	public func showSpinnerTransparentBackground() {
		showSpinnerInView(self.view, hasTransparentBackground: true)
	}

	public func hideSpinner() {
		hideSpinnerInView(self.view)
	}
}

private class Spinner: UIView {
	
	var loader: Loader?
	
	func configure(backgroundAlpha: CGFloat = 1.0) {
		backgroundColor = UIColor.white.withAlphaComponent(backgroundAlpha)
		if let loader = Loader.instanceFromNib() {
			loader.setupLoaderNib(gifName: "blue")
			loader.contentMode = .scaleToFill
			addSubviewCenteredInParent(loader, width: 172, height: 172)
			self.loader = loader
		}
	}
	
	init(_ backgroundAlpha: CGFloat = 1.0) {
		super.init(frame: CGRect.zero)
		configure(backgroundAlpha: backgroundAlpha)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		configure()
	}
}

class Loader: UIView {

	@IBOutlet public var gifImage: UIImageView?
	@IBOutlet weak var loaderHeight: NSLayoutConstraint!
	@IBOutlet weak var loaderWidth: NSLayoutConstraint!

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	class func instanceFromNib() -> Loader? {
		if let nib = Resources.bundle?.loadNibNamed("Loader", owner: nil, options: nil)?[0] as? Loader {
			return nib
		}
		return nil
	}

	func setupLoaderNib(gifName: String) {
		self.backgroundColor = .clear
		gifImage?.setGifImage(getGifImage(gifName))
	}

	private func getGifImage(_ name: String) -> UIImage {

		guard
			let bundle = Resources.bundle,
			let path = bundle.path(forResource: name, ofType: "gif")
		else {
			return UIImage()
		}

		let url = URL(fileURLWithPath: path)
		do {
			let gifData = try Data(contentsOf: url)
			return try UIImage(gifData: gifData)
		} catch {
			return UIImage()
		}
	}
}

class Resources {
	static var bundle: Bundle? {
		if let bundleResourcePath = Bundle(for: self).path(forResource: "SpinnerResources", ofType: "bundle") {
			return Bundle(path: bundleResourcePath)
		} else {
			return Bundle(for: self)
		}
	}
}
