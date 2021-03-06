//
//  Item.swift
//  Doer
//
//  Created by Ljubisa Katana on 23.8.18..
//  Copyright © 2018. com.ljubadit. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
	@objc dynamic var title: String = ""
	@objc dynamic var done: Bool = false
	@objc dynamic var dateCreated: Date?
	var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
