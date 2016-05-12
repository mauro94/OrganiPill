//
//  TableViewControllerMedicamentosTomados.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/17/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewControllerMedicamentosTomados: UITableViewController {
	//OUTLETS
	@IBOutlet var tbvTable: UITableView!
	
	
	//VARIABLES
	var iDiaSemanaActual: Int!

	var medicamentosTabla = [Medicamento]()
	var medicamentosTablaHoras = [NSDate?]()
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Medicamentos Tomados"
		
		//obtner datos de realm
		let realm = try! Realm()
		let medicamentos = realm.objects(Medicamento)
		let medicamentosTomadosAlertas = realm.objects(Notificaciones)
		
		//obtener datos para tabla
		let calendar = NSCalendar.currentCalendar()
		let dateFechaHoy = NSDate()
		//obtener notificaciones pasadas/tomadas y anuladas
		let medicamentosTomados = medicamentosTomadosAlertas.filter("id = 2").first?.listaNotificaciones
		let medicamentosAnulados = medicamentosTomadosAlertas.filter("id = 3").first?.listaNotificaciones
		
		//si hay notificaciones tomadas
		if (medicamentosTomados != nil) {
			//por cada notificacion tomada
			for med in medicamentosTomados! {
				//obtener fecha de la alerta
				let fechaMed = med.fechaAlerta
				//unidades de calendario
				let units: NSCalendarUnit = [.Weekday, .Day]
				//numero de dia de la semana 1...7
				let idDiaDeLaSemana = calendar.components(units, fromDate: dateFechaHoy)
				//fecha del boton seleccionado actual
				let fechaBoton = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: iDiaSemanaActual!+1 - idDiaDeLaSemana.weekday, toDate: dateFechaHoy, options: NSCalendarOptions.WrapComponents)
				
				//componentes de fecha de alerta
				let diaMed = calendar.components(units, fromDate: fechaMed)
				//componentes de fecha del boton seleccionado
				let diaHoy = calendar.components(units, fromDate: fechaBoton!)
				
				//si son el mismo dia
				if (diaMed.day == diaHoy.day) {
					//llenar tabla con datos
					let nombreMed = med.nombreMed
					let medicamento = medicamentos.filter("sNombre == %@", nombreMed)
                    if(medicamento.first != nil){
                        medicamentosTabla.append(medicamento.first!)
                        medicamentosTablaHoras.append(med.fechaAlerta)
                        
                    }
					
				}
			}
		}
		
		//si hay notificaciones anuladas
		if (medicamentosAnulados != nil) {
			//por cada notificacion anulada
			for med in medicamentosAnulados! {
				//obtener fecha de la alerta
				let fechaMed = med.fechaAlerta
				//unidades de calendario
				let units: NSCalendarUnit = [.Weekday, .Day]
				//numero de dia de la semana 1...7
				let idDiaDeLaSemana = calendar.components(units, fromDate: dateFechaHoy)
				//fecha del boton seleccionado actual
				let fechaBoton = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: iDiaSemanaActual!+1 - idDiaDeLaSemana.weekday, toDate: dateFechaHoy, options: NSCalendarOptions.WrapComponents)
				
				//componentes de fecha de alerta
				let diaMed = calendar.components(units, fromDate: fechaMed)
				//componentes de fecha del boton seleccionado
				let diaHoy = calendar.components(units, fromDate: fechaBoton!)
				
				//si son el mismo dia
				if (diaMed.day == diaHoy.day) {
					//llenar tabla con datos
					let nombreMed = med.nombreMed
					let medicamento = medicamentos.filter("sNombre == %@", nombreMed)
					medicamentosTabla.append(medicamento.first!)
					medicamentosTablaHoras.append(nil)
				}
			}
		}
		//actualizar tabla
		tbvTable.reloadData()
    }
	
	
	
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	
	
	

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
	
	
	

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medicamentosTabla.count
    }
	
	

	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: tbcMedicamentoInfo = self.tbvTable.dequeueReusableCellWithIdentifier("cell") as! tbcMedicamentoInfo
		
		//llenar datos medicamento
		let lugar = medicamentosTabla.count - 1 - indexPath.row
		
		//formato de fecha
		let formatoHoraConMeridiano = NSDateFormatter()
        formatoHoraConMeridiano.locale = NSLocale.init(localeIdentifier: "ES")
		formatoHoraConMeridiano.dateFormat = "h:mm a"
		
		//si no es notificacion nula
		if (medicamentosTablaHoras[lugar] != nil) {
			cell.lbHora.text = formatoHoraConMeridiano.stringFromDate(medicamentosTablaHoras[lugar]!)
		}
			//si es notificacion nula
		else {
			cell.lbHora.text = "NO TOMADO"
		}
		
		cell.lbNombreMedicamento.text = medicamentosTabla[lugar].sNombre
		
		if (medicamentosTabla[lugar] == medicamentosTabla[medicamentosTabla.count-1] && lugar == medicamentosTabla.count-1) {
			if (medicamentosTabla.count == 1) {
				cell.bUnicaCelda = true
				cell.bPrimerCelda = false
				cell.bUltimaCelda = false
			}
			else {
				cell.bPrimerCelda = true
				cell.bUltimaCelda = false
				cell.bUnicaCelda = false
			}
		}
			
		else if (medicamentosTabla[lugar] == medicamentosTabla[0] && lugar == 0) {
			cell.bPrimerCelda = false
			cell.bUltimaCelda = true
			cell.bUnicaCelda = false
		}
		else {
			cell.bPrimerCelda = false
			cell.bUltimaCelda = false
			cell.bUnicaCelda = false
		}

		
        return cell
	}
}
