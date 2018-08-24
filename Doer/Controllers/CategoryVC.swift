//
//  CategoryVC.swift
//  Doer
//
//  Created by Ljubisa Katana on 22.8.18..
//  Copyright © 2018. com.ljubadit. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryVC: UITableViewController {

	// MARK: - Properties
	
	let realm = try! Realm()
	
	var categories: Results<Category>?
	
	// MARK: - View Life Cycle
	
    override func viewDidLoad() {
        super.viewDidLoad()

		loadCategories()
    }

	// MARK: TableView Datasource

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories?.count ?? 1 // Nil Coalescing Operator
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
	
		cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
		
		return cell
	}
	
	// MARK: TableView Delegate 
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		performSegue(withIdentifier: "goToItems", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let vc = segue.destination as! ToDoListVC
		guard let indexPath = tableView.indexPathForSelectedRow else { return }
		vc.selectedCategory = categories?[indexPath.row]
	}
	
	// MARK: - Data Manipulation
	
	func save(category: Category) {
		
		do {
			try realm.write {
				realm.add(category)
			}
		} catch {
			print("Error saving category \(error)")
		}
		
		tableView.reloadData()
	}
	
	func loadCategories() {

		categories = realm.objects(Category.self)

		 tableView.reloadData()
	}
	
	// MARK: - Add New Categories
	
	@IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
		
		var textFiled = UITextField()
		
		let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add", style: .default) { (action) in
			
			let newCategory = Category( )
		  	newCategory.name = textFiled.text!
			
			self.save(category: newCategory)
		}
		
		alert.addAction(action)
		
		alert.addTextField { (field) in
			textFiled = field
			textFiled.placeholder = "Add a new category"
		}
		
		present(alert, animated: true, completion: nil)
	}
}
