import UIKit

extension UIView {

	func addSubviewFillingParent(_ view: UIView) {
		self.addSubview(view, withMetrics: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
	}

	func addSubviewCenteredInParent(_ view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(view)
		view.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		view.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
	}

	func addSubviewCenteredInParent(_ view: UIView, width: CGFloat, height: CGFloat) {
		view.addConstraint(NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
		view.addConstraint(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
		addSubviewCenteredInParent(view)
	}

	func addSubview(_ view: UIView, withMetrics metrics: UIEdgeInsets) {
		view.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(view)
		let views: Dictionary = ["view": view]
		let metrics: Dictionary = ["top": metrics.top, "right": metrics.right, "bottom": metrics.bottom, "left": metrics.left]
		let hConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-left-[view]-right-|",
																				options: NSLayoutConstraint.FormatOptions(rawValue: 0),
																				metrics: metrics,
																				views: views)
		let vConstraints: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "V:|-top-[view]-bottom-|",
																				options: NSLayoutConstraint.FormatOptions(rawValue: 0),
																				metrics: metrics,
																				views: views)
		self.addConstraints(hConstraints)
		self.addConstraints(vConstraints)
	}
}
