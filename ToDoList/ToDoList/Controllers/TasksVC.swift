//
//  TasksVC.swift
//  ToDoList
//
//  Created by Valya on 10.03.22.
//

import UIKit
import CoreData

class TasksVC: UITableViewController {
    
    var selectedCategory: Category? {
        didSet {
            fetchData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [Task] = []
//    {
//        didSet {
//            for task in tasks {
//                switch task.state {
//                case .high:
//                    hightPriorityTasks.append(task)
//                case .normal:
//                    normalPriorityTasks.append(task)
//                case .low:
//                    lowPriorityTasks.append(task)
//                case .completed:
//                    completedTasks.append(task)
//                }
//            }
//        }
//    }
//    var completedTasks: [Task] = []
//    var hightPriorityTasks: [Task] = []
//    var normalPriorityTasks: [Task] = []
//    var lowPriorityTasks: [Task] = []
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBAction func editRows() {
        tableView.isEditing.toggle()
    }
    
    
    @IBAction func addTaskBtn(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add new task", message: "", preferredStyle: .alert)
        let add = UIAlertAction(title: "Add task", style: .default) { [weak self] _ in
            if let textField = alert.textFields?.first,
               let text = textField.text, text != "",
               let self = self {
                    let newTask = Task(context: self.context)
                        newTask.title = text
                        newTask.taskId = Int32(self.tasks.count)
                        newTask.done = false
                        newTask.categoryId = self.selectedCategory
//                        newTask.state = .normal
                        self.tasks.append(newTask)
                        self.saveData()
                        self.tableView.insertRows(at: [IndexPath(row: self.tasks.count - 1, section: 0)], with: .automatic)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { textField in
            textField.placeholder = "Task"
        }
        
        alert.addAction(add)
        alert.addAction(cancel)
        
        self.present(alert, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        searchBar.delegate = self
    }

    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        Model.Priority.allCases.count
        1
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//       switch Model.Priority.allCases[section] {
//       case .high:
//           return "High priority"
//        case .normal:
//            return "Normal priority"
//        case .low:
//           return "Low priority"
//       case .completed:
//           return "Completed tasks"
//        }
//
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        let allTaskTypes = [completedTasks, hightPriorityTasks, normalPriorityTasks, lowPriorityTasks]
//
//        return allTaskTypes[section].count
        
        return tasks.count
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)

        cell.accessoryType = tasks[indexPath.row].done ? .checkmark : .none
        
        if let title = tasks[indexPath.row].title {
            
            cell.accessoryType == .checkmark ? (cell.textLabel?.attributedText = title.strikeThrough()) : (cell.textLabel?.attributedText = title.unStrikeThrought())
            
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        changeTaskStatus(indexPath.row)
    }
 

 
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let category = selectedCategory,
               let categoryName = category.title {
            let taskId = Int(tasks[indexPath.row].taskId)
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            
            request.predicate = NSPredicate(format: "categoryId.title == %@ AND taskId == %i", categoryName, taskId)
            
            if let tasks = try? context.fetch(request) {
                for task in tasks {
                    context.delete(task)
                }
            }
            
            self.tasks.remove(at: indexPath.row)
            saveData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }


    // Override to support rearranging the table view.
//    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
//        let movedTask = tasks[fromIndexPath.row]
//        
//        if let category = selectedCategory,
//           let categoryName = category.title {
//        let taskId = Int(tasks[fromIndexPath.row].taskId)
//        let request: NSFetchRequest<Task> = Task.fetchRequest()
//        
//        request.predicate = NSPredicate(format: "categoryId.title == %@ AND taskId == %i", categoryName, taskId)
//        
//        if let tasks = try? context.fetch(request) {
//            for task in tasks {
//                context.delete(task)
//            }
//        }
//        
//        tasks.remove(at: fromIndexPath.row)
//            
//        tasks.insert(movedTask, at: to.row)
//        saveData()
//        }
//    }
    

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {

        return true
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func setUI() {
        if let category = selectedCategory,
           let categoryName = category.title {
            navigationItem.title = "Tasks from \(categoryName) list"
        }
        
    }
    
    private func fetchData() {
        if let category = selectedCategory,
           let title = category.title {
            
            let request: NSFetchRequest<Task> = Task.fetchRequest()
            request.predicate = NSPredicate(format: "categoryId.title MATCHES %@", title)
            
            do {
                tasks = try context.fetch(request)
            } catch let Error {
                print(Error)
            }
        }
    }
    
    private func saveData() {
        do {
            try context.save()
        } catch let Error {
            print(Error)
        }
    }
    
    private func changeTaskStatus(_ index: Int) {
        tasks[index].done.toggle()
        saveData()
        tableView.reloadData()
    }

}


extension TasksVC: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fetchData()
            tableView.reloadData()
            searchBar.resignFirstResponder()
            print(searchText)
        } else {
            
            tasks = []
            
            if let category = selectedCategory,
               let categoryTitle = category.title {
                
                let request: NSFetchRequest<Task> = Task.fetchRequest()
                request.predicate = NSPredicate(format: "categoryId.title == %@ AND title CONTAINS %@", categoryTitle, searchText)
                
                do {
                    tasks = try context.fetch(request)
                } catch let Error {
                    print(Error)
                }
                
            }
            
            tableView.reloadData()
            
        }
        
    }
    
}
