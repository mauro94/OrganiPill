//
//  Paciente.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/13/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import Foundation
import RealmSwift

class Paciente: Object {
	dynamic var persona: Persona? = nil
	let medMedicamentos = List<Medicamento>()
}
