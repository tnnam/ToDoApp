//
//  ViewController.swift
//  ToDoApp
//
//  Created by Tran Ngoc Nam on 7/28/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class ToDoViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var doneButton: UISwitch!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        configTask()
    }
    
    func configTask() {
        if task != nil {
            navigationItem.title = task?.name ?? ""
            nameTextField.text = task?.name ?? ""
            doneButton.isOn = task?.done == true ? true : false
            saveButton.isEnabled = true
        }
    }
    
    // Save
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text else { return }
        let done = doneButton.isOn ? true : false
        print(done)
        var urlString: String = ""
        if task == nil {
            task = Task(name: name, done: done)
            urlString = Constants.ADD
        } else {
            task?.name = name
            task?.done = done
            urlString = "\(Constants.UPDATE)\(task!._id)"
        }
        DataService.shared.postData(urlString: urlString, task: task!)
        navigationController?.popViewController(animated: true)
    }
    
    // Cancel
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("Error")
        }
    }
    
}

extension ToDoViewController: UITextFieldDelegate {
    // Hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Hide save button
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if task == nil {
            saveButton.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonStates()
        navigationItem.title = nameTextField.text
    }
    
    private func updateSaveButtonStates() {
        saveButton.isEnabled = nameTextField.text! != ""
    }

}

