//
//  CustomDate.swift
//  OrganiPill
//
//  Created by David Benitez on 4/18/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import Foundation
import RealmSwift

class CustomDate: Object {
    
    dynamic var minutos : Int = 0
    dynamic var horas : Int = 0
    dynamic var meridiano : String = ""
    
    let listaDias = List<RealmInt>()
}
