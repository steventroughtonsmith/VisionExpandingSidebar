//
//  VESMainViewController.swift
//  VisionExpandingSidebar
//
//  Created by Steven Troughton-Smith on 12/08/2023.
//
//

import UIKit
import SwiftUI

struct VESOrnament: View {
	var body: some View {
		HStack {
			Button {
				NotificationCenter.default.post(name: NSNotification.Name("ToggleSidebar"), object: nil)
			} label: {
				Image(systemName:"sidebar.leading")
			}
			.padding()
		}
		.glassBackgroundEffect()
	}
}

final class VESMainViewController: UIViewController {
	
	init() {
		super.init(nibName: nil, bundle: nil)
		setupOrnament()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: -
	
	func setupOrnament() {
#if os(xrOS)
		let ornament = UIHostingOrnament(sceneAlignment: .top, contentAlignment: .center) {
			VESOrnament()
		}
		
		ornaments = [ornament]
#endif
	}
}
