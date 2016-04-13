//
//  Persona.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/12/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import Foundation
import RealmSwift

class Persona: Object {
	dynamic var sNombre: String = ""
	dynamic var sTelefono: String = ""
	dynamic var sCorreoElectronico: String = ""
	dynamic var sGenero: String = ""
	let medMedicamentos = List<Medicamento>()
}
