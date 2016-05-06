//
//  ViewControllerSetupInicial2.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/24/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class ViewControllerSetupInicial2: UIViewController, UIPopoverPresentationControllerDelegate {
	//OUTLETS
	@IBOutlet weak var tfNombre: UITextField!
	@IBOutlet weak var tfTelefonoConsultorio: UITextField!
	@IBOutlet weak var tfTelefonoPersonal: UITextField!
	@IBOutlet weak var tfCorreoElectronico: UITextField!
	@IBOutlet weak var scroll: UIScrollView!
	
	//VARIABLES
	var doctor: Persona = Persona()
	var paciente: Persona!
	var activeField : UITextField?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.title = "Información Doctor"
		
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
	
	
	func emptyField(field : String){
		//creates popup message
		let alerta = UIAlertController(title: "¡Alerta!", message: "Parece que olvidaste llenar \(field)", preferredStyle: UIAlertControllerStyle.Alert)
		
		alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
		
		presentViewController(alerta, animated: true, completion: nil)
	}
	
	// MARK: - Navigation
	override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
		//si se activa popover
		if (identifier == "seguePopOver") {
			quitaTeclado()
			return true
		}
		//si se va a pasar a la siguiente vista
		if(tfNombre.text != "" && tfTelefonoConsultorio.text != "" && tfCorreoElectronico.text != ""){
			return true
		}
		//si falto llenar un dato
		else{
			emptyField("algún campo obligatorio (*)")
			return false
		}
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)  {
		if segue.identifier == "seguePopOver" {
			let popoverViewController = segue.destinationViewController as! UIViewController
			popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
			popoverViewController.popoverPresentationController!.delegate = self
		}
			
		else {
			let viewSiguiente = segue.destinationViewController as! ViewControllerSetupInicial3
			//guarda los datos de esta vista
			doctor.sNombre = tfNombre.text!
			doctor.sTelefono = tfTelefonoConsultorio.text!
			if (tfTelefonoPersonal != "") {
				doctor.sTelefonoSecundario = tfTelefonoPersonal.text!
			}
			doctor.sCorreoElectronico = tfCorreoElectronico.text!
			
			viewSiguiente.doctor = doctor
			viewSiguiente.paciente = paciente
		}
	}

	
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None
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
		
		let contentInset = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0)
		scroll.contentInset = contentInset
		scroll.scrollIndicatorInsets = contentInset
		scroll.contentSize = self.view.frame.size
	}
	
	func keyboardWillBeHidden (aNotification : NSNotification)
	{
		let contentInsets : UIEdgeInsets = UIEdgeInsetsZero
		scroll.contentInset = contentInsets;
		scroll.scrollIndicatorInsets = contentInsets;
		scroll.contentSize = self.view.frame.size
	}
	
	func textFieldDidBeginEditing (textField : UITextField ) {
		activeField = textField
	}
	
	func textFieldDidEndEditing (textField : UITextField ) {
		activeField = nil
	}
}
