//
//  ViewControllerAgregarContacto.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/25/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

protocol ProtocoloGuardarContacto {
	func guardaContacto(contacto: Persona)
	func editarContacto(contacto: Persona)
	func borrar(contacto: Persona)
}

class ViewControllerAgregarContacto: UIViewController, UIPopoverPresentationControllerDelegate {
	//OUTLETS
	@IBOutlet weak var tfNombre: UITextField!
	@IBOutlet weak var tfTelefono: UITextField!
	@IBOutlet weak var tfTelefono2: UITextField!
	@IBOutlet weak var tfCorreoElectronico: UITextField!
	@IBOutlet weak var scroll: UIScrollView!
	@IBOutlet weak var navBar: UINavigationBar!
	@IBOutlet weak var btAgregar: UIButton!
	
	@IBOutlet weak var btBorrar: UIBarButtonItem!
	
	//VARIABLES
	let color: UIColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 1)
	var contacto: Persona = Persona()
	var activeField : UITextField?
	var delegado : ProtocoloGuardarContacto!
	var sNombre: String = ""
	var sTelefono: String = ""
	var sTelefono2: String = ""
	var sCorreoElectronico: String = ""
	var editando: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		navBar.tintColor = UIColor.whiteColor()
		navBar.barTintColor = color
		navBar.translucent = false
		navBar.barStyle = UIBarStyle.Black
		
		//mover vista cuando aparece el teclado
		let tap = UITapGestureRecognizer(target: self, action: #selector(quitaTeclado))
		
		self.view.addGestureRecognizer(tap)
		
		self.registrarseParaNotificacionesDeTeclado()
		
		
		//asignar datos
		tfNombre.text = sNombre
		tfTelefono.text = sTelefono
		tfTelefono2.text = sTelefono2
		tfCorreoElectronico.text = sCorreoElectronico
		
		if (tfNombre.text != "") {
			editando = true
			btAgregar.setTitle("Guardar Cambios", forState: UIControlState.Normal)
			btBorrar.enabled = true
		}
		else {
			editando = false
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//barra blanca
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	func quitaTeclado() {
		view.endEditing(true)
	}
	
	@IBAction func borrar(sender: UIBarButtonItem) {
		delegado.borrar(contacto)
		self.performSegueWithIdentifier("unwindContacto", sender: self)
	}
	
	func emptyField(field : String){
		//creates popup message
		let alerta = UIAlertController(title: "¡Alerta!", message: "Parece que olvidaste llenar \(field)", preferredStyle: UIAlertControllerStyle.Alert)
		
		alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
		
		presentViewController(alerta, animated: true, completion: nil)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "seguePopOver" {
			let popoverViewController = segue.destinationViewController as! UIViewController
			popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
			popoverViewController.popoverPresentationController!.delegate = self
		}
	}
	
	func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
		return UIModalPresentationStyle.None
	}
    

	
    // MARK: - Navigation
	@IBAction func AgregarContacto(sender: AnyObject) {
		if(tfNombre.text != "" && tfTelefono.text != "" && tfCorreoElectronico.text != "") {
			//guarda los datos de esta vista
			contacto.sNombre = tfNombre.text!
			contacto.sTelefono = tfTelefono.text!
			if (tfTelefono2 != "") {
				contacto.sTelefonoSecundario = tfTelefono2.text!
			}
			contacto.sCorreoElectronico = tfCorreoElectronico.text!
			
			if (!editando) {
				delegado.guardaContacto(contacto)
			}
			else {
				delegado.editarContacto(contacto)
			}
			self.performSegueWithIdentifier("unwindContacto", sender: self)
		}
		else {
			emptyField("algún campo obligatorio (*)")
		}
	}
	
	@IBAction func cancelar(sender: AnyObject) {
		self.performSegueWithIdentifier("unwindContacto", sender: self)
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
		let tamano = CGSize.init(width: self.view.frame.size.width, height: self.view.frame.size.height-100)
		scroll.contentSize = tamano
	}
	
	func keyboardWillBeHidden (aNotification : NSNotification)
	{
		let contentInsets : UIEdgeInsets = UIEdgeInsetsZero
		scroll.contentInset = contentInsets;
		scroll.scrollIndicatorInsets = contentInsets;
		let tamano = CGSize.init(width: self.view.frame.size.width, height: self.view.frame.size.height-100)
		scroll.contentSize = tamano
	}
	
	func textFieldDidBeginEditing (textField : UITextField ) {
		activeField = textField
	}
	
	func textFieldDidEndEditing (textField : UITextField ) {
		activeField = nil
	}

}
