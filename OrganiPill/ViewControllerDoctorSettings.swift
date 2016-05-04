//
//  ViewControllerDoctorSettings.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 5/4/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerDoctorSettings: UIViewController {
    @IBOutlet weak var containerPaciente: UIView!
    
    @IBOutlet weak var tfNombre: UITextField!
    
    
    @IBOutlet weak var txTelefono: UITextField!
    
    @IBOutlet weak var tfTelefonoSecundario: UITextField!
    
    
    @IBOutlet weak var txCorreoElectronico: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        
        let pacPac = realm.objects(Persona)
        
        tfNombre.text = pacPac[1].sNombre
        
        txTelefono.text = pacPac[1].sTelefono
        tfTelefonoSecundario.text = pacPac[1].sTelefonoSecundario
        
        txCorreoElectronico.text = pacPac[1].sCorreoElectronico
        
        
        try! realm.write {
            
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var GuardarDatosPaciente: UIButton!
    
    @IBAction func GuardarDatosPac(sender: AnyObject) {
        
        
        if(tfTelefonoSecundario.text != "" && tfNombre.text != "" && txTelefono.text != "" && txCorreoElectronico.text != "" ){
            let realm = try! Realm()
            try! realm.write {
                let pacPac = realm.objects(Persona)
                
                pacPac[1].sNombre  = tfNombre.text!
                
                pacPac[1].sTelefono = txTelefono.text!
                pacPac[1].sTelefonoSecundario = tfTelefonoSecundario.text!
                
                pacPac[1].sCorreoElectronico = txCorreoElectronico.text!
                
                
                
                
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}
