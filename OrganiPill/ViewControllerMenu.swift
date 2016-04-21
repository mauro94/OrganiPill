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
		
		//botones
		let dValueHeight = btMisMedicamentos.frame.size.height * 0.25
		let dValueWidth = btMisMedicamentos.frame.size.width * 0.25
		
		
		btMisMedicamentos.imageEdgeInsets.top = dValueHeight
		btMisMedicamentos.imageEdgeInsets.bottom = dValueHeight
		btMisMedicamentos.imageEdgeInsets.left = dValueWidth
		btMisMedicamentos.imageEdgeInsets.right = dValueWidth
		
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	

}
