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
	//outlets-------------------------------------------
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
	
	//-----------------------------------------------------
	//variables
	let clBoton: UIColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 1)
	var botonesDias = [UIButton]()
	var lbNumeroDias = [UILabel]()
	let nombreDias = ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sabádo"]
	var timer = NSTimer()
	
	let realm = try! Realm()
	var medicamentos: Results<Medicamento>!
	var iNumeroMeds: Int = 0
	var iNumeroDiaListaBotones: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Calendario"
		
		//realm
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
		let dateFechaHoy = NSDate()
		let dateFormatter = NSDateFormatter()
		dateFormatter.locale = NSLocale(localeIdentifier: "es")
		dateFormatter.dateFormat = "EEEE"
		let diaDeLaSemana = dateFormatter.stringFromDate(dateFechaHoy)
		
		//actualizar numero de los dias
		actualizaNumeroDias(diaDeLaSemana, dateFechaHoy: dateFechaHoy, dateFormatter: dateFormatter)
		
		//encender boton del dia de hoy
		switch diaDeLaSemana {
		case "domingo":
			btPresionarBotonDia(btDomingo)
		case "lunes":
			btPresionarBotonDia(btLunes)
		case "martes":
			btPresionarBotonDia(btMartes)
		case "miércoles":
			btPresionarBotonDia(btMiercoles)
		case "jueves":
			btPresionarBotonDia(btJueves)
		case "viernes":
			btPresionarBotonDia(btViernes)
		case "sabádo":
			btPresionarBotonDia(btSabado)
		default:
			print("ERROR")
		}
		
		//llama funcion que agrega UI a los botones
		agregarUIBoton()
		
		//confirgurar tabla de medicamentos pendientes
		tbvMedicamentosPendientes.delegate = self
		tbvMedicamentosPendientes.dataSource = self
		
		//vista vacia
		if (iNumeroMeds == 0) {
			var lbMensaje: UILabel = UILabel.init(frame: CGRectMake(0, 0, tbvMedicamentosPendientes.bounds.size.width, tbvMedicamentosPendientes.bounds.size.height))
			lbMensaje.text = "¡No más medicamentos hoy!"
			lbMensaje.textAlignment = NSTextAlignment.Center
			
			
			//UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, yourTableView.bounds.size.width, yourTableView.bounds.size.height)];
			//noDataLabel.text             = @"No data available";
			//noDataLabel.textColor        = [UIColor blackColor];
			//noDataLabel.textAlignment    = NSTextAlignmentCenter;
			tbvMedicamentosPendientes.backgroundView = lbMensaje;
			tbvMedicamentosPendientes.separatorStyle = UITableViewCellSeparatorStyle.None
		}
    }
	
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	
	
	//Presionar boton del calendario
	@IBAction func btPresionarBotonDia(sender: AnyObject) {
		//cambair todos los botones a blanco
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
		
		//cargar informacion a la tabla
		//definie dia de boton presionado
		switch sender as! UIButton {
		case btDomingo:
			iNumeroDiaListaBotones = 1
		case btLunes:
			iNumeroDiaListaBotones = 2
		case btMartes:
			iNumeroDiaListaBotones = 3
		case btMiercoles:
			iNumeroDiaListaBotones = 4
		case btJueves:
			iNumeroDiaListaBotones = 5
		case btViernes:
			iNumeroDiaListaBotones = 6
		case btSabado:
			iNumeroDiaListaBotones = 7
		default:
			iNumeroDiaListaBotones = 0
		}
		
		//filtro de query realm
		let infoTabla = medicamentos.filter("ANY horario.listaDias.dia = %@", iNumeroDiaListaBotones)
		print(infoTabla)
		//infoTabla = infoTablas as NSArray as! [Results<Medicamento>]
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
	func actualizaNumeroDias(diaDeLaSemana: String, dateFechaHoy: NSDate, dateFormatter: NSDateFormatter) {
		//variables
		var iUbicacionArreglo: Int = 0
		var i: Int = 0
		var numeroDiaHoy: String
		
		//formato de dias
		dateFormatter.dateFormat = "dd"
		
		//definir ubicacion actual en el arreglo de dias
		switch diaDeLaSemana {
			case "domingo":
				iUbicacionArreglo = 0
			case "lunes":
				iUbicacionArreglo = 1
			case "martes":
				iUbicacionArreglo = 2
			case "miércoles":
				iUbicacionArreglo = 3
			case "jueves":
				iUbicacionArreglo = 4
			case "viernes":
				iUbicacionArreglo = 5
			case "sabádo":
				iUbicacionArreglo = 6
			default:
				print("ERROR")
		}
		
		//almacenar numero de dia hoy
		numeroDiaHoy = dateFormatter.stringFromDate(dateFechaHoy)
		lbNumeroDias[iUbicacionArreglo].text = numeroDiaHoy
		
		//inicir un dia despues
		i = iUbicacionArreglo + 1
		
		//sumar dias
		while (i <= 6) {
			let dateTemp = NSDate(timeIntervalSinceNow: Double(i - iUbicacionArreglo)*24*60*60)
			
			numeroDiaHoy = dateFormatter.stringFromDate(dateTemp)
			
			lbNumeroDias[i].text = numeroDiaHoy
			i += 1
		}
		
		i = iUbicacionArreglo
		
		//restar dias
		while (i >= 0) {
			let dateTemp = NSDate(timeIntervalSinceNow: Double(iUbicacionArreglo - i)*(-24)*60*60)
			
			numeroDiaHoy = dateFormatter.stringFromDate(dateTemp)
			
			lbNumeroDias[i].text = numeroDiaHoy
			i -= 1
		}
	}
	
	
	
	//funcion que crea qle reloj
	/*@objc func tick() {
		lbReloj.text = NSDateFormatter.localizedStringFromDate(NSDate(),
		                        dateStyle: .NoStyle,
		                        timeStyle: .MediumStyle)
	}*/
	
	
	
	// MARK: - UITableView

	// numero de filas de la table
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let infoTabla = medicamentos.filter("ANY horario.listaDias.dia = %@", iNumeroDiaListaBotones)
		return 0
	}
	
	
	
	// crea la celda de la tabla
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell: tbcMedicamentoInfo = self.tbvMedicamentosPendientes.dequeueReusableCellWithIdentifier("cell") as! tbcMedicamentoInfo
		
		//let data = infoTabla[indexPath.row]
		//print(data)
		
		//cell.lbNombreMedicamento.text = data.sNombre
		
		/*if (infoTabla[indexPath.row] == infoTabla[0]) {
			cell.bPrimerCelda = true
			cell.bUltimaCelda = false
		}
		
		else if (infoTabla[indexPath.row] == infoTabla[infoTabla.count-1]) {
			cell.bPrimerCelda = false
			cell.bUltimaCelda = true
		}
		else {
			cell.bPrimerCelda = false
			cell.bUltimaCelda = false
		}*/
		
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 0.2)
		cell.selectedBackgroundView = backgroundView
		
		cell.setNeedsDisplay()
		
		return cell
	}


	/*override func viewDidAppear(animated: Bool) {
		super.viewWillAppear(animated)
		tbvMedicamentosPendientes.deselectRowAtIndexPath(tbvMedicamentosPendientes.indexPathForSelectedRow!, animated: true)
	}*/
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
