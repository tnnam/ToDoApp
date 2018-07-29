//
//  Data.swift
//  ToDoApp
//
//  Created by Tran Ngoc Nam on 7/29/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit

class Task {
    var _id: String = ""
    var name: String = ""
    var done: Bool = false
    
    init(name: String, done: Bool) {
        self.name = name
        self.done = done
    }

    init?(dictionary: JSON) {
        let _id = dictionary["_id"] as? String ?? ""
        let name = dictionary["name"] as? String ?? ""
        let done = dictionary["done"] as? Bool ?? false
        
        self._id = _id
        self.name = name
        self.done = done
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "done": done
        ]
    }

}
