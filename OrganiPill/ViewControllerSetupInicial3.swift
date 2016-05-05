//
//  ViewControllerSetupInicial3.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/24/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerSetupInicial3: UIViewController, UITableViewDelegate, UITableViewDataSource, ProtocoloGuardarContacto {
	//outlets
	@IBOutlet weak var tbvTabla: UITableView!
	@IBOutlet weak var vwNoContactos: UIView!
	
	//variables
	var paciente: Persona!
	var doctor: Persona!
	var contactos = [Persona]()
	var filaSeleccionada: Int!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		tbvTabla.delegate = self
		tbvTabla.dataSource = self
    }
	
	override func viewWillAppear(animated: Bool) {
		if (contactos.count > 0) {
			tbvTabla.hidden = false
			vwNoContactos.hidden = true
		}
		else {
			tbvTabla.hidden = true
			vwNoContactos.hidden = false
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
		self.title = "Contactos"
    }
	
	// MARK: - UITableView
	
	// numero de filas de la table
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return contactos.count
	}
	
	
	
	// crea la celda de la tabla
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
		
		// Configure the cell...
		cell.textLabel?.text = contactos[indexPath.row].sNombre
		
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 0.2)
		cell.selectedBackgroundView = backgroundView
		
		cell.setNeedsDisplay()
		
		return cell
	}
	
	//MARK: Meotodos de protocolo contatco
	func guardaContacto(contacto: Persona) {
		contactos.append(contacto)
		tbvTabla.reloadData()
	}
	
	func editarContacto(contacto: Persona) {
		contactos[filaSeleccionada] = contacto
		tbvTabla.reloadData()
	}
	
	func borrar(contacto: Persona) {
		contactos.removeAtIndex(filaSeleccionada)
		tbvTabla.reloadData()
	}
	

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "segueContact" {
			let view = segue.destinationViewController as! ViewControllerAgregarContacto
			view.delegado = self
		}
		else if segue.identifier == "segueEdit" {
			let indexPath = tbvTabla.indexPathForSelectedRow
			let view = segue.destinationViewController as! ViewControllerAgregarContacto
			filaSeleccionada = indexPath!.row
			view.delegado = self
			view.sNombre = contactos[indexPath!.row].sNombre
			view.sTelefono = contactos[indexPath!.row].sTelefono
			view.sTelefono2 = contactos[indexPath!.row].sTelefonoSecundario
			view.sCorreoElectronico = contactos[indexPath!.row].sCorreoElectronico
		}
			
		else {
			let realm = try! Realm()
			var pacPaciente: Paciente = Paciente()
			
			paciente.sTipo = "p"
			doctor.sTipo = "d"
			
			for cont in contactos {
				cont.sTipo = "c"
			}
			
			pacPaciente.persona = paciente
			
			try! realm.write {
				realm.add(pacPaciente)
				realm.add(doctor)
				realm.add(contactos)
			}
		}
    }
	
	@IBAction func unwindContacto(sender: UIStoryboardSegue) {
		//en balnco... no se requiere hacer nada al regresar
	}
	

}
