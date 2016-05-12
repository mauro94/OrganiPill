//
//  Notificaciones.swift
//  OrganiPill
//
//  Created by David Benitez on 4/28/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import Foundation
import RealmSwift

class Notificaciones: Object {
    var listaNotificaciones = List<Fecha>()
    //var listaMedicamentos = List<CustomString>()
    var id : Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
