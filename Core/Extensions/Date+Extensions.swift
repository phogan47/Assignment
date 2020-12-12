import Foundation

extension Date {
	var localTime: String {
		let timeFormatter = DateFormatter()
		timeFormatter.dateFormat = "HH:mm:ss"
		return timeFormatter.string(from: self)
	}

}
