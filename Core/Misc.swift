import Foundation

func safeprint(_ entry: String) {
	#if DEBUG
		print("DEBUG: \(Date().localTime) ** \(entry)")
	#endif
}
