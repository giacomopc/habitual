//
//  AppDelegate.swift
//  GameJam2016
//
//  Created by Giacomo Preciado on 1/29/16.
//  Copyright © 2016 kyrie. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var seleccionDeNivel : SeleccionDeNivelVC?
	var fase: Int = 0
	
	
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		return true
	}
}

