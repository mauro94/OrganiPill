//
//  NotificacionViewController.swift
//  OrganiPill
//
//  Created by David Benitez on 5/1/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class NotificacionViewController: UIViewController {

    //variables
    var sNombre : String!
    var fechaAlerta : NSDate!
    var fechaOriginal : NSDate!
    var notificacion : UILocalNotification!
    var medicina = Medicamento()
	var swipeRight = UISwipeGestureRecognizer()
	var swipeLeft = UISwipeGestureRecognizer()
	var imgCounter: Int = -1
	let color: UIColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 1)
    
    //Outlets
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblHora: UILabel!
    @IBOutlet weak var lblComida: UILabel!
    @IBOutlet weak var lblDosis: UILabel!
	@IBOutlet weak var viewInfo: UIView!
	@IBOutlet weak var imgImage: UIImageView!
	@IBOutlet weak var pager: UIPageControl!
	@IBOutlet weak var viewImg: UIView!
	@IBOutlet weak var sgmSegment: UISegmentedControl!
	@IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDatos()
		
		navBar.topItem?.title = medicina.sNombre
		
		//agregar gesture para cambiar imagenes
		swipeRight.addTarget(self, action: #selector(cambiarFoto))
		swipeRight.direction = UISwipeGestureRecognizerDirection.Right
		
		swipeLeft.addTarget(self, action: #selector(cambiarFoto))
		swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
		
		viewImg.addGestureRecognizer(swipeRight)
		viewImg.addGestureRecognizer(swipeLeft)
		cambiarFoto(UISwipeGestureRecognizer())
		
		navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		navBar.tintColor = UIColor.whiteColor()
		navBar.barTintColor = color
		navBar.translucent = false
		navBar.barStyle = UIBarStyle.Black
		
		self.view.setNeedsDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
    
    //genera los textos para los labels
    func setDatos(){

        let realm = try! Realm()
        let resMedicina = realm.objects(Medicamento).filter("sNombre == %@", sNombre)
        medicina = resMedicina.first!
        
        let formatoHora = NSDateFormatter()
        formatoHora.locale = NSLocale.init(localeIdentifier: "ES")
        formatoHora.dateFormat = "EEEE, dd 'de' MMMM h:mm a"

        lblNombre.text = sNombre
        lblTipo.text = medicina.sTipoMedicina
        lblHora.text = formatoHora.stringFromDate(fechaAlerta)
        
        if(medicina.bNecesitaAlimento){
            lblComida.text = "Necesita alimento"
        }
        else{
            lblComida.text = "No necesita alimento"
        }
        
        lblDosis.text = String(medicina.dDosisRecetada)
		
		//definir imagenes
		imgImage.image = UIImage(contentsOfFile: medicina.sFotoMedicamento)
		if (medicina.sFotoPastillero == nil) {
			pager.numberOfPages = 2
		}

    }
    
    //maneja la accion de tomar medicina
    @IBAction func presionaTomarMedicina(sender: UIButton) {
        tomarMed()
        
        let realm = try! Realm()
        
        try! realm.write{
            //se reduce la cantidad de medicina (pastillas, cucharadas) por la dosis tomada
            medicina.dCantidadPorCajaActual -= medicina.dDosisRecetada
        }
        
        //BUG: Usar el UIAlert genera un bug en el calendario
        /**let returnTrue = {
            () -> ((UIAlertAction!) -> ()) in
            return {
                _ in
                self.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("tomarMedicina", sender: sender)
    		}
		}

        //se crean alertas para recordar al usuario
        //si queda menos de un 25% de la cantidad original
        if(medicina.dCantidadPorCajaActual <= medicina.dCantidadPorCaja*0.10){
            let alerta = UIAlertController(title: "¡Alerta!", message: "\(sNombre) está muy cerca de acabarse ", preferredStyle: .Alert)
            alerta.addAction(UIAlertAction(title: "Notificar contactos", style: .Default, handler: returnTrue()))
            alerta.addAction(UIAlertAction(title: "Ignorar", style: .Default, handler: returnTrue()))
            presentViewController(alerta, animated: true, completion: nil)
        }
            //si queda menos de un 10% de la cantidad original
        else if(medicina.dCantidadPorCajaActual <= medicina.dCantidadPorCaja*0.25){
            let alerta = UIAlertController(title: "¡Alerta!", message: "Parece que pronto se acabará \(sNombre) ", preferredStyle: .Alert)
            alerta.addAction(UIAlertAction(title: "Notificar contactos", style: .Default, handler: returnTrue()))
            alerta.addAction(UIAlertAction(title: "Ignorar", style: .Default, handler: returnTrue()))
            presentViewController(alerta, animated: true, completion: nil)
        }**/
        
        self.performSegueWithIdentifier("tomarMedicina", sender: sender)
    }

    //maneja la accion de presionar posponer
    @IBAction func presionaSnooze(sender: AnyObject) {
        snoozeNotif(5)
        performSegueWithIdentifier("snoozeMedicina", sender: sender)
    }

    //cambia de foto con un swipe
	func cambiarFoto(swipe: UISwipeGestureRecognizer) {
		let swipeGesture = swipe as? UISwipeGestureRecognizer
		
		if (swipeGesture!.direction == UISwipeGestureRecognizerDirection.Right) {
			imgCounter += 1
		}
		if (swipeGesture!.direction == UISwipeGestureRecognizerDirection.Left)  {
			imgCounter -= 1
		}
		
		if (medicina.sFotoPastillero != nil) {
			imgCounter %= 3
		}
		else {
			imgCounter %= 2
		}
		
		pager.currentPage = abs(imgCounter)
		
		switch abs(imgCounter) {
		case 0:
			imgImage.image = UIImage(contentsOfFile: medicina.sFotoMedicamento)
		case 1:
			imgImage.image = UIImage(contentsOfFile: medicina.sFotoCaja)
		case 2:
			imgImage.image = UIImage(contentsOfFile: medicina.sFotoPastillero!)
		default:
			print("ERROR")
		}
	}
	
    //decide que boton del segmented control mostrar
	@IBAction func cambioSegmento(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
		case 0:
			viewImg.hidden = true
			viewInfo.hidden = false
		case 1:
			viewImg.hidden = false
			viewInfo.hidden = true
		default:
			print("ERROR")
		}
	}

    //maneja la logica de posponer una medicina
    func snoozeNotif(snoozeMins : Int){
        var fechaAux = Fecha()
        
        //saca las listas de notificaciones
        let realm = try! Realm()
        let listasNotif = realm.objects(Notificaciones)
        
        try! realm.write{
            let listaPendientes = listasNotif.filter("id == 1").first!
            
            //borrar notificacion actual de la lista de notificaciones
            for i in 0...listaPendientes.listaNotificaciones.count-1{
                //found a match
                if(listaPendientes.listaNotificaciones[i].fechaAlerta == fechaAlerta && listaPendientes.listaNotificaciones[i].nombreMed == sNombre){
                    //guarda la fecha para usarla despues
                    fechaAux = listaPendientes.listaNotificaciones[i]
                    
                    //la borra de las pendientes
                    listaPendientes.listaNotificaciones.removeAtIndex(i)
                    break
                }
            }
            
            //genera la nueva fecha y la agrega a la lista
            //TODO-Snooze
            let nuevaFecha = NSDate(timeIntervalSinceNow: Double(snoozeMins)*60)
            fechaAux.fechaAlerta = nuevaFecha
            listaPendientes.listaNotificaciones.append(fechaAux)
            
            //actualiza la lista de notificaciones en REALM
            realm.add(listaPendientes, update: true)
            
        }
        //hace un reschedule de las notificaciones
        let notif : HandlerNotificaciones = HandlerNotificaciones()
        notif.rescheduleNotificaciones()
    }
    
    func tomarMed(){
        var fechaAux = Fecha()
        
        //saca las listas de notificaciones
        let realm = try! Realm()
        let listasNotif = realm.objects(Notificaciones)
        
        try! realm.write{
            var listaPendientes = listasNotif.filter("id == 1").first!
            var listaTomadas = listasNotif.filter("id == 2").first!
            
            //borrar notificacion actual de la lista de notificaciones
            for i in 0...listaPendientes.listaNotificaciones.count-1{
                //found a match
                if(listaPendientes.listaNotificaciones[i].fechaAlerta == fechaAlerta && listaPendientes.listaNotificaciones[i].nombreMed == sNombre){
                    //guarda la fecha para usarla en la lista de tomadas
                    fechaAux.fechaAlerta = listaPendientes.listaNotificaciones[i].fechaAlerta
                    fechaAux.fechaOriginal = listaPendientes.listaNotificaciones[i].fechaOriginal
                    fechaAux.nombreMed = listaPendientes.listaNotificaciones[i].nombreMed

                    
                    //la borra de las pendientes
                    listaPendientes.listaNotificaciones.removeAtIndex(i)
                    break
                }
            }
            
            //guardar en lista tomadas
            fechaAux.fechaAlerta = NSDate()
            listaTomadas.listaNotificaciones.append(fechaAux)
            print(fechaAux)
            
            //actualiza ambas listas
            realm.add(listaPendientes, update: true)
            realm.add(listaTomadas, update: true)
            
        }
        //hace un reschedule de las notificaciones
        let notif : HandlerNotificaciones = HandlerNotificaciones()
        notif.rescheduleNotificaciones()

    }
}

