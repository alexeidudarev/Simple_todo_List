//
//  Item.swift
//  Todo
//
//  Created by hackeru on 18/02/2018.
//  Copyright © 2018 Alexei Dudarev. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
}
