//
//  ViewControllerCalendario.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/13/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ViewControllerCalendario: UIViewController, UITableViewDelegate, UITableViewDataSource {
	//OUTLETS-------------------------------------------
	//botones de cada dia
	@IBOutlet weak var btDomingo: UIButton!
	@IBOutlet weak var btLunes: UIButton!
	@IBOutlet weak var btMartes: UIButton!
	@IBOutlet weak var btMiercoles: UIButton!
	@IBOutlet weak var btJueves: UIButton!
	@IBOutlet weak var btViernes: UIButton!
	@IBOutlet weak var btSabado: UIButton!
	
	//labels de numero de dia
	@IBOutlet weak var lbDomingo: UILabel!
	@IBOutlet weak var lbLunes: UILabel!
	@IBOutlet weak var lbMartes: UILabel!
	@IBOutlet weak var lbMiercoles: UILabel!
	@IBOutlet weak var lbJueves: UILabel!
	@IBOutlet weak var lbViernes: UILabel!
	@IBOutlet weak var lbSabado: UILabel!
	
	//nombre del dia
	@IBOutlet weak var lbNombreDia: UILabel!
	
	//tabla medicamentos
	@IBOutlet weak var tbvMedicamentosPendientes: UITableView!
	
	//Vista no medicamentos
	@IBOutlet weak var viewNoMeds: UIView!
	//-----------------------------------------------------
	//VARIABLES
	let clBoton: UIColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 1)
	var botonesDias = [UIButton]()
	var lbNumeroDias = [UILabel]()
	let nombreDias = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sabádo"]
	var timer = NSTimer()
	let dateFechaHoy = NSDate()
	let calendar = NSCalendar.currentCalendar()
	
	let realm = try! Realm()
	var tomaDeMedicmanetos: Results<Notificaciones>!
	var medicamentos: Results<Medicamento>!
	var medicamentosTabla = [Medicamento]()
	var medicamentosTablaHoras = [NSDate]()

	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Calendario"
		
		//obtener datos de realm
		tomaDeMedicmanetos = realm.objects(Notificaciones)
		medicamentos = realm.objects(Medicamento)
		
		//crear arreglo de botones de dias
		botonesDias.append(btDomingo)
		botonesDias.append(btLunes)
		botonesDias.append(btMartes)
		botonesDias.append(btMiercoles)
		botonesDias.append(btJueves)
		botonesDias.append(btViernes)
		botonesDias.append(btSabado)
		
		//crear arreglos de labels de numeros de dias
		lbNumeroDias.append(lbDomingo)
		lbNumeroDias.append(lbLunes)
		lbNumeroDias.append(lbMartes)
		lbNumeroDias.append(lbMiercoles)
		lbNumeroDias.append(lbJueves)
		lbNumeroDias.append(lbViernes)
		lbNumeroDias.append(lbSabado)
		
		//obtener el nombre del dia de hoy
		var units: NSCalendarUnit = [.Weekday]
		let idDiaDeLaSemana = calendar.components(units, fromDate: dateFechaHoy)
		
		//actualizar numero de los dias
		units = [.Day]
		let diaDeLaSemana = calendar.components(units, fromDate: dateFechaHoy)
		actualizaNumeroDias(diaDeLaSemana.day, idDiaDeLaSemana: idDiaDeLaSemana.weekday)
		
		//encender boton del dia de hoy
		switch idDiaDeLaSemana.weekday {
			case 1:
				btPresionarBotonDia(btDomingo)
			case 2:
				btPresionarBotonDia(btLunes)
			case 3:
				btPresionarBotonDia(btMartes)
			case 4:
				btPresionarBotonDia(btMiercoles)
			case 5:
				btPresionarBotonDia(btJueves)
			case 6:
				btPresionarBotonDia(btViernes)
			case 7:
				btPresionarBotonDia(btSabado)
			default:
				print("ERROR")
		}
		
		//llama funcion que agrega UI a los botones
		agregarUIBoton()
		
		//confirgurar tabla de medicamentos pendientes
		tbvMedicamentosPendientes.delegate = self
		tbvMedicamentosPendientes.dataSource = self
    }
	
	
	override func viewWillAppear(animated: Bool) {
		//vista vacia
		if (medicamentosTabla.count > 0) {
			tbvMedicamentosPendientes.hidden = false
			viewNoMeds.hidden = true
		}
		else {
			tbvMedicamentosPendientes.hidden = true
			viewNoMeds.hidden = false
		}
	}
	
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	
	
	//Presionar boton del calendario
	@IBAction func btPresionarBotonDia(sender: AnyObject) {
		//cambiar todos los botones a blanco
		for boton in botonesDias {
			boton.layer.backgroundColor = UIColor.whiteColor().CGColor
			boton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
		}
		
		for label in lbNumeroDias {
			label.textColor = UIColor.blackColor()
		}
		
		//boton seleccionado cambiar color
		sender.layer.backgroundColor = clBoton.CGColor
		sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		
		let iUbicacionArreglo = botonesDias.indexOf(sender as! UIButton)
		lbNumeroDias[iUbicacionArreglo!].textColor = UIColor.whiteColor()
		
		//cambiar nombre del dia
		lbNombreDia.text = nombreDias[iUbicacionArreglo!]
		
		//llenar de datos la tabla
		medicamentosTabla.removeAll()
		medicamentosTablaHoras.removeAll()
	
		let medicamentosHoy = tomaDeMedicmanetos.filter("id = 1").first?.listaNotificaciones
		if (medicamentosHoy != nil) {
			for med in medicamentosHoy! {
				let fechaMed = med.fechaAlerta
				let units: NSCalendarUnit = [.Weekday, .Day]
				let idDiaDeLaSemana = calendar.components(units, fromDate: dateFechaHoy)
				let fechaBoton = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: iUbicacionArreglo!+1 - idDiaDeLaSemana.weekday, toDate: dateFechaHoy, options: NSCalendarOptions.WrapComponents)
				let diaMed = calendar.components(units, fromDate: fechaMed)
				
				let diaHoy = calendar.components(units, fromDate: fechaBoton!)
				
				if (diaMed.day == diaHoy.day) {
					let nombreMed = med.nombreMed
					let medicamento = medicamentos.filter("sNombre == %@", nombreMed)
					medicamentosTabla.append(medicamento.first!)
					medicamentosTablaHoras.append(med.fechaAlerta)
				}
			}
			tbvMedicamentosPendientes.reloadData()
		}
		
		//vista vacia
		if (medicamentosTabla.count > 0) {
			tbvMedicamentosPendientes.hidden = false
			viewNoMeds.hidden = true
		}
		else {
			tbvMedicamentosPendientes.hidden = true
			viewNoMeds.hidden = false
		}
	}
	
	
	
	//funcion que agrega UI a los botones
	func agregarUIBoton() {
		//agregar bordes
		for boton in botonesDias {
			agregaBorderButton(boton)
		}
		
		//modificar altura de los botones
		let constraints = btDomingo.constraints
		
		for constraint in constraints {
			if (constraint.identifier == "btAltura") {
				constraint.constant = view.bounds.width/7.0
			}
		}
		
		//agregar numero de dia si iphone 6 o mas grande
		if (view.frame.width >= 375) {
			//bajar letra del dia para poner numero del dia
			for boton in botonesDias {
				boton.contentVerticalAlignment = UIControlContentVerticalAlignment.Bottom
			}
			//hacer numeros de dias aparecer
			for label in lbNumeroDias {
				label.hidden = false
			}
		}
	}
	
	
	
	//funcion que agregar bordes a los botones
	func agregaBorderButton(sender: UIButton) {
		sender.layer.borderWidth = 0.5
		sender.layer.borderColor = clBoton.CGColor
	}
	
	
	
	//funcion que actualiza los numeros de los dias de la semana
	func actualizaNumeroDias(diaDeLaSemana: Int, idDiaDeLaSemana: Int) {
		//variables
		var i: Int = 0
		var numeroDiaHoy: Int
		
		//almacenar numero de dia hoy
		lbNumeroDias[idDiaDeLaSemana-1].text = "\(diaDeLaSemana)"
		
		//inicir un dia despues
		i = idDiaDeLaSemana
		
		//sumar dias
		while (i <= 7) {
			let dateTemp = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: i - idDiaDeLaSemana, toDate: dateFechaHoy, options: NSCalendarOptions.WrapComponents)
			
			let units: NSCalendarUnit = [.Day]
			let componentesTemp = calendar.components(units, fromDate: dateTemp!)
			
			numeroDiaHoy = componentesTemp.day
			
			lbNumeroDias[i-1].text = "\(numeroDiaHoy)"
			i += 1
		}
		
		i = idDiaDeLaSemana - 1
		
		//restar dias
		while (i > 0) {
			let dateTemp = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: -(idDiaDeLaSemana - i), toDate: dateFechaHoy, options: NSCalendarOptions.WrapComponents)
			
			let units: NSCalendarUnit = [.Day]
			let componentesTemp = calendar.components(units, fromDate: dateTemp!)
			
			numeroDiaHoy = componentesTemp.day
			
			lbNumeroDias[i-1].text = "\(numeroDiaHoy)"
			i -= 1
		}
	}
	
	
	
	
	// MARK: - UITableView

	// numero de filas de la table
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return medicamentosTabla.count
	}
	
	
	
	// crea la celda de la tabla
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell: tbcMedicamentoInfo = self.tbvMedicamentosPendientes.dequeueReusableCellWithIdentifier("cell") as! tbcMedicamentoInfo
		
		let data = medicamentosTabla[indexPath.row]
		let hora = medicamentosTablaHoras[indexPath.row]
		
		let formatoHoraConMeridiano = NSDateFormatter()
		formatoHoraConMeridiano.dateFormat = "h:mm a"
		
		cell.lbHora.text = formatoHoraConMeridiano.stringFromDate(hora)
		cell.lbNombreMedicamento.text = data.sNombre
		if (data.bNecesitaAlimento) {
			cell.imgIcono.image = UIImage(named: "checkIcon")
		}
		else {
			cell.imgIcono.image = UIImage(named: "crossIcon")
		}
		
		if (medicamentosTabla[indexPath.row] == medicamentosTabla[0]) {
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
		
		else if (medicamentosTabla[indexPath.row] == medicamentosTabla[medicamentosTabla.count-1]) {
			cell.bPrimerCelda = false
			cell.bUltimaCelda = true
			cell.bUnicaCelda = false
		}
		else {
			cell.bPrimerCelda = false
			cell.bUltimaCelda = false
			cell.bUnicaCelda = false
		}
		
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 0.2)
		cell.selectedBackgroundView = backgroundView
		
		cell.setNeedsDisplay()
		
		return cell
	}
	

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewVerMed = segue.destinationViewController as! ViewControllerMedicamentoCalendario
		let indexPath = tbvMedicamentosPendientes.indexPathForSelectedRow
		
		let hora = medicamentosTablaHoras[indexPath!.row]
		let medicamento = medicamentosTabla[indexPath!.row]
		
		let formatoHoraConMeridiano = NSDateFormatter()
		formatoHoraConMeridiano.dateFormat = "h:mm a"
		
		viewVerMed.sHora = formatoHoraConMeridiano.stringFromDate(hora)
		viewVerMed.bAlimento = medicamento.bNecesitaAlimento
		viewVerMed.sViaAdministracion = medicamento.sViaAdministracion
		viewVerMed.sDosis = "\(Int(medicamento.dDosis))"
		viewVerMed.sNombre = medicamento.sNombre
		viewVerMed.sTipoMed = medicamento.sViaAdministracion
		viewVerMed.horaMedicina = hora
    }


}
