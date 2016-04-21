//
//  ViewControllerSetupInicial1.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/19/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerSetupInicial1: UIViewController {
	//outlets
	@IBOutlet weak var tfNombre: UITextField!
	@IBOutlet weak var tfTelefono: UITextField!
	@IBOutlet weak var tfTelefono2: UITextField!
	@IBOutlet weak var tfCorreoElectronico: UITextField!
	
	//variables
	let color: UIColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 1)
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.title = "Información Personal"
		
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		self.navigationController?.navigationBar.barTintColor = color
		self.navigationController?.navigationBar.translucent = false
		self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func presionarSiguiente(sender: AnyObject) {
		let sNombre = tfNombre.text
		let sTelefono = tfTelefono.text
		let sTelefono2 = tfTelefono2.text
		let sCorreo = tfCorreoElectronico.text
		
		if (sNombre != nil && sTelefono != nil && sCorreo != nil) {
			let realm = try! Realm()
			
			let persona = Persona()
			persona.sNombre = sNombre!
			persona.sTelefono = sTelefono!
			if (sTelefono2 != nil) {
				persona.sTelefono = sTelefono2!
			}
			
			persona.sCorreoElectronico = sCorreo!
			
			try! realm.write {
				realm.add(persona)
			}
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
