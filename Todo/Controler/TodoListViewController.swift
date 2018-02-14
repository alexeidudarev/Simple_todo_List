//
//  ViewController.swift
//  Todo
//
//  Created by Alexei Dudarev on 12/02/2018.
//  Copyright © 2018 Alexei Dudarev. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray : [Item] = [Item]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let newItem : Item = Item()
        newItem.title = "Alexei"
        itemArray.append(newItem)
        
        let newItem2 : Item = Item()
        newItem2.title = "David"
        itemArray.append(newItem2)
        
        let newItem3 : Item = Item()
        newItem3.title = "Netanel"
        itemArray.append(newItem3)
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
//        if let items = defaults.array(forKey: "TodoListArray")as?[String]{
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
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        return cell
    }
    
    //Mark: - TableView Delegates Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //shortway
        itemArray[indexPath.row].done  = !itemArray[indexPath.row].done
        
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new item", message: "", preferredStyle: .alert)
        let action  = UIAlertAction(title: "Add item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

