//
//  CategoryVC.swift
//  Doer
//
//  Created by Ljubisa Katana on 22.8.18..
//  Copyright © 2018. com.ljubadit. All rights reserved.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {

	// MARK: - Properties
	
	var categories = [Category]()
	
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
	
	// MARK: - View Life Cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()

		loadCategories()
    }

	// MARK: TableView Datasource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
	
		cell.textLabel?.text = categories[indexPath.row].name
		
		return cell
	}
	
	// MARK: TableView Delegate
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToItems", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let vc = segue.destination as! ToDoListVC
		guard let indexPath = tableView.indexPathForSelectedRow else { return }
		vc.selectedCategory = categories[indexPath.row]
	}
	
	// MARK: - Data Manipulation
	
	func saveCategories() {
		
		do {
			try context.save()
		} catch {
			print("Error saving category \(error)")
		}
		
		self.tableView.reloadData()
	}
	
	func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
		
		do {
			categories = try context.fetch(request)
		} catch {
			print("Error loading categories \(error)")
		}
		
		tableView.reloadData()
	}
	
	// MARK: - Add New Categories
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		var textFiled = UITextField()
		
		let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add", style: .default) { (action) in
			
			let newCategory = Category(context: self.context)
		
			newCategory.name = textFiled.text!
			
			self.categories.append(newCategory)
			
			self.saveCategories()
		}
		
		alert.addTextField { (alertTextField) in
			alertTextField.placeholder = "Add a new category"
			textFiled = alertTextField
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
}
