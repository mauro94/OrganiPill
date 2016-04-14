//
//  ViewControllerCalendario.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/13/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class ViewControllerCalendario: UIViewController {
	//outlets
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
	
	//variables
	let clBoton: UIColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 1)
	var botonesDias = [UIButton]()
	var lbNumeroDias = [UILabel]()
	
	

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
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
	
	//funcion que agregar bordes
	func agregaBorderButton(sender: UIButton) {
		sender.layer.borderWidth = 0.5
		sender.layer.borderColor = UIColor.blackColor().CGColor
	}
	
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
	
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
