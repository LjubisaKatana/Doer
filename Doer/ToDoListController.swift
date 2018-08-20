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

	var itemArray = ["Jedan", "Dva", "Tri"]
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		
	}

	// MARK: TableView Datasource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
		cell.textLabel?.text = itemArray[indexPath.row]
		
		return cell
	}
	
	// MARK: TableView Delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		/// Refactor this part:
		if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
			tableView.cellForRow(at: indexPath)?.accessoryType = .none
		} else {
			tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		}
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: Add New Items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textFiled = UITextField()
		
		let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
	
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			self.itemArray.append(textFiled.text!) // Mora da se forsuje jer ne moze da bude nil moze samo prazan string tako da posle treba da se sredi(ili difoltna vrednost sto je lose ili da se spreci ako nema teksta)
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










