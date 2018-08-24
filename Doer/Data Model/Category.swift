//
//  Category.swift
//  Doer
//
//  Created by Ljubisa Katana on 23.8.18..
//  Copyright © 2018. com.ljubadit. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
	@objc dynamic var name: String = ""
	let items = List<Item>()
}
