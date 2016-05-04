//
//  DatosPresion.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 5/3/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import Foundation
import RealmSwift

class DatosPresion: Object {
    
    
    dynamic var systolicBajo: Float = 0.0
    dynamic var sysolicAlto: Float = 100.0
    
    dynamic var diastolicBajo: Float = 0.0
    dynamic var diastolicAlto: Float = 100.0
    
    var historialSystolic = List<Medidas>()
    var historialDiastolic = List<Medidas>()
    
}