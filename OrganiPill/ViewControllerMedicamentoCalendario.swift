//
//  ViewControllerMedicamentoCalendario.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 5/2/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

protocol ProtocoloReloadTable{
    func reloadTable()
    func quitaVista()
}

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
	@IBOutlet weak var pager: UIPageControl!
	@IBOutlet weak var viewImagen: UIView!
	
	@IBOutlet weak var constraintSiBoton: NSLayoutConstraint!
	@IBOutlet weak var contraintNoBoton: NSLayoutConstraint!
	@IBOutlet weak var constraintSiBotonImg: NSLayoutConstraint!
	@IBOutlet weak var constraintNoBotonImg: NSLayoutConstraint!
	
	//VARIABLES
	var sHora: String!
	var bAlimento: Bool = false
	var sViaAdministracion: String!
	var sDosis: String!
	var sNombre: String!
	var sTipoMed: String!
	var horaMedicina: NSDate! //hora alerta
	var sImgMedicamento: String!
	var sImgCaja: String!
	var sImgPastillero: String? = nil
	
	var siguientesHoras: Results<Fecha>!
	
	let calendar = NSCalendar.currentCalendar()
	
	var swipeRight = UISwipeGestureRecognizer()
	var swipeLeft = UISwipeGestureRecognizer()
	var imgCounter: Int = -1
    
    var delegado = ProtocoloReloadTable!(nil)

	
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
		
		//obtener datos de realm
		//let realm = try! Realm()
		//let tomaDeMedicamentos = realm.objects(Notificaciones)
		
		//obtener lista de alertas de un medicamento
		//let medicamentosPendientes = tomaDeMedicamentos.filter("id = 1").first!.listaNotificaciones
		//siguientesHoras = medicamentosPendientes.filter("nombreMed = %@", sNombre)
        
        getSiguientesHoras()
		
		//agregar gesture para cambiar imagenes
		swipeRight.addTarget(self, action: #selector(cambiarImagen))
		swipeRight.direction = UISwipeGestureRecognizerDirection.Right
		
		swipeLeft.addTarget(self, action: #selector(cambiarImagen))
		swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
		
		viewImagen.addGestureRecognizer(swipeRight)
		viewImagen.addGestureRecognizer(swipeLeft)
		cambiarImagen(UISwipeGestureRecognizer())
		
		//definir imagenes
		imgImagen.image = UIImage(contentsOfFile: sImgMedicamento)
		if (sImgPastillero == nil) {
			pager.numberOfPages = 2
		}
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            delegado.reloadTable()
        }
    }
    
    func getSiguientesHoras(){
        //obtener datos de realm
        let realm = try! Realm()
        let tomaDeMedicamentos = realm.objects(Notificaciones)
        
        //obtener lista de alertas de un medicamento
        let medicamentosPendientes = tomaDeMedicamentos.filter("id = 1").first!.listaNotificaciones
        siguientesHoras = medicamentosPendientes.filter("nombreMed = %@", sNombre)
    }
	
	override func viewWillAppear(animated: Bool) {
		cambiarVista(segSeccion)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func cambiarVista(sender: UISegmentedControl) {
		let fechaActual = NSDate()
		
		if (sender.selectedSegmentIndex == 0) {
			viewInformacion.hidden = false
			viewImagen.hidden = true
			
			if (fechaActual.earlierDate(horaMedicina) == horaMedicina) {
				btPosponer.hidden = false
				btTomoMedicamento.hidden = false
				contraintNoBoton.priority = 1
				constraintSiBoton.priority = 750
			}
			else {
				contraintNoBoton.priority = 750
				constraintSiBoton.priority = 1
			}
		}
		else {
			viewInformacion.hidden = true
			viewImagen.hidden = false
			
			if (fechaActual.earlierDate(horaMedicina) == horaMedicina) {
				btPosponer.hidden = false
				btTomoMedicamento.hidden = false
				constraintNoBotonImg.priority = 1
				constraintSiBotonImg.priority = 750
			}
			else {
				constraintNoBotonImg.priority = 750
				constraintSiBotonImg.priority = 1
			}
		}
	}
	
	func cambiarImagen(swipe: UIGestureRecognizer) {
		let swipeGesture = swipe as? UISwipeGestureRecognizer
		
		if (swipeGesture!.direction == UISwipeGestureRecognizerDirection.Right) {
			imgCounter += 1
		}
		if (swipeGesture!.direction == UISwipeGestureRecognizerDirection.Left)  {
			imgCounter -= 1
		}
		
		if (sImgPastillero != nil) {
			imgCounter %= 3
		}
		else {
			imgCounter %= 2
		}
		
		pager.currentPage = abs(imgCounter)
		
		switch abs(imgCounter) {
		case 0:
			imgImagen.image = UIImage(contentsOfFile: sImgMedicamento)
		case 1:
			imgImagen.image = UIImage(contentsOfFile: sImgCaja)
		case 2:
			imgImagen.image = UIImage(contentsOfFile: sImgPastillero!)
		default:
			print("ERROR")
		}
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
		formatoHoraConMeridiano.locale = NSLocale.init(localeIdentifier: "ES")
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
    
    @IBAction func presionaTomar(sender: UIButton) {
        var fechaAux = Fecha()
        
        //se cancela la notificacion que mandó a esta vista
        //UIApplication.sharedApplication().cancelLocalNotification(notificacion)
        
        //saca las listas de notificaciones
        let realm = try! Realm()
        let listasNotif = realm.objects(Notificaciones)
        
        try! realm.write{
            var listaPendientes = listasNotif.filter("id == 1").first!
            var listaTomadas = listasNotif.filter("id == 2").first!
            
            //borrar notificacion actual de la lista de notificaciones
            for i in 0...listaPendientes.listaNotificaciones.count-1{
                //found a match
                if(listaPendientes.listaNotificaciones[i].fechaAlerta == horaMedicina && listaPendientes.listaNotificaciones[i].nombreMed == sNombre){
                    //guarda la fecha para usarla en la lista de tomadas
                    fechaAux = listaPendientes.listaNotificaciones[i]
                    
                    //la borra de las pendientes
                    listaPendientes.listaNotificaciones.removeAtIndex(i)
                    break
                }
            }
            
            //guardar en lista tomadas
            fechaAux.fechaAlerta = NSDate()
            listaTomadas.listaNotificaciones.append(fechaAux)
            
            //actualiza ambas listas
            realm.add(listaPendientes, update: true)
            realm.add(listaTomadas, update: true)
            
        }
        //hace un reschedule de las notificaciones
        let notif : HandlerNotificaciones = HandlerNotificaciones()
        notif.rescheduleNotificaciones()
        
        getSiguientesHoras()
        tablaSiguientesHoras.reloadData()
        delegado.reloadTable()
        delegado.quitaVista()
    }
    
    
    @IBAction func presionaPosponer(sender: UIButton) {
        var fechaAux = Fecha()
        
        //saca las listas de notificaciones
        let realm = try! Realm()
        let listasNotif = realm.objects(Notificaciones)
        
        try! realm.write{
            let listaPendientes = listasNotif.filter("id == 1").first!
            
            //borrar notificacion actual de la lista de notificaciones
            for i in 0...listaPendientes.listaNotificaciones.count-1{
                //found a match
                if(listaPendientes.listaNotificaciones[i].fechaAlerta == horaMedicina && listaPendientes.listaNotificaciones[i].nombreMed == sNombre){
                    //guarda la fecha para usarla despues
                    fechaAux = listaPendientes.listaNotificaciones[i]
                    
                    //la borra de las pendientes
                    listaPendientes.listaNotificaciones.removeAtIndex(i)
                    break
                }
            }
            
            //TODO-Snooze
            //genera la nueva fecha y la agrega a la lista
            let nuevaFecha = NSDate(timeIntervalSinceNow: Double(5)*60)
            fechaAux.fechaAlerta = nuevaFecha
            listaPendientes.listaNotificaciones.append(fechaAux)
            
            //actualiza la lista de notificaciones en REALM
            realm.add(listaPendientes, update: true)
            
        }
        //hace un reschedule de las notificaciones
        let notif : HandlerNotificaciones = HandlerNotificaciones()
        notif.rescheduleNotificaciones()
        
        getSiguientesHoras()
        tablaSiguientesHoras.reloadData()
        delegado.reloadTable()
        delegado.quitaVista()
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
