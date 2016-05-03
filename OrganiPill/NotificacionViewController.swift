//
//  NotificacionViewController.swift
//  OrganiPill
//
//  Created by David Benitez on 5/1/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class NotificacionViewController: UIViewController {

    var sNombre : String!
    var fechaNotif : NSDate!
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblHora: UILabel!
    @IBOutlet weak var lblComida: UILabel!
    @IBOutlet weak var lblDosis: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDatos()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDatos(){

        let realm = try! Realm()
        let resMedicina = realm.objects(Medicamento).filter("sNombre == %@", sNombre)
        let medicina = resMedicina.first
        
        let formatoHora = NSDateFormatter()
        formatoHora.dateFormat = "EEEE, dd de MMMM h:mm a"

        lblNombre.text = sNombre
        lblTipo.text = medicina?.sViaAdministracion
        lblHora.text = formatoHora.stringFromDate(fechaNotif)
        
        if(medicina!.bNecesitaAlimento){
            lblComida.text = "Necesita alimento"
        }
        else{
            lblComida.text = "No necesita alimento"
        }
        
        lblDosis.text = String(medicina!.dDosis)
        
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
