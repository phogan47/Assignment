//
//  AppDelegate.swift
//  GlobileSquadsCoreExample
//
//  Created by Hogan, Patrick (ISBANUK) on 17/06/2019.
//  Copyright © 2019 Santander. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		setupNavBar()
//		DeveloperSettings.initialise()
		return true
	}

	private func setupNavBar() {
		UINavigationBar.appearance().barTintColor = .black
		UINavigationBar.appearance().isTranslucent = true
		UINavigationBar.appearance().tintColor = Config.Colors.navBarTint
		UINavigationBar.appearance().shadowImage = UIImage()
		let navbarAttrs: [NSAttributedString.Key: Any] = [
			NSAttributedString.Key.foregroundColor: Config.Colors.navBarText,
			NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .semibold)
		]
		UINavigationBar.appearance().titleTextAttributes = navbarAttrs
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		#if DEBUG
		//window?.checkState()
		#endif
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

}

//#if DEBUG
//extension UIWindow: DeveloperSettingsViewDelegate {
//	open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//		if motion == .motionShake {
//			DeveloperSettings.start(from: self, delegate: self)
//		}
//	}
//
//	open func settingsClosed(offline: Bool, originalViewController: UIViewController?) {
//		self.rootViewController = originalViewController
//		checkState()
//	}
//
//	private func removeStatusBarOverlay() {
//		for view in self.subviews where view.tag == 32145 {
//			view.removeFromSuperview()
//		}
//	}
//
//	private func addStatusBarOverlay() {
//		removeStatusBarOverlay()
//		var frame = self.bounds
//		frame.size.height = 3
//		let view = UIView(frame: frame)
//		view.tag = 32145
//		view.backgroundColor = .green
//		view.isUserInteractionEnabled = false
//		self.addSubview(view)
//		self.bringSubviewToFront(view)
//	}
//
//	func checkState() {
//		(DeveloperSettings.currentlyOffline) ? addStatusBarOverlay() : removeStatusBarOverlay()
//	}
//
//}
//#endif
