//
//  ViewControllerMenu.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/6/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import MessageUI
import RealmSwift

class ViewControllerMenu: UIViewController,MFMailComposeViewControllerDelegate {
	//OUTLETS
	@IBOutlet weak var btMisMedicamentos: UIButton!
	@IBOutlet weak var btCalendario: UIButton!
	@IBOutlet weak var btAgregarMedicamento: UIButton!
	@IBOutlet weak var btRegistrarDatos: UIButton!
	@IBOutlet weak var btReportes: UIButton!
	@IBOutlet weak var btActividadDelDia: UIButton!
	
	@IBOutlet weak var lbMisMedicamentos: UILabel!
	@IBOutlet weak var lbCalendario: UILabel!
	@IBOutlet weak var lbAgregarMedicamento: UILabel!
	@IBOutlet weak var lbRegistrarDato: UILabel!
	@IBOutlet weak var lbReportes: UILabel!
	@IBOutlet weak var lbActividadDelDia: UILabel!

    
    var botonSuperiorDerecho : UIBarButtonItem!
	
	var tamanoFont: CGFloat = 28.0
	
	//VARIABLES
	let color: UIColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 1)

    let realm = try! Realm()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = botonSuperiorDerecho
        
        // Do any additional setup after loading the view.
		
		self.title = "OrganiPill"
		
		//navigationController!.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 50.0/255.0, blue: 57.0/255.0, alpha: 1.0)
		
		self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
		self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
		self.navigationController?.navigationBar.barTintColor = color
		self.navigationController?.navigationBar.translucent = false
		self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
		
		//arreglar texto dependiendo de iphone
		if (self.view.frame.size.width == 320) {
			tamanoFont = 20.0
		}
		
		if (self.view.frame.size.width == 375) {
			tamanoFont = 25.0
		}
		
		if (self.view.frame.size.width == 414) {
			tamanoFont = 28.0
		}
		
		lbMisMedicamentos.font = UIFont(name: lbMisMedicamentos.font.fontName, size: tamanoFont)
		lbCalendario.font = UIFont(name: lbMisMedicamentos.font.fontName, size: tamanoFont)
		lbAgregarMedicamento.font = UIFont(name: lbMisMedicamentos.font.fontName, size: tamanoFont)
		lbRegistrarDato.font = UIFont(name: lbMisMedicamentos.font.fontName, size: tamanoFont)
		lbReportes.font = UIFont(name: lbMisMedicamentos.font.fontName, size: tamanoFont)
		lbActividadDelDia.font = UIFont(name: lbMisMedicamentos.font.fontName, size: tamanoFont)!
		
		//ajustar imagenes de botones a aspect fit
		btMisMedicamentos.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
		btCalendario.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
		btAgregarMedicamento.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
		btReportes.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
		btRegistrarDatos.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
		btActividadDelDia.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
    }
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func highlightBoton(sender: UIButton) {
		sender.setBackgroundImage(UIImage(named: "highlightMenu"), forState: UIControlState.Highlighted)
	}
    
    
    
    
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }
        else {
            self.showSendMailErrorAlert()
        }
    }
    
    func getBody()->String{
        
        
        
        
        let formatoHora = NSDateFormatter()
        formatoHora.locale = NSLocale.init(localeIdentifier: "ES")
        formatoHora.dateFormat = "EEEE, dd 'de' MMMM h:mm a"
        
        
        var mensaje : String = "Hola, les envío mi reporte semanal: \n\n"
        
        mensaje += "\nMedicinas que me tomé:\n"
        
        var tomadas =  realm.objects(Notificaciones).filter("id == 2").first
        
        if(tomadas != nil){
            for i in tomadas!.listaNotificaciones{
                mensaje += "\(i.nombreMed) \n"
                mensaje += "Programada el: \(formatoHora.stringFromDate(i.fechaOriginal)) \n"
                mensaje += "Tomada el: \(formatoHora.stringFromDate(i.fechaAlerta)) \n\n"
            }
        }
        
        mensaje += "Medicinas que no me tomé: \n"
        
        var pasadas = realm.objects(Notificaciones).filter("id == 3").first
        
        if(pasadas != nil){
            for i in pasadas!.listaNotificaciones{
                mensaje += "\(i.nombreMed) \n"
                mensaje += "Programada el: \(formatoHora.stringFromDate(i.fechaOriginal)) \n\n"
            }
        }
        
        var persona = realm.objects(Persona)
        
        var usuario = persona[0]
        
        mensaje += "\nEspero les sirva de utilidad esta información para mi bienestar, \n \nSaludos Cordiales :),  \n  \(usuario.sNombre)\n\(usuario.sCorreoElectronico)\n\(usuario.sTelefono)"
    
        print(mensaje)
    
        return mensaje
    
    }
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        
        var realmAux = realm.objects(Persona)
        var arrContactos = [String]()
       
        
        for i in realmAux{
         
            if(i.sTipo == "c"){
                arrContactos.append(i.sCorreoElectronico)
               
            }
            
            
            
        }
        mailComposerVC.setCcRecipients(arrContactos)
        mailComposerVC.setToRecipients([realmAux[1].sCorreoElectronico])
        
        mailComposerVC.setSubject("OrganiPill")
        mailComposerVC.setMessageBody(getBody(), isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "No se pudo enviar el correo", message: "Su dispositivo no pudo enviar el correo.  Porfavor revise la configuracion de su correo.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    
    
    func alertaNotificacion(nombreMed : String, fecha : NSDate, notification : UILocalNotification){
        let alerta = UIAlertController(title: "Alerta!", message: "Hora de tomar \(nombreMed))", preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Recordar más tarde", style: UIAlertActionStyle.Destructive, handler: nil))
        
        alerta.addAction(UIAlertAction(title: "Tomar medicina", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alerta, animated: true, completion: nil)
    }

}
