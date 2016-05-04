//
//  ViewControllerMenu.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/6/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class ViewControllerMenu: UIViewController {
	//outlet
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

	
	var tamanoFont: CGFloat = 28.0
	
	//variables
	let color: UIColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func alertaNotificacion(nombreMed : String, fecha : NSDate, notification : UILocalNotification){
        let alerta = UIAlertController(title: "Alerta!", message: "Hora de tomar \(nombreMed))", preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Recordar más tarde", style: UIAlertActionStyle.Destructive, handler: nil))
        
        //presionar esto lo lleva a la vista para registrar una medicina como tomada
        //alerta.addAction(UIAlertAction(title: "Tomar medicina", style: UIAlertActionStyle.Default, handler: {action in self.tomarMedicinaController(nombreMed, fecha: fecha, notification: notification)}))
        
        alerta.addAction(UIAlertAction(title: "Tomar medicina", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(alerta, animated: true, completion: nil)
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
