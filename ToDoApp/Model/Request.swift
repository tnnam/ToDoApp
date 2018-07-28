//
//  Request.swift
//  ToDoApp
//
//  Created by Tran Ngoc Nam on 7/28/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class Request {
    var id: String = ""
    var name: String = ""
    var url: String = ""
    var method: String = ""
    
    init?(dictionary: JSON) {
        let id = dictionary["id"] as? String ?? ""
        let name = dictionary["name"] as? String ?? ""
        let url = dictionary["url"] as? String ?? ""
        let method = dictionary["method"] as? String ?? ""
        
        self.id = id
        self.name = name
        self.url = url
        self.method = method
    }
}
