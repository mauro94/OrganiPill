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
	dynamic var dDosisRecetada: Double = 0.0
	dynamic var sUnidadesDosis: String = ""
	dynamic var dCantidadPorCaja: Double = 0.0
    dynamic var dCantidadPorCajaActual: Double = 0.0
	dynamic var dDosisPorTipo: Double = 0.0
	dynamic var sTipoMedicina: String = ""
	dynamic var iDuracion: Int = 0
    dynamic var sTipoDuracion: String = ""
	var horario = List<CustomDate>()
	dynamic var bNecesitaAlimento: Bool = false
	dynamic var sComentario: String = ""
	dynamic var sFotoCaja: String = ""
	dynamic var sFotoMedicamento: String = ""
	dynamic var sFotoPastillero: String? = nil
}