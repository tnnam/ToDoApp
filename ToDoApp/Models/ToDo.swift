//
//  ToDo.swift
//  ToDoApp
//
//  Created by Tran Ngoc Nam on 7/29/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class ToDo {
    var orders: [String] = []
    var requests: [Request] = []
    
    init?(dictionary: JSON) {
        let orders = dictionary["order"] as? [String] ?? []
        let requestsData = dictionary["requests"] as? [JSON] ?? []
        for data in requestsData {
            guard let request = Request(dictionary: data) else { return }
            self.requests.append(request)
        }
        self.orders = orders
    }
}
