//
//  AgregarMedicamento4ViewController.swift
//  OrganiPill
//
//  Created by David Benitez on 4/17/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class AgregarMedicamento4ViewController: UIViewController {
    
    // MARK: - Global Variables
    var medMedicina : Medicamento = Medicamento()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(medMedicina.dDosis)
        print(medMedicina.dMiligramosCaja)
        print(medMedicina.iDias)
        print(medMedicina.sFotoCaja)
        print(medMedicina.sFotoPastillero)
        print(medMedicina.sFotoMedicamento)
        print(medMedicina.sNombre)
        print(medMedicina.sViaAdministracion)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
