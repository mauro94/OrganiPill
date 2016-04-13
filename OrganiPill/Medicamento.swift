//
//  Medicamento.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/6/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import Foundation
import RealmSwift

class Medicamento: Object {
	dynamic var sNombre: String = ""
	let ingrediente = List<Ingrediente>()
	dynamic var dDosis: Double = 0.0
	dynamic var dMiligramosCaja: Double = 0.0
	dynamic var sViaAdministracion: String = ""
	dynamic var iDias: Int = 0
	let horario = List<Fecha>()
	dynamic var bNecesitaAlimento: Bool = false
	dynamic var sComentario: String = ""
	dynamic var sFotoCaja: String = ""
	dynamic var sFotoMedicamento: String = ""
	dynamic var sFotoPastillero: String? = nil
	
	override static func indexedProperties() -> [String] {
		return ["sNombre"]
	}
}