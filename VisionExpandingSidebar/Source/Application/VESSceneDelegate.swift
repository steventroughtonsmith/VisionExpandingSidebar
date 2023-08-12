//
//  VESSceneDelegate.swift
//  VisionExpandingSidebar
//
//  Created by Steven Troughton-Smith on 12/08/2023.
//  
//

import UIKit

class VESSceneDelegate: UIResponder, UIWindowSceneDelegate {
	var window: UIWindow?
	
	let rootSplitViewController = UISplitViewController()
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = scene as? UIWindowScene else {
			fatalError("Expected scene of type UIWindowScene but got an unexpected type")
		}
		window = UIWindow(windowScene: windowScene)
		
		if let window = window {
			rootSplitViewController.primaryBackgroundStyle = .sidebar
			rootSplitViewController.viewControllers = [VESSidebarCollectionViewController(), VESMainViewController()]
			
			rootSplitViewController.preferredDisplayMode = .secondaryOnly

			window.rootViewController = rootSplitViewController
			
#if targetEnvironment(macCatalyst)
			
			let toolbar = NSToolbar(identifier: NSToolbar.Identifier("VESSceneDelegate.Toolbar"))
			toolbar.delegate = self
			toolbar.displayMode = .iconOnly
			toolbar.allowsUserCustomization = false
			
			windowScene.titlebar?.toolbar = toolbar
			windowScene.titlebar?.toolbarStyle = .unified
			
#endif
			NotificationCenter.default.addObserver(forName: NSNotification.Name("ToggleSidebar"), object: nil, queue: .main) { [weak self] _ in
				self?.toggleSidebarVisibility()
			}
			
			window.makeKeyAndVisible()
		}
	}
	
	func toggleSidebarVisibility() {

		let delta = CGFloat(320)
		
		let currentSize = window?.bounds.size ?? .zero

		UIView.animate(withDuration: 0.3) { [weak self] in
			if self?.rootSplitViewController.displayMode == .secondaryOnly {
				self?.rootSplitViewController.preferredDisplayMode = .oneBesideSecondary
				self?.resizeWindow(to: CGSize(width: currentSize.width+delta, height: currentSize.height))
			}
			else {
				self?.rootSplitViewController.preferredDisplayMode = .secondaryOnly
				self?.resizeWindow(to: CGSize(width: currentSize.width-delta, height: currentSize.height))
			}
		}
	}
	
	func resizeWindow(to size:CGSize) {
		guard let windowScene = window?.windowScene as? UIWindowScene else { return }

#if os(xrOS)
		
		let geo = UIWindowScene.GeometryPreferences.Reality()
		
		geo.size = size
		
		windowScene.requestGeometryUpdate(geo)
#endif
	}
}
