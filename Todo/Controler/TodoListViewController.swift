//
//  ViewController.swift
//  Todo
//
//  Created by Alexei Dudarev on 12/02/2018.
//  Copyright © 2018 Alexei Dudarev. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let defaults = UserDefaults.standard
    //let dataFilePath = FileManager.default.urls(for:
     //   .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Alexei.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //to show saving directory
        //print(FileManager.default.urls(for:
        //    .documentDirectory, in: .userDomainMask))
        
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
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        //bacause the item is now an item and no a string
        let item : Item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
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
        //shortway
       
    
        itemArray[indexPath.row].done  = !itemArray[indexPath.row].done
        saveItems()
        
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
        
        
        //tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action  = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            //saving file function calling
            self.saveItems()
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation method
    
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("Error saving context: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), searchPredicate : NSPredicate = NSPredicate(value : true)){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
        
    
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error while fetching data form context: \(error)")
        }
        
        tableView.reloadData()
        
        
        //swifty way of code optional try
//        if let dataTwo = try? Data(contentsOf : dataFilePath!){
//            let decoderTwo : PropertyListDecoder = PropertyListDecoder()
//            do{
//                itemArray = try decoderTwo.decode([Item].self, from: dataTwo)
//            }catch{
//                print("Error")
//            }
//        }
        
   }

    
}
//MARK: - search bar methods
extension TodoListViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
    
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request,searchPredicate: predicate)

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






