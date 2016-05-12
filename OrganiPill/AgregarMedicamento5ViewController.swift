//
//  AgregarMedicamento5ViewController.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 5/5/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class AgregarMedicamento5ViewController: UIViewController, UITextViewDelegate {
	//OUTLETS
	@IBOutlet weak var tvComments: UITextView!
	
	//VARIABLES
	var medMedicina : Medicamento = Medicamento()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Comentarios"
		
		tvComments.delegate = self
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
		if(text == "\n") {
			textView.resignFirstResponder()
			return false
		}
		return true
	}
	
	@IBAction func quitarTeclado() {
		self.view.endEditing(true)
	}

	@IBAction func terminar(sender: AnyObject) {
		medMedicina.sComentario = tvComments.text
		guardaRealm()
		
		let alerta = UIAlertController(title: "¡Listo!", message: "\(medMedicina.sNombre) ha sido agregado a tu medicamentos", preferredStyle: UIAlertControllerStyle.Alert)
		
		alerta.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
		
		presentViewController(alerta, animated: true, completion: nil)
		
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let mainVC = storyboard.instantiateViewControllerWithIdentifier("Primero")
		UIApplication.sharedApplication().delegate?.window?!.rootViewController = mainVC
		UIApplication.sharedApplication().delegate?.window?!.makeKeyAndVisible()
		navigationController?.popToRootViewControllerAnimated(true)
	}
	
	//guarda la medicina y notificaciones a la base de datos REALM
	func guardaRealm(){
		let realm = try! Realm()
		
		try! realm.write {
			realm.add(medMedicina)
		}
		
		let notif : HandlerNotificaciones = HandlerNotificaciones(medMedicamento: medMedicina)
		
		notif.generarNotificaciones()
	}
}
