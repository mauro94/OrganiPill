//
//  Fecha.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/13/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import Foundation
import RealmSwift

class Fecha: Object {
	dynamic var fechaOriginal = NSDate()
    dynamic var fechaAlerta = NSDate()
    dynamic var nombreMed = ""
}
