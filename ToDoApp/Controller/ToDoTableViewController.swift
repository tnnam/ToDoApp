//
//  ToDoTableViewController.swift
//  ToDoApp
//
//  Created by Tran Ngoc Nam on 7/29/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController {

    var tasks: [Task] = []

    // White View
    @IBOutlet var noDataView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    // Check No Data
    var hasNoData: Bool = false {
        didSet {
            tableView.backgroundView = hasNoData ? noDataView : footerView
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hasNoData = tasks.count == 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func loadData() {
        DataService.shared.getDataOfTask(urlString: Constants.GET, complete: { (tasks) in
            print(tasks.count)
            self.tasks = tasks
            self.tableView.reloadData()
            self.hasNoData = tasks.count == 0
        })
    }
    
    // MARK: - Table view data source
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
            let urlString = "\(Constants.DELETE)\(task._id)"
            DataService.shared.deleteData(urlString: urlString)
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
