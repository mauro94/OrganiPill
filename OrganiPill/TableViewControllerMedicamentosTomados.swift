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
		let medicamentosTomados = medicamentosTomadosAlertas.filter("id = 2").first?.listaNotificaciones
		let medicamentosAnulados = medicamentosTomadosAlertas.filter("id = 3").first?.listaNotificaciones
		if (medicamentosTomados != nil) {
			for med in medicamentosTomados! {
				let fechaMed = med.fechaAlerta
				let units: NSCalendarUnit = [.Weekday, .Day]
				let idDiaDeLaSemana = calendar.components(units, fromDate: dateFechaHoy)
				let fechaBoton = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: iDiaSemanaActual!+1 - idDiaDeLaSemana.weekday, toDate: dateFechaHoy, options: NSCalendarOptions.WrapComponents)
				
				let diaMed = calendar.components(units, fromDate: fechaMed)
				let diaHoy = calendar.components(units, fromDate: fechaBoton!)
				
				if (diaMed.day == diaHoy.day) {
					let nombreMed = med.nombreMed
					let medicamento = medicamentos.filter("sNombre == %@", nombreMed)
					medicamentosTabla.append(medicamento.first!)
					medicamentosTablaHoras.append(med.fechaAlerta)
				}
			}
		}
		
		if (medicamentosAnulados != nil) {
			for med in medicamentosAnulados! {
				let fechaMed = med.fechaAlerta
				let units: NSCalendarUnit = [.Weekday, .Day]
				let idDiaDeLaSemana = calendar.components(units, fromDate: dateFechaHoy)
				let fechaBoton = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: iDiaSemanaActual!+1 - idDiaDeLaSemana.weekday, toDate: dateFechaHoy, options: NSCalendarOptions.WrapComponents)
				
				let diaMed = calendar.components(units, fromDate: fechaMed)
				let diaHoy = calendar.components(units, fromDate: fechaBoton!)
				
				if (diaMed.day == diaHoy.day) {
					let nombreMed = med.nombreMed
					let medicamento = medicamentos.filter("sNombre == %@", nombreMed)
					medicamentosTabla.append(medicamento.first!)
					medicamentosTablaHoras.append(nil)
				}
			}
		}
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
		
		let lugar = medicamentosTabla.count - 1 - indexPath.row
		
		let formatoHoraConMeridiano = NSDateFormatter()
		formatoHoraConMeridiano.dateFormat = "h:mm a"
		
		if (medicamentosTablaHoras[lugar] != nil) {
			cell.lbHora.text = formatoHoraConMeridiano.stringFromDate(medicamentosTablaHoras[lugar]!)
		}
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


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
