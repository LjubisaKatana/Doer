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
	
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
//		print(dataFilePath)
		
		loadItems()
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
		
		saveItems()
		
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
			
			self.saveItems()
		}
	
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textFiled = alertTextField
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	// MARK: - Manipulation persistent data
	
	/// Save data in p.list
	func saveItems() {
		let encoder = PropertyListEncoder()
		
		do {
			let data = try encoder.encode(itemArray)
			try data.write(to: dataFilePath!)
		} catch {
			print("Error encoding item array, \(error)")
		}
		
		self.tableView.reloadData()
	}
	
	/// Load data from p.list
	func loadItems() {
		if let data = try? Data(contentsOf: dataFilePath!) {
			let decoder = PropertyListDecoder()
			do {
				itemArray = try decoder.decode([Item].self, from: data)
			} catch {
				print("Error decoding item array, \(error )")
			}
		}
	}
}










