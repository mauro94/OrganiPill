//
//  ViewControllerEditar.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 4/18/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerEditar: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    //OUTLETS
    @IBOutlet weak var txviewComentario: UITextView!
    @IBOutlet weak var swAlimentos: UISwitch!
    @IBOutlet weak var txCajaActual: UITextField!
    @IBOutlet weak var txMiligramosCaja: UITextField!
    @IBOutlet weak var scScrollView: UIScrollView!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfDosis: UITextField!
	@IBOutlet weak var lbNumeroMedsEnCaja: UILabel!
	@IBOutlet weak var lbDosisPorMed: UILabel!
	
	//VARIABLES
	let arrTiposMedicamento = ["Supositorio", "Inyección", "Cápsula", "Pastilla", "Tableta", "Suspensión"]
    let pickerDataDuracion = ["Dia(s)","Semana(s)","Mes(es)"]
	var arrValoresCaja = [Int]()
	var arrValoresCantidad = [Int]()
	var arrValores = [Int]()
	var activeField : UITextField?
	var activeTextv : UITextView?
	
    var delegado = ProtocoloReloadTable!(nil)
    var indMedicamento : Medicamento! = Medicamento()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        tfNombre.delegate = self
		
		self.title = "Editar"
		
		let editButton : UIBarButtonItem = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(guardarbottonpress))
		
		self.navigationItem.rightBarButtonItem = editButton
		
		var titulo: String! = ""
		var subTitulo: String! = ""
		
		//nombre
		tfNombre.text = indMedicamento.sNombre
		
		//tipo de medicamento

		let ubicacion = arrTiposMedicamento.indexOf(indMedicamento.sTipoMedicina)
		
		switch(indMedicamento.sTipoMedicina){
		case "Pastilla":
			titulo = "Número de pastillas restantes:"
			subTitulo = "Dosis por pastilla:"
			break
		case "Inyección":
			titulo = "Número de botes restantes:"
			subTitulo = "Dosis por bote:"
			break
		case "Supositorio":
			titulo = "Número de supositorios restantes:"
			subTitulo = "Dosis por supositorio:"
			break
		case "Suspensión":
			titulo = "Número de botes restantes:"
			subTitulo = "Dosis por bote:"
			break
		case "Cápsula":
			titulo = "Número de cápsulas restantes:"
			subTitulo = "Dosis por cápsula:"
			break
		case "Tableta":
			titulo = "Número de tabletas restantes:"
			subTitulo = "Dosis por tableta:"
			break
		default:
			break
		}
		
		lbNumeroMedsEnCaja.text = titulo
		
		//alimento
		if (indMedicamento.bNecesitaAlimento) {
			swAlimentos.on = true
		}
		
		//numero de meds en caja
        
        
		txCajaActual.text = String(Int(indMedicamento.dCantidadPorCajaActual))
		
		
		//cantidad de meds por caja
		lbDosisPorMed.text = subTitulo
		
		txMiligramosCaja.text = String(Int(indMedicamento.dDosisPorTipo))
		
		//dosis
		tfDosis.text = String( Int(indMedicamento.dDosisRecetada))
		
		//comentarios
		txviewComentario.text = indMedicamento.sComentario
		
		//llenar arreglo con dato numericos
		for i in 1...100 {
			arrValoresCaja.append(i)
			arrValoresCantidad.append(i*10)
		}
		for i in 1...10 {
			arrValores.append(i)
		}

		scScrollView.contentSize = self.view.frame.size
		
		//mover vista cuando aparece el teclado
		let tap = UITapGestureRecognizer(target: self, action: #selector(quitaTeclado))
		
		self.view.addGestureRecognizer(tap)
		
		self.registrarseParaNotificacionesDeTeclado()
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func quitaTeclado() {
		view.endEditing(true)
	}

    
    func Guardar() -> Bool {
        if(tfDosis.text != "" && tfNombre.text != "" ){
            //actualiza las notificaciones al nuevo nombre
            if(indMedicamento.sNombre != tfNombre.text!){
                //actualizarNotificaciones()
            }
            
            let realm = try! Realm()
            
            try! realm.write {
                indMedicamento.sNombre = tfNombre.text!
                indMedicamento.dDosisRecetada = Double(tfDosis.text!)!
                
                indMedicamento.dDosisPorTipo = Double(txMiligramosCaja.text!)!
              
                indMedicamento.dCantidadPorCajaActual = Double(txCajaActual.text!)!
								
                if(swAlimentos.on){
                    indMedicamento.bNecesitaAlimento = true
                }
                else{
                    indMedicamento.bNecesitaAlimento = false
                }
                
                
                indMedicamento.sComentario = txviewComentario.text
            }
			
            return true
            
        }
        else {
            let alerta = UIAlertController(title: "ERROR", message: "¡Dejaste casillas en blanco!",preferredStyle:  UIAlertControllerStyle.Alert)
            
            alerta.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Cancel, handler:nil))
            
            
            presentViewController(alerta,animated:true, completion:nil)
            
            return false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
	
    /*
    //cambia los nombres de las medicinas en todas las listas de medicinas
    func actualizarNotificaciones(){
        let realm = try! Realm()
        let listasNotif = realm.objects(Notificaciones)
		
        try! realm.write {
            print("0.1")
            var listaPendientes = listasNotif.filter("id == 1").first!
            print("l1")
            var listaTomadas = listasNotif.filter("id == 2").first!
            print("l2")

            var listaAnulada = listasNotif.filter("id == 3").first!
            
            print("1")
            //busca en la lista de medicinas pendientes
            var i = 0
            while(i < listaPendientes.listaNotificaciones.count){
                //encuentra un match
                if(listaPendientes.listaNotificaciones[i].nombreMed == indMedicamento.sNombre){
                    listaPendientes.listaNotificaciones[i].nombreMed = tfNombre.text!
                }
                i += 1
            }
            print("2")

            
            //busca en la lista de medicinas tomadas
            i = 0
            while(i < listaTomadas.listaNotificaciones.count){
                //encuentra un match
                if(listaTomadas.listaNotificaciones[i].nombreMed == indMedicamento.sNombre){
                    listaTomadas.listaNotificaciones[i].nombreMed = tfNombre.text!
                }
                i += 1
            }
            
            print("3")

            //busca en la lista de medicinas anuladas
            i = 0
            while(i < listaAnulada.listaNotificaciones.count){
                //encuentra un match
                if(listaAnulada.listaNotificaciones[i].nombreMed == indMedicamento.sNombre){
                    listaAnulada.listaNotificaciones[i].nombreMed = tfNombre.text!
                }
                i += 1
            }
            
            print("4")

            //actualiza las listas
            realm.add(listaPendientes, update: true)
            realm.add(listaTomadas, update: true)
            realm.add(listaAnulada, update: true)
            print("5")

        }
    }
    */
    
    
	func guardarbottonpress(sender:AnyObject) {
		if(Guardar()) {
            let refreshAlert = UIAlertController(title: "Datos Actualizados", message: "Los datos se grabaron correctamente ", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                
                self.performSegueWithIdentifier("unwind", sender: sender)
            }))
            
            
            presentViewController(refreshAlert, animated: true, completion: nil)
		}
    }
    
	
    @IBAction func btnBorrarMedicamento(sender: AnyObject) {
		
		let adv = UIAlertController(title: "Borrar " + indMedicamento.sNombre, message: "¿Estás seguro?", preferredStyle: UIAlertControllerStyle.Alert)
		
		adv.addAction(UIAlertAction(title: "Cancelar", style: .Default, handler: nil))
		
		adv.addAction(UIAlertAction(title: "Borrar", style: .Destructive, handler: {(action: UIAlertAction!) in self.borrar()}))
		
		presentViewController(adv, animated: true, completion: nil)
    }
	
	func borrar() {
		let realm = try! Realm()
		
		let handler = HandlerNotificaciones()
		
		handler.deleteNotifcationsFromMed(indMedicamento)
		
		try! realm.write {
			realm.delete(indMedicamento)
		}
        
        handler.rescheduleNotificaciones()
		
		self.navigationController?.popToRootViewControllerAnimated(true)
	}
	
	//MARK - Mover vista cuando aparece teclado
	private func registrarseParaNotificacionesDeTeclado() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyboardWasShown(_:)),
		                                                 name:UIKeyboardWillShowNotification, object:nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyboardWillBeHidden(_:)),
		                                                 name:UIKeyboardWillHideNotification, object:nil)
	}
	
	func keyboardWasShown (aNotification : NSNotification )
	{
		let kbSize = aNotification.userInfo![UIKeyboardFrameBeginUserInfoKey]!.CGRectValue.size
		
		let contentInset = UIEdgeInsetsMake(0.0, 0.0, kbSize.height + 80, 0.0)
		scScrollView.contentInset = contentInset
		scScrollView.scrollIndicatorInsets = contentInset
		scScrollView.contentSize = self.view.frame.size
	}
	
	func keyboardWillBeHidden (aNotification : NSNotification)
	{
		let contentInsets : UIEdgeInsets = UIEdgeInsetsZero
		scScrollView.contentInset = contentInsets
		scScrollView.scrollIndicatorInsets = contentInsets;
		scScrollView.contentSize = self.view.frame.size
	}
	
	func textFieldDidBeginEditing (textField : UITextField ) {
		activeField = textField
	}
	
	func textFieldDidEndEditing (textField : UITextField ) {
		activeField = nil
	}
	
	func textViewDidBeginEditing(textView: UITextView) {
		activeTextv = txviewComentario
	}
	
	func textViewDidEndEditing(textView: UITextView) {
		activeTextv = nil
	}
	
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None
	}
}