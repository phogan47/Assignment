import Foundation
import UIKit

protocol ImageServiceProtocol {
	func getImage(url: URL) -> UIImage
}

struct ImageService: ImageServiceProtocol {

	private let cacheTimeout: TimeInterval = 3000
	private var callBack: () -> Void?

	init(callBack: @escaping () -> Void?) {
		self.callBack = callBack
	}

	func getImage(url: URL) -> UIImage {

		//First check to see if this image is in the cache
		if let cachedItem = ImageCache.shared.retrieveImage(forKey: url.absoluteString as NSString) {
			return cachedItem.image
		}

		//If nothing in the cache make an async request for it
		DispatchQueue.global().async {
			if let data = try? Data( contentsOf: url) {
				if let image = UIImage(data: data) {
					let cacheItem = ImageCacheItem(image)
					ImageCache.shared.addImage(cacheItem, forKey: url.absoluteString as NSString, cacheFor: cacheTimeout)
					DispatchQueue.main.async {
						callBack()
					}
				}
			}
		}

		//TODO: Return a place holder image...
		return UIImage()
	}
}

private class ImageCache {

	static let shared = ImageCache()
	private let cache: NSCache<NSString, ImageCacheItem>

	init() {
		cache = NSCache<NSString, ImageCacheItem>()
		safeprint("- Network Cache created -")
	}

	func retrieveImage(forKey key: NSString) -> ImageCacheItem? {
		if let cachedResponse = cache.object(forKey: key),
		   let expiry = cachedResponse.expiryDate,
		   expiry > Date() {
			return cachedResponse
		}
		return nil
	}

	func addImage(_ response: ImageCacheItem, forKey key: NSString, cacheFor: TimeInterval) {
		response.expiryDate = Date() + cacheFor
		cache.setObject(response, forKey: key)
	}

}

private class ImageCacheItem {
	let image: UIImage
	var expiryDate: Date?

	init(_ image: UIImage) {
		self.image = image
	}
}
