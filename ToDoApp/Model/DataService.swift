//
//  DataService.swift
//  ToDoApp
//
//  Created by Tran Ngoc Nam on 7/28/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

typealias JSON = Dictionary<AnyHashable, Any>

class DataService {
    static let shared: DataService = DataService()
        
    func getDataOfToDoList(complete: @escaping(ToDo) -> Void) {
        guard let url = URL(string: Constants.TO_DO_APP) else { return }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                guard let result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSON else { return }
                guard let toDo = ToDo(dictionary: result) else { return }
                DispatchQueue.main.async {
                    complete(toDo)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func getDataOfTask(urlString: String, complete: @escaping([Task]) -> Void) {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                guard let result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [JSON] else { return }
                var tasks: [Task] = []
                for dataTask in result {
                    guard let task = Task(dictionary: dataTask) else { return }
                    tasks.append(task)
                }
                DispatchQueue.main.async {
                    complete(tasks)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func postData(urlString: String, task: Task) {
        print(urlString)
        let parameters = task.toAnyObject()
        print(parameters)
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
        
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    func deleteData(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let _ = data else {
                print("error calling DELETE")
                return
            }
            print("DELETE ok")
        }.resume()
    }

}
