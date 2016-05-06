//
//  AgregarMedicamento5ViewController.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 5/5/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class AgregarMedicamento5ViewController: UIViewController {
	//OUTLETS
	@IBOutlet weak var tvComments: UITextView!
	
	//VARIABLES
	var medMedicina : Medicamento = Medicamento()

    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Comentarios"
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func quitarTeclado() {
		self.view.endEditing(true)
	}

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let viewSiguiente = segue.destinationViewController as! AgregarMedicamento4ViewController
		
		//guarda los datos del medicamento de esta vista
		medMedicina.sComentario = tvComments.text
		
		viewSiguiente.medMedicina = medMedicina
    }

}
