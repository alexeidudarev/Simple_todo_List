//
//  Category.swift
//  Todo
//
//  Created by hackeru on 18/02/2018.
//  Copyright © 2018 Alexei Dudarev. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
