//
//  AppDelegate.swift
//  Doer
//
//  Created by Ljubisa Katana on 20.8.18..
//  Copyright © 2018. com.ljubadit. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		//print(Realm.Configuration.defaultConfiguration.fileURL)
		
		do {
			_ = try Realm()
		} catch {
			print("Error intialising new realm \(error)")
		}
		
		return true
	}
}

