//
//  CategoryViewController.swift
//  Todo
//
//  Created by Alexei Dudarev on 17/02/2018.
//  Copyright © 2018 Alexei Dudarev. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework



class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
       
    }
    //MARK: - Table view datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        
        if let category = categoryArray?[indexPath.row]{
            
            
            cell.textLabel?.text = category.name
            
            guard let categoryColor = UIColor(hexString : category.color) else {fatalError()}
            cell.backgroundColor = categoryColor
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
        }
        
        
    
        
        
        
        return cell
    }
    
    
    //MARK: - Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                performSegue(withIdentifier: "goToItems", sender: self)
                //print(indexPath.row)
    }
    override func prepare(for segue : UIStoryboardSegue , sender:  Any?){
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
            
        }
    }
    
   
    
    //MARK: - Data manipulation methods
    func save(category : Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
        func loadCategory(){
           
            categoryArray = realm.objects(Category.self)
            
            tableView.reloadData()
            
    }
    //MARK : - delete data from swipe
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(category)
                }
            }catch{
                print("Error while deleting category \(error)")
            }
        }

    }
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            
            self.save(category : newCategory)
            
            //self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

