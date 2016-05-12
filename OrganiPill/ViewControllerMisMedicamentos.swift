//
//  ViewControllerMisMedicamentos.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 5/12/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerMisMedicamentos: UIViewController, UITableViewDelegate, UITableViewDataSource, ProtocoloReloadTable {
	//OUTLETS
	@IBOutlet weak var tablaMedicamentos: UITableView!
	@IBOutlet weak var viewNoMeds: UIView!
	
	//VARIABLES
	var indice : Int!
	var perPersona = Persona()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Mis Medicamentos"
		
		tablaMedicamentos.delegate = self
		tablaMedicamentos.dataSource = self
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(animated: Bool) {
		let realm = try! Realm()
		
		//vista vacia mostrar vista
		if (realm.objects(Medicamento).count > 0) {
			tablaMedicamentos.hidden = false
			viewNoMeds.hidden = true
		}
		else {
			tablaMedicamentos.hidden = true
			viewNoMeds.hidden = false
		}
		
		tablaMedicamentos.reloadData()
	}
	
	// MARK: - Table view data source
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let realm = try! Realm()
		//Saca la cantidad de medicamentos registrados
		
		return realm.objects(Medicamento).count
	}
	
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  
		
		let cell: TableViewCellMedicamento = tableView.dequeueReusableCellWithIdentifier("medicamento", forIndexPath: indexPath) as! TableViewCellMedicamento
		
		let realm = try! Realm()
		
		
		
		let current = realm.objects(Medicamento)[indexPath.row]
		// Configure the cell...
		
		//var num : Int = current.horario[0].listaDias[3]
		
		
		//checa los dias en que se debe tomar el medicamento y marca la letra en rojo
		for h in 0...(current.horario.count - 1) {
			
			for d in 0...(current.horario[h].listaDias.count - 1 ){
				
				let valor = current.horario[h].listaDias[d]
				let aux1: Int = valor.dia
				
				if(aux1 == 2){
					cell.lblLunes.textColor = UIColor.redColor()
				}
				else if(aux1 == 3){
					cell.lblMartes.textColor = UIColor.redColor()
				}
				else if(aux1 == 4){
					cell.lblMiercoles.textColor = UIColor.redColor()
				}
				else if(aux1 == 5){
					cell.lblJueves.textColor = UIColor.redColor()
				}
				else if(aux1 == 6){
					cell.lblViernes.textColor = UIColor.redColor()
				}
				else if(aux1 == 7){
					cell.lblSabado.textColor = UIColor.redColor()
				}
				else if(aux1 == 1){
					cell.lblDomingo.textColor = UIColor.redColor()
				}
			}
			
		}
		
		
		//llena la cell con la imagen y nombre del medicamento
		cell.lbNombreMedicamento.text =  current.sNombre
		
		cell.imMedicamento.image = UIImage(contentsOfFile: current.sFotoMedicamento)
		
		cell.imCaja.image = UIImage(contentsOfFile: current.sFotoCaja)
		
		
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 0.2)
		cell.selectedBackgroundView = backgroundView
		
		cell.setNeedsDisplay()
		
		return cell
	}
	

	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let view = segue.destinationViewController as! ViewControllerVerMedicamento
		
		let indexPath = tablaMedicamentos.indexPathForSelectedRow
		
		let realm = try! Realm()
		
		//manda el medicamento del renglon seleccionado
		let current = realm.objects(Medicamento)[indexPath!.row]
		
		
		view.indexMedicamento = current
		
		view.delegado = self
		
	}
	
	@IBAction func unwindView(sender: UIStoryboardSegue) {
		//en balnco... no se requiere hacer nada al regresar
	}
	
	func reloadTable() {
		tablaMedicamentos.reloadData()
	}
	
	func quitaVista() {
		
	}

}
