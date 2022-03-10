//
//  CtegoryVC.swift
//  ToDoList
//
//  Created by Valya on 10.03.22.
//

import UIKit
import CoreData

class CategoryVC: UITableViewController {
    
    @IBAction func addCategoryBtn(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let add = UIAlertAction(title: "Add category", style: .default) { [weak self] _ in
            if let textField = alert.textFields?.first,
               let text = textField.text, text != "",
               let self = self {
                    let newCategory = Category(context: self.context)
                    newCategory.title = text
                    self.categories.append(newCategory)
                    self.saveData()
                    self.tableView.insertRows(at: [IndexPath(row: self.categories.count - 1, section: 0)], with: .automatic)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { textField in
            textField.placeholder = "Category"
        }
        
        alert.addAction(add)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
        
    }
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].title
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func saveData() {
        do {
            try context.save()
        } catch let Error {
            print(Error)
        }
    }
    
    private func fetchData(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch let Error {
            print(Error)
        }
        
        tableView.reloadData()
    }

}
