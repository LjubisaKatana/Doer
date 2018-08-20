//
//  ToDoListController.swift
//  Doer
//
//  Created by Ljubisa Katana on 20.8.18..
//  Copyright © 2018. com.ljubadit. All rights reserved.
//

import UIKit

class ToDoListController: UITableViewController {
	
	// MARK: Properties

	var itemArray = [Item]()
	
	let defaults = UserDefaults.standard
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()

		
		let newItem = Item()
		newItem.title = "Jedan"
		itemArray.append(newItem)
		
		let newItem2 = Item()
		newItem2.title = "Dva"
		itemArray.append(newItem2)
		
		let newItem3 = Item()
		newItem3.title = "Tri"
		itemArray.append(newItem3)
		
		let newItem4 = Item()
		newItem4.title = "Cetiri"
		itemArray.append(newItem4)
		
		/// Defaults second example
		/*
		if let item = defaults.array(forKey: "ToDoListArray") as? [String] {
			itemArray = item
		}
		*/
		
		guard let items = defaults.array(forKey: "ToDoListArray") as? [Item] else { return }
		itemArray = items
	}
	
	// MARK: TableView Datasource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
		
		let item = itemArray[indexPath.row]
		
		cell.textLabel?.text = item.title
	
		/// Ternary operator (umesto 5 linija koda kroz if petlju)
		cell.accessoryType = item.done == true ? .checkmark : .none

		return cell
	}
	
	// MARK: TableView Delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		itemArray[indexPath.row].done = !itemArray[indexPath.row].done // eleganci :)
		
		tableView.reloadData()
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: Add New Items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textFiled = UITextField()
		
		let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
	
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			
			let newItem = Item()
			newItem.title = textFiled.text!
			
			self.itemArray.append(newItem)
			
			self.defaults.set(self.itemArray, forKey: "ToDoListArray")
			
			self.tableView.reloadData()
		}
	
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textFiled = alertTextField
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
}










