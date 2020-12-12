import UIKit

extension UITableViewCell {
	static var nibName: String {
		return NSStringFromClass(self).components(separatedBy: ".").last!
	}

	static var nib: UINib {
		return UINib(nibName: nibName, bundle: nil)
	}

	static var nibWithBundle: UINib {
		return UINib(nibName: nibName, bundle: Bundle(for: self))
	}

	static func register(for tableView: UITableView) {
		tableView.register(UINib(nibName: Self.nibName, bundle: Bundle.main), forCellReuseIdentifier: Self.nibName)
	}

}

extension UIViewController {
	static var nibName: String {
		return NSStringFromClass(self).components(separatedBy: ".").last!
	}
}
