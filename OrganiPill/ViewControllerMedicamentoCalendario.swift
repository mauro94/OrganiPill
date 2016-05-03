//
//  ViewControllerMedicamentoCalendario.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 5/2/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerMedicamentoCalendario: UIViewController, UITableViewDelegate, UITableViewDataSource {
	//OUTLETS
	@IBOutlet weak var viewInformacion: UIView!
	@IBOutlet weak var segSeccion: UISegmentedControl!
	
	@IBOutlet weak var lbHora: UILabel!
	@IBOutlet weak var imgAlimento: UIImageView!
	@IBOutlet weak var lbViaAdministracion: UILabel!
	@IBOutlet weak var lbDosis: UILabel!
	@IBOutlet weak var tablaSiguientesHoras: UITableView!
	@IBOutlet weak var lbTipoMed: UILabel!
	
	@IBOutlet weak var btTomoMedicamento: UIButton!
	@IBOutlet weak var btPosponer: UIButton!
	
	@IBOutlet weak var imgImagen: UIImageView!
	
	@IBOutlet weak var constraintSiBoton: NSLayoutConstraint!
	@IBOutlet weak var contraintNoBoton: NSLayoutConstraint!
	
	//VARIABLES
	var sHora: String!
	var bAlimento: Bool = false
	var sViaAdministracion: String!
	var sDosis: String!
	var sNombre: String!
	var sTipoMed: String!
	var horaMedicina: NSDate!
	
	var siguientesHoras: Results<Fecha>!
	
	let calendar = NSCalendar.currentCalendar()
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.title = sNombre
		
		lbHora.text = sHora
		if (bAlimento) {
			imgAlimento.image = UIImage(named: "checkIcon")
		}
		else {
			imgAlimento.image = UIImage(named: "crossIcon")
		}
		lbViaAdministracion.text = sViaAdministracion
		lbDosis.text = sDosis
		lbTipoMed.text = sTipoMed
		
		tablaSiguientesHoras.delegate = self
		tablaSiguientesHoras.dataSource = self
		
		//obtner datos de realm
		let realm = try! Realm()
		let tomaDeMedicmanetos = realm.objects(Notificaciones)
		
		//obtner lista de alertas de un medicamento
		let medicamentosPendientes = tomaDeMedicmanetos.filter("id = 1").first!.listaNotificaciones
		siguientesHoras = medicamentosPendientes.filter("nombreMed = %@", sNombre)
		print(siguientesHoras)
    }
	
	override func viewWillAppear(animated: Bool) {
		let units: NSCalendarUnit = [.Day, .Hour]
		let hora = calendar.components(units, fromDate: NSDate())
		let horaLimite = calendar.components(units, fromDate: horaMedicina)
		
		if (hora.hour > horaLimite.hour && hora.day >= horaLimite.day) {
			btPosponer.hidden = false;
			btTomoMedicamento.hidden = false
			contraintNoBoton.active = false
			constraintSiBoton.active = true
		}
		else {
			contraintNoBoton.active = true
			constraintSiBoton.active = false
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// MARK: - UITableView
	
	// numero de filas de la table
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return siguientesHoras.count
	}
	
	
	
	// crea la celda de la tabla
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell: tbcMedicamentoInfo = self.tablaSiguientesHoras.dequeueReusableCellWithIdentifier("cell") as! tbcMedicamentoInfo
		
		let formatoHoraConMeridiano = NSDateFormatter()
		formatoHoraConMeridiano.dateFormat = "MMMM d, h:mm a"
		
		cell.lbHora.text = formatoHoraConMeridiano.stringFromDate(siguientesHoras[indexPath.row].fechaAlerta)
		
		if (siguientesHoras[indexPath.row] == siguientesHoras[0]) {
			if (siguientesHoras.count == 1) {
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
			
		else if (siguientesHoras[indexPath.row] == siguientesHoras[siguientesHoras.count-1]) {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
