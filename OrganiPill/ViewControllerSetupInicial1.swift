//
//  ViewControllerSetupInicial1.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/19/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerSetupInicial1: UIViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
	//OUTLETS
	@IBOutlet weak var tfNombre: UITextField!
	@IBOutlet weak var tfTelefono: UITextField!
	@IBOutlet weak var tfTelefono2: UITextField!
	@IBOutlet weak var tfCorreoElectronico: UITextField!
	@IBOutlet weak var scroll: UIScrollView!
	
	//VARIABLES
	let color: UIColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 1)
	var paciente: Persona = Persona()
	var activeField : UITextField?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		self.title = "Información Personal"
		
		//ui navigation
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		self.navigationController?.navigationBar.barTintColor = color
		self.navigationController?.navigationBar.translucent = false
		self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
		
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
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
	
	//mensaje de error
	func emptyField(field : String){
		//creates popup message
		let alerta = UIAlertController(title: "¡Alerta!", message: "Parece que olvidaste llenar \(field)", preferredStyle: UIAlertControllerStyle.Alert)
		
		alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
		
		presentViewController(alerta, animated: true, completion: nil)
	}
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluateWithObject(candidate)
    }
    
	
    // MARK: - Navigation
	override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
		//si se activa popover
		if (identifier == "seguePopOver") {
			quitaTeclado()
			return true
		}
		//si se va a pasar a la siguiente vista
		if(tfNombre.text != "" && tfTelefono.text != "" && tfCorreoElectronico.text != "" ){
            if(validateEmail(tfCorreoElectronico.text!)){
                return true
            }
            else{
                emptyField("el mail correctamente")
                return false
            }
			
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
			let viewSiguiente = segue.destinationViewController as! ViewControllerSetupInicial2
			//guarda los datos de esta vista
			paciente.sNombre = tfNombre.text!
			paciente.sTelefono = tfTelefono.text!
			if (tfTelefono2 != "") {
				paciente.sTelefonoSecundario = tfTelefono2.text!
			}
			paciente.sCorreoElectronico = tfCorreoElectronico.text!
			
			viewSiguiente.paciente = paciente
		}
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
	
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None
	}

}
