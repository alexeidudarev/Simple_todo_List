//
//  ViewController.swift
//  Todo
//
//  Created by Alexei Dudarev on 12/02/2018.
//  Copyright © 2018 Alexei Dudarev. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
           loadItems()
        }
    }

    //let defaults = UserDefaults.standard
    //let dataFilePath = FileManager.default.urls(for:
     //   .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Alexei.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //to show saving directory
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //to print file paht of saved file on emulator
//        let path = FileManager.default.urls(for:
//            .documentDirectory, in: .userDomainMask).first
//        print(path!)
        
          //loadItems()
        
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = defaults.array(forKey: "TodoListArray")as?[Item]{
//            itemArray = items
//        }
        
    }
    
    //Mark: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        //bacause the item is now an item and no a string
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            //ternary operator
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No items added"
            
        }
        
        
        //old version
//        if itemArray[indexPath.row].done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK: - TableView Delegates Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status \(error)")
            }
            
        }
        tableView.reloadData()
//        todoItems[indexPath.row].done  = !todoItems[indexPath.row].done
//        saveItems()
        
        //long way
//        if itemArray[indexPath.row].done == false{
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
        
        //firts old version with bad functionality
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        
        
        
        //tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action  = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.date = Date()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving context: \(error)")
                }
                
                
            }
        
            self.tableView.reloadData()
            
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
            
            //saving file function calling
            //self.saveItems()
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation method
    
//    func saveItems(){
//
//        do{
//            try context.save()
//        }catch{
//            print("Error saving context: \(error)")
//        }
//        self.tableView.reloadData()
//    }
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    }
    
    //cated from last parameter - searchPredicate : NSPredicate = NSPredicate(value : true)
    
//    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil){
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
//
////        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
//
//        do{
//            itemArray = try context.fetch(request)
//        }catch{
//            print("Error while fetching data form context: \(error)")
//        }
//
//        tableView.reloadData()
//
//
//        //swifty way of code optional try
////        if let dataTwo = try? Data(contentsOf : dataFilePath!){
////            let decoderTwo : PropertyListDecoder = PropertyListDecoder()
////            do{
////                itemArray = try decoderTwo.decode([Item].self, from: dataTwo)
////            }catch{
////                print("Error")
////            }
////        }
//
//   }
//
//
}
    
    
    
//MARK: - search bar methods
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
//        .sorted(byKeyPath: "title", ascending: true)
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "date", ascending: true)
        
        tableView.reloadData()
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request,predicate: predicate)

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}






