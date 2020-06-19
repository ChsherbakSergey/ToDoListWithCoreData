//
//  ViewController.swift
//  ToDoListWithCoreData
//
//  Created by Sergey on 6/16/20.
//  Copyright © 2020 Chsherbak Sergey. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var itemName: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Title")
        
        do {
            itemName = try context.fetch(fetchRequest)
        } catch {
            print("Error when loading data")
        }
    }

    var titleTextField: UITextField!
    
    func titleTextField(textField: UITextField!) {
        titleTextField = textField
        titleTextField.placeholder = "Type your new task..."
    }
    
    @IBAction func addButton(_ sender: Any) {
        let alert = UIAlertController(title: "New Task", message: "What's your new task?", preferredStyle: .alert)
        let add = UIAlertAction(title: "Add", style: .destructive, handler: self.save)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(add)
        alert.addAction(cancel)
        alert.addTextField(configurationHandler: titleTextField)
        self.present(alert, animated: true, completion: nil)
        
    }
 
    func save(alert: UIAlertAction) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Title", in: context)!
        let theTitle = NSManagedObject.init(entity: entity, insertInto: context)
        theTitle.setValue(titleTextField.text, forKey: "title")
        
        do {
            try context.save()
            itemName.append(theTitle)
        } catch {
            print("There is an error when saving")
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemName.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let title = itemName[indexPath.row]
        cell.textLabel?.text = title.value(forKey: "title") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(itemName[indexPath.row])
            itemName.remove(at: indexPath.row)
            
            do {
                try context.save()
                
            } catch {
                print("There is an error when deleting")
            }
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

