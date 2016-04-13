//
//  ViewControllerCalendario.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/13/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

@IBDesignable class ViewControllerCalendario: UIViewController {
	//outlets
	@IBOutlet weak var btDomingo: UIButton!
	@IBOutlet weak var btLunes: UIButton!
	@IBOutlet weak var btMartes: UIButton!
	@IBOutlet weak var btMiercoles: UIButton!
	@IBOutlet weak var btJueves: UIButton!
	@IBOutlet weak var btViernes: UIButton!
	@IBOutlet weak var btSabado: UIButton!
	
	//variables
	var clBoton: UIColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 1)
	var botonesDias = [UIButton]()
	

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
		
		//boton seleccionado cambiar color
		sender.layer.backgroundColor = clBoton.CGColor
		sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
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
				print(view.bounds.width/7.0)
			}
		}

	}
	
	//funcion que agregar bordes
	func agregaBorderButton(sender: UIButton) {
		sender.layer.borderWidth = 1
		sender.layer.borderColor = UIColor.blackColor().CGColor
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
