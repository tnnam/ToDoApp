//
//  ToDoTableViewController.swift
//  ToDoApp
//
//  Created by Tran Ngoc Nam on 7/29/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {

    let idForGet = "094a4511-1008-473e-b0e4-e43947351c62"
    var tasks: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    // MARK: - Table view data source

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func loadData() {
        DataService.shared.getDataOfToDoList { (toDo) in
            let requests: [Request] = toDo.requests
            for request in requests {
                if request.id == self.idForGet {
                    DataService.shared.getDataOfTask(urlString: request.url, complete: { (tasks) in
                        print(tasks.count)
                        self.tasks = tasks
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = "\(task.done)"
        return cell
    }

    // Delete
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            DataService.shared.deleteData(task: task)
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            loadData()
        } else if editingStyle == .insert {
            
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "update" {
            guard let toDoViewController = segue.destination as? ToDoViewController else { return }
            guard let index = tableView.indexPathForSelectedRow else { return }
            toDoViewController.task = tasks[index.row]
        }
    }
}
