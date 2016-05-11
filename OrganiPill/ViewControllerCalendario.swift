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

class ViewControllerCalendario: UIViewController, UITableViewDelegate, UITableViewDataSource, ProtocoloReloadTable {
	//OUTLETS
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
	
	
	
	//VARIABLES
	let clBoton: UIColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 1)
	let colorDark = UIColor(red: 188.0/255.0, green: 53.0/255.0, blue: 73.0/255.0, alpha: 1)
	var botonesDias = [UIButton]()
	var lbNumeroDias = [UILabel]()
	var fechasCal = [NSDate(), NSDate(), NSDate(), NSDate(), NSDate(), NSDate(), NSDate()]
	let nombreDias = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sabádo"]
	var timer = NSTimer()
	var iBotonActivado: Int!
	let dateFechaHoy = NSDate()
	let calendar = NSCalendar.currentCalendar()
	
	let realm = try! Realm()
	var tomaDeMedicamentos: Results<Notificaciones>!
	var medicamentos: Results<Medicamento>!
	var medicamentosTabla = [Medicamento]()
	var medicamentosTablaHoras = [NSDate]()

	var swipeRight = UISwipeGestureRecognizer()
	var swipeLeft = UISwipeGestureRecognizer()
	var btCounter: Int = -1
	
	
	
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Calendario"
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
		
		//obtener datos de realm
		tomaDeMedicamentos = realm.objects(Notificaciones)
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
		
		//agregar gesture para cambiar dias
		swipeRight.addTarget(self, action: #selector(cambiarDiaGesture))
		swipeRight.direction = UISwipeGestureRecognizerDirection.Right
		
		swipeLeft.addTarget(self, action: #selector(cambiarDiaGesture))
		swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
		
		self.view.addGestureRecognizer(swipeRight)
		self.view.addGestureRecognizer(swipeLeft)
		cambiarDiaGesture(UISwipeGestureRecognizer())
		
		btCounter = idDiaDeLaSemana.weekday
		
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
		//vista vacia mostrar vista
		if (medicamentosTabla.count > 0) {
			tbvMedicamentosPendientes.hidden = false
			viewNoMeds.hidden = true
		}
		else {
			tbvMedicamentosPendientes.hidden = true
			viewNoMeds.hidden = false
            tbvMedicamentosPendientes.reloadData()
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
		
		//cambiar color de labels a negro
		for label in lbNumeroDias {
			label.textColor = UIColor.blackColor()
		}
		
		//boton seleccionado cambiar color
		sender.layer.backgroundColor = clBoton.CGColor
		sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
		
		let iUbicacionArreglo = botonesDias.indexOf(sender as! UIButton)
		iBotonActivado = iUbicacionArreglo
		lbNumeroDias[iUbicacionArreglo!].textColor = UIColor.whiteColor()
		
		//cambiar nombre del dia
		let formatoHoraConMeridiano = NSDateFormatter()
		formatoHoraConMeridiano.locale = NSLocale.init(localeIdentifier: "ES")
		formatoHoraConMeridiano.dateFormat = "EEEE, MMMM dd"
		
		lbNombreDia.text = formatoHoraConMeridiano.stringFromDate(fechasCal[iUbicacionArreglo!])
		
		btCounter = iUbicacionArreglo!+1
		
		//revisar notificaciones si pasaron de 4 horas
		revisarCondiciones(iUbicacionArreglo!)
		
		//revisar si vista esta vacia
		if (medicamentosTabla.count > 0) {
			tbvMedicamentosPendientes.hidden = false
			viewNoMeds.hidden = true
		}
		else {
			tbvMedicamentosPendientes.hidden = true
			viewNoMeds.hidden = false
		}
	}
	
	
	
	
	
	//funcion que revisa si pasaron 4 horas de un medicamento, si ya paso remover de calendario
	func revisarCondiciones(iUbicacionArreglo: Int) {
		let units: NSCalendarUnit = [.Weekday, .Day]
		
		//llenar de datos la tabla
		medicamentosTabla.removeAll()
		medicamentosTablaHoras.removeAll()
		
		//obtener lista de notificaciones pendientes
		let notificacionesDia = tomaDeMedicamentos.filter("id = 1").first?.listaNotificaciones
		
		//si hay notificaciones
		if (notificacionesDia != nil) {
			//por cada notificacion
			for notificacion in notificacionesDia! {
				//obtener fecha de Notificacion
				let fechaNotificacion = notificacion.fechaAlerta
				
				//obtener fecha de boton seleccionado
				let idDiaDeLaSemana = calendar.components(units, fromDate: dateFechaHoy)
				let fechaBoton = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: iUbicacionArreglo+1 - idDiaDeLaSemana.weekday, toDate: dateFechaHoy, options: NSCalendarOptions.WrapComponents)
				
				//obtener componentes de las fechas
				let diaNotificacion = calendar.components(units, fromDate: fechaNotificacion)
				let diaBoton = calendar.components(units, fromDate: fechaBoton!)
				
				//si son el mismo dia
				if (diaNotificacion.day == diaBoton.day) {
					let nombreMed = notificacion.nombreMed
					let medicamento = medicamentos.filter("sNombre == %@", nombreMed)
					
					if(medicamento.count != 0){
						medicamentosTabla.append(medicamento.first!)
						medicamentosTablaHoras.append(notificacion.fechaOriginal)
						
						
						//revisar si notificacion ya paso 4 horas de hora original
						if (revisar4Horas(notificacion)) {
							//sacar de la lista
							quitarNotificacionPendiente(fechaNotificacion, sNombre: nombreMed)
						}
					}
				}
			}
			tbvMedicamentosPendientes.reloadData()
		}
	}
	
	
	
	
	
	//revisa si fecha de medicina ya paso 4 horas
	func revisar4Horas(alerta: Fecha) -> Bool {
		//fecha original de la alerta
		let fechaOriginal = alerta.fechaOriginal
		
		//sumar 4 horas a la fecha
		let fechaLimite = calendar.dateByAddingUnit(NSCalendarUnit.Hour, value: 4, toDate: fechaOriginal, options: NSCalendarOptions.WrapComponents)
		
		//obtener fecha actual
		let fechaActual = NSDate()
		
		//si ya pasaron 4 horas
		if (fechaActual.earlierDate(fechaLimite!) == fechaLimite) {
				return true
		}
		return false
	}
	
	

	
	
	//funcion que quita las notificaciones caducadas
	func quitarNotificacionPendiente(fechaAlerta: NSDate, sNombre: String) {
		//saca las listas de notificaciones
		let realm = try! Realm()
		let listasNotif = realm.objects(Notificaciones)
		var fechaAux: Fecha = Fecha()
		
		try! realm.write{
			let listaPendientes = listasNotif.filter("id == 1").first!
			let listaAnuladas = listasNotif.filter("id == 3").first!
			
			//borrar notificacion actual de la lista de notificaciones
			for i in 0...listaPendientes.listaNotificaciones.count-1{
				//found a match
				if(listaPendientes.listaNotificaciones[i].fechaAlerta == fechaAlerta && listaPendientes.listaNotificaciones[i].nombreMed == sNombre){
					//guarda la fecha para usarla en la lista de tomadas
					fechaAux = listaPendientes.listaNotificaciones[i]
					
					//la borra de las pendientes
					listaPendientes.listaNotificaciones.removeAtIndex(i)
					break
				}
			}
			
			//guardar en lista tomadas
			fechaAux.fechaAlerta = NSDate()
			listaAnuladas.listaNotificaciones.append(fechaAux)
			
			//actualiza ambas listas
			realm.add(listaPendientes, update: true)
			realm.add(listaAnuladas, update: true)
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
		fechasCal[idDiaDeLaSemana-1] = dateFechaHoy
		
		//inicir un dia despues
		i = idDiaDeLaSemana
		
		//sumar dias
		while (i <= 7) {
			let dateTemp = calendar.dateByAddingUnit(NSCalendarUnit.Day, value: i - idDiaDeLaSemana, toDate: dateFechaHoy, options: NSCalendarOptions.WrapComponents)
			
			let units: NSCalendarUnit = [.Day]
			let componentesTemp = calendar.components(units, fromDate: dateTemp!)
			
			numeroDiaHoy = componentesTemp.day
			
			lbNumeroDias[i-1].text = "\(numeroDiaHoy)"
			fechasCal[i-1] = dateTemp!
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
			fechasCal[i-1] = dateTemp!
			i -= 1
		}
	}
	
	
	
	
	
	func cambiarDiaGesture(swipe: UIGestureRecognizer) {
		let swipeGesture = swipe as? UISwipeGestureRecognizer
		
		if (swipeGesture!.direction == UISwipeGestureRecognizerDirection.Right) {
			btCounter -= 1
			if (btCounter == 0) {
				btCounter = 7
			}
		}
		if (swipeGesture!.direction == UISwipeGestureRecognizerDirection.Left)  {
			btCounter += 1
			if (btCounter == 0) {
				btCounter = 1
			}
		}
		
		btCounter %= 8
		
		//encender boton del dia de hoy
		switch abs(btCounter) {
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
        formatoHoraConMeridiano.locale = NSLocale.init(localeIdentifier: "ES")
		formatoHoraConMeridiano.dateFormat = "h:mm a"
		
		cell.lbHora.text = formatoHoraConMeridiano.stringFromDate(hora)
		cell.lbNombreMedicamento.text = data.sNombre
		if (data.bNecesitaAlimento) {
			cell.imgIcono.image = UIImage(named: "checkIcon")
		}
		else {
			cell.imgIcono.image = UIImage(named: "crossIcon")
		}
		
		if (medicamentosTabla[indexPath.row] == medicamentosTabla[0] && indexPath.row == 0) {
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
		
		else if (medicamentosTabla[indexPath.row] == medicamentosTabla[medicamentosTabla.count-1] && indexPath.row == medicamentosTabla.count-1) {
			cell.bPrimerCelda = false
			cell.bUltimaCelda = true
			cell.bUnicaCelda = false
		}
		else {
			cell.bPrimerCelda = false
			cell.bUltimaCelda = false
			cell.bUnicaCelda = false
		}
		
		//si ya paso hora de medicamento para ser tomado
		let fechaActual = NSDate()
		
		if (hora.earlierDate(fechaActual) == hora) {
			cell.bPasoHora = true
			cell.lbHora.textColor = colorDark
			cell.lbHora.font = UIFont(name:"HelveticaNeue-Medium", size: 17.0)
			cell.lbHora.text = "TOMAR MEDICAMENTO"
		}
		else {
			cell.bPasoHora = false
			cell.lbHora.textColor = UIColor.blackColor()
			cell.lbHora.font = UIFont(name:"HelveticaNeue", size: 17.0)
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
		if (segue.identifier == "verMedicamento") {
			let viewVerMed = segue.destinationViewController as! ViewControllerMedicamentoCalendario
			let indexPath = tbvMedicamentosPendientes.indexPathForSelectedRow
			
			let hora = medicamentosTablaHoras[indexPath!.row]
			let medicamento = medicamentosTabla[indexPath!.row]
			
			let formatoHoraConMeridiano = NSDateFormatter()
            formatoHoraConMeridiano.locale = NSLocale.init(localeIdentifier: "ES")
			formatoHoraConMeridiano.dateFormat = "h:mm a"
			
			viewVerMed.sHora = formatoHoraConMeridiano.stringFromDate(hora)
			viewVerMed.bAlimento = medicamento.bNecesitaAlimento
			viewVerMed.sViaAdministracion = medicamento.sTipoMedicina
			viewVerMed.sDosis = "\(Int(medicamento.dDosisRecetada))"
			viewVerMed.sNombre = medicamento.sNombre
			viewVerMed.sTipoMed = medicamento.sTipoMedicina
			viewVerMed.horaMedicina = hora
			viewVerMed.sImgMedicamento = medicamento.sFotoMedicamento
			viewVerMed.sImgCaja = medicamento.sFotoCaja
			viewVerMed.sImgPastillero = medicamento.sFotoPastillero
            viewVerMed.delegado = self

		}
		else {
			let viewTomados = segue.destinationViewController as! TableViewControllerMedicamentosTomados
			viewTomados.iDiaSemanaActual = iBotonActivado
		}
		
    }
    
    func reloadTable(){
        //obtener datos de realm
        tomaDeMedicamentos = realm.objects(Notificaciones)
        medicamentos = realm.objects(Medicamento)
        
        //obtener el nombre del dia de hoy
        var units: NSCalendarUnit = [.Weekday]
        let idDiaDeLaSemana = calendar.components(units, fromDate: dateFechaHoy)
        
        btCounter = idDiaDeLaSemana.weekday
        
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
        
        tbvMedicamentosPendientes.reloadData()
    }
    
    func quitaVista(){
        navigationController?.popViewControllerAnimated(true)
    }


}
