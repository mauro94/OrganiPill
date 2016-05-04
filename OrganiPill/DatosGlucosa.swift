//
//  DatosGlucosa.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 5/3/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import Foundation
import RealmSwift

class DatosGlucosa: Object {
    dynamic var rangoBajo: Float = 0.0
    dynamic var rangoAlto: Float = 100.0
    var historialMedidas = List<Medidas>()
    
    
}