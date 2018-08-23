//
//  ToDoListVC.swift
//  Doer
//
//  Created by Ljubisa Katana on 20.8.18..
//  Copyright © 2018. com.ljubadit. All rights reserved.
//

import UIKit
import CoreData

class ToDoListVC: UITableViewController {
	
	// MARK: Properties

	var items = [Item]()
	
	var selectedCategory: Category? {
		didSet {
			loadItems() // Because of default value we don't have to put anything inside of parentheses.
		}
	}

	// UIAplication.shered - It's a Singleton and that is why we can't put AppDelegate, because it's a Class and there is no object of that Class, it's only a bluePrint.
	
	/// We grab persistentContainer and than we grab reference to the Context for that persistentContainer
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	// MARK: View Life Cycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
	}
	
	// MARK: TableView Datasource
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
		
		let item = items[indexPath.row]
		
		cell.textLabel?.text = item.title
		cell.accessoryType = item.done == true ? .checkmark : .none // Ternary operator

		return cell
	}
	
	// MARK: TableView Delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		// In these lines of code it's important to put them in the right order! Otherwise, we'll get some errors.
		// If we want to delete rows in this way and uses this kind of UX
		// context.delete(itemArray[indexPath.row])
		// itemArray.remove(at: indexPath.row)
		
		// itemArray[indexPath.row].setValue("Complited", forKey: "title") // When I finish my task, it will update to Complited
		
		// itemArray[indexPath.row].done = !itemArray[indexPath.row].done // elegant
		
		saveItems()
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: Add New Items
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textFiled = UITextField()
		
		let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
	
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			
			let newItem = Item(context: self.context) // Item is a type of the NSManagedObject and it's essentially a row in the database.
			
			newItem.title = textFiled.text!
			newItem.done = false
			newItem.parentCategory = self.selectedCategory
			
			self.items.append(newItem)
			self.saveItems()
		}
	
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Create new item"
			textFiled = alertTextField
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	// MARK: - Data Manipulation
	
	func saveItems() {

		do {
			try context.save()
		} catch {
			print("Error saving context \(error)")
		}
		
		self.tableView.reloadData()
	}
	
	/* Method with default value in case that first parameter haven't value
	 Item.fetchRequest() is default value if NSFetchRequest don't succeed. */
	func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
		
		let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
		
		if let additionalPredicate = predicate { 
			request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
		} else {
			request.predicate = categoryPredicate
		}
		
		do {
			items = try context.fetch(request) // fetch returns array of objects
		} catch {
			print("Error fetching data from context \(error)")
		}
		
		tableView.reloadData()
	}
}

// MARK: - Search Bar Delegate

extension ToDoListVC: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		
		let request: NSFetchRequest<Item> = Item.fetchRequest()
		
		let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // query (Look in NSPredicate list)
		
		request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

		loadItems(with: request, predicate: predicate)
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









