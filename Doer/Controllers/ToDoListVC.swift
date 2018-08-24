//
//  ToDoListVC.swift
//  Doer
//
//  Created by Ljubisa Katana on 20.8.18..
//  Copyright © 2018. com.ljubadit. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListVC: UITableViewController {
	
	// MARK: Properties

	var todoItems: Results<Item>?
	let realm = try! Realm()
	
	var selectedCategory: Category? {
		didSet {
			loadItems()
		}
	}
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
	}
	
	// MARK: TableView Datasource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return todoItems?.count ?? 1
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
		
		if let item = todoItems?[indexPath.row] {
			cell.textLabel?.text = item.title
			cell.accessoryType = item.done == true ? .checkmark : .none // Ternary operator
		} else {
			cell.textLabel?.text = "No Items Added"
		}
		
		return cell
	}
	
	// MARK: TableView Delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let item = todoItems?[indexPath.row] {
			do {
				try realm.write {
					//realm.delete(item)
					item.done = !item.done
				}
			} catch {
				print("Error saving done status \(error)")
			}
		}
		
		tableView.reloadData()

		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: Add New Items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textFiled = UITextField()
		
		let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
	
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			
			if let currentCategory = self.selectedCategory {
				do {
					try self.realm.write {
						let newItem = Item() 
						newItem.title = textFiled.text!
						newItem.dateCreated = Date()
						currentCategory.items.append(newItem)
					}
				} catch {
					print("Error saving new items \(error)")
				}
			}
			
			self.tableView.reloadData()
		}
	
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textFiled = alertTextField
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	// MARK: - Data Manipulation
	
	func loadItems() {
		
		todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true )
		
		tableView.reloadData()
	}
}

//   MARK: - Search Bar Delegate

extension ToDoListVC: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
		
		tableView.reloadData()
   	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchBar.text?.count == 0 {
			loadItems()

			DispatchQueue.main.async {
				searchBar.resignFirstResponder()
			}
		}
	}
}









