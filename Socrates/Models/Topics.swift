//
//  Topics.swift
//  Socrates
//
//  Created by Harsh Patel on 11/3/19.
//  Copyright © 2019 Harsh Patel. All rights reserved.
//

import Foundation
import UIKit

class Topics{
    
    var message: String
    var comCount: Int
    var watchCount: Int
    var agrees: Int
    var disagrees: Int
    var id: String
    
    init(message: String, comCount: Int, watchCount: Int, agrees: Int, disagrees: Int, id: String) {
        self.message = message
        self.comCount = comCount
        self.watchCount = watchCount
        self.agrees = agrees
        self.disagrees = disagrees
        self.id = id
    }
    
}
