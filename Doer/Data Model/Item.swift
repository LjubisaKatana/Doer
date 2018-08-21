//
//  Item.swift
//  Doer
//
//  Created by Ljubisa Katana on 20.8.18..
//  Copyright © 2018. com.ljubadit. All rights reserved.
//

import Foundation

// Codible = Encodible, Decodible

class Item: Codable {
	// When I use Encodible protocol i Class, we must use standard data types!
	var title: String = ""
	var done: Bool = false
}
