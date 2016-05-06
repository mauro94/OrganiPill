//
//  ViewControllerAgregarDatos.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 5/3/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift


class ViewControllerAgregarDatos: UIViewController {
    @IBOutlet weak var txtAbajo: UITextField!

    @IBOutlet weak var lbldatoAbajo: UILabel!
    @IBOutlet weak var lblDatoArriba: UILabel!
    
    @IBOutlet weak var txtDeArriba: UITextField!
    
    var textoArriba:String = ""
    var textoAbajo:String = ""
    var textoCajaArriba:String = ""
    var textoCajaAbajo:String = ""
    var isGlucosa:Bool = true
    var borrar:Bool = false
    var auxMedidaGlucosa: Medidas! = Medidas()
    var delegado = ProtocoloReloadTable!(nil)
    
    var auxMedidaSys: Medidas! = Medidas()
    var auxMedidaDiac: Medidas! = Medidas()
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.title = "Registro Dato"

        lblDatoArriba.text = textoArriba
        lbldatoAbajo.text = textoAbajo
        txtDeArriba.text = textoCajaArriba
        
        if(isGlucosa){
           txtAbajo.hidden = true
        }
        if(borrar){
            let editButton : UIBarButtonItem = UIBarButtonItem(title: "Borrar", style: UIBarButtonItemStyle.Plain, target: self, action: Selector(""))
            
            self.navigationItem.rightBarButtonItem = editButton
            
            
            editButton.target = self
            editButton.action = #selector(ViewControllerAgregarDatos.borrarbottonpress(_:))
        }
        
        
        txtAbajo.text = textoCajaAbajo
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func alertaTxt(){
        let alerta = UIAlertController(title: "¡Alerta!", message: "Favor de llenar todas las casillas",preferredStyle:  UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Cancel, handler:nil))
        
        
        presentViewController(alerta,animated:true, completion:nil)
    }
	
	@IBAction func quitarTeclado() {
		self.view.endEditing(true)
	}
    
    
    func checarDatosGlucosa()-> Bool{
        
        if(txtDeArriba.text != ""){
            return true
        }
        else{
            alertaTxt()
            return false
        }
        
        
        
    }
    
    func checarDatosPresion()-> Bool{
        
        if(txtDeArriba.text != "" && txtAbajo.text != ""){
            return true
        }
        else{
            alertaTxt()
            return false
        }
        
        
        
    }
    
    
    
    
    @IBAction func guardarDatos(sender: AnyObject) {
        
        let realm = try! Realm()
        
        
        if(borrar){
            
            
            
            
            
            if(isGlucosa && checarDatosGlucosa()){
                try! realm.write {
                    auxMedidaGlucosa.valor = Float(txtDeArriba.text!)!
                }
            }
            else if(checarDatosPresion()){
                try! realm.write {
                    auxMedidaSys.valor = Float(txtDeArriba.text!)!
                    auxMedidaDiac.valor = Float(txtAbajo.text!)!
                }
            }
           
            
            
            
            
        }
        else{
            
            if(isGlucosa && checarDatosGlucosa()){
                
                let auxmedida: Medidas! = Medidas()
                
                auxmedida.valor =  Float(txtDeArriba.text!)!
                auxmedida.fecha = NSDate()
                
                
                try! realm.write {
                    
                    let currentGluco = realm.objects(DatosGlucosa)[0]
                    currentGluco.historialMedidas.append(auxmedida)
                    
                }
            }
                
            else if(checarDatosPresion()){
                
                let auxmedidaSys: Medidas! = Medidas()
                let auxmedidaDiac: Medidas! = Medidas()
                
                auxmedidaSys.valor =  Float(txtDeArriba.text!)!
                auxmedidaSys.fecha = NSDate()
                
                auxmedidaDiac.valor =  Float(txtAbajo.text!)!
                auxmedidaDiac.fecha = NSDate()
                
                
                try! realm.write {
                    
                    let currentPressSys = realm.objects(DatosPresion)[0]
                    currentPressSys.historialSystolic.append(auxmedidaSys)
                    currentPressSys.historialDiastolic.append(auxmedidaDiac)
                    
                }
                
                
                
            }

            
        }
        
        delegado.reloadTable()
        delegado.quitaVista()
    }
    
    func borrarbottonpress(sender:AnyObject){
        
        
        let realm = try! Realm()
        try! realm.write {
            if(isGlucosa){
                realm.delete(auxMedidaGlucosa)
            }
            else{
                realm.delete(auxMedidaSys)
                realm.delete(auxMedidaDiac)
            }
            
            
        }
        let refreshAlert = UIAlertController(title: "Borrado", message: "Los datos se borraron correctamente ", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popViewControllerAnimated(true)
        }))
        
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        
        
        
        
        
        
        
        
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
