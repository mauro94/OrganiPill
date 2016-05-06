//
//  ViewControllerEscogerSettings.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 5/4/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift


class ViewControllerPacienteSettings: UIViewController {
    
    @IBOutlet weak var containerPaciente: UIView!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var txTelefono: UITextField!
    @IBOutlet weak var tfTelefonoSecundario: UITextField!
    @IBOutlet weak var txCorreoElectronico: UITextField!
	@IBOutlet weak var scroll: UIScrollView!
	
	var activeField : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
       
        let pacPac = realm.objects(Persona)
        
        tfNombre.text = pacPac[0].sNombre
        
        txTelefono.text = pacPac[0].sTelefono
        tfTelefonoSecundario.text = pacPac[0].sTelefonoSecundario
        
        txCorreoElectronico.text = pacPac[0].sCorreoElectronico
        
        
        try! realm.write {
            
        }
        
        
		//mover vista cuando aparece el teclado
		let tap = UITapGestureRecognizer(target: self, action: #selector(quitaTeclado))
		
		self.view.addGestureRecognizer(tap)
		
		self.registrarseParaNotificacionesDeTeclado()
		
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var GuardarDatosPaciente: UIButton!
    
    @IBAction func GuardarDatosPac(sender: AnyObject) {
        
        
        if(tfTelefonoSecundario.text != "" && tfNombre.text != "" && txTelefono.text != "" && txCorreoElectronico.text != "" ){
            let realm = try! Realm()
            try! realm.write {
                let pacPac = realm.objects(Persona)
                
                pacPac[0].sNombre  = tfNombre.text!
                
                pacPac[0].sTelefono = txTelefono.text!
                pacPac[0].sTelefonoSecundario = tfTelefonoSecundario.text!
                
                pacPac[0].sCorreoElectronico = txCorreoElectronico.text!
                
                
                
                
            }
            
            let alerta = UIAlertController(title: "Guardado", message: "La informacion ha sido guardada correctamente",preferredStyle:  UIAlertControllerStyle.Alert)
            
            alerta.addAction(UIAlertAction(title: "Ok",style: UIAlertActionStyle.Cancel, handler:nil))
            
            
            presentViewController(alerta,animated:true, completion:nil)
            
            
            
        }
        
        else{
            let alerta = UIAlertController(title: "Error", message: "Dejaste casillas en blanco!",preferredStyle:  UIAlertControllerStyle.Alert)
            
            alerta.addAction(UIAlertAction(title: "Ok",style: UIAlertActionStyle.Cancel, handler:nil))
            
            
            presentViewController(alerta,animated:true, completion:nil)
        }
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func quitaTeclado() {
		view.endEditing(true)
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
