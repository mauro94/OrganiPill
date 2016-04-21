//
//  ViewControllerEditar.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 4/18/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerEditar: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var imImage: UIImageView!
    
    @IBOutlet weak var scScrollView: UIScrollView!
    
    @IBOutlet weak var pcPicker: UIPickerView!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfDuracion: UITextField!
    @IBOutlet weak var tfDosis: UITextField!
    
    let pickerData = ["Injeccion","Comestible","Supositorio", "Tomable"]
    var nombres : String!
    var Dosis : String!
    var Duracion : String!
    var imagg: UIImage!
    
    var indMedicamento : Medicamento!
    
    
    func checarPosicionPicker() -> Int{
        if(indMedicamento.sViaAdministracion == "Injeccion"){
            return 0
        }
        else if(indMedicamento.sViaAdministracion == "Comestible"){
            return 1
        }
        else if(indMedicamento.sViaAdministracion == "Supositorio"){
            return 2
        }
        else if(indMedicamento.sViaAdministracion == "Tomable"){
            return 3
        }
        else{
            return 4
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editButton : UIBarButtonItem = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.Plain, target: self, action: Selector(""))
        
        self.navigationItem.rightBarButtonItem = editButton
        
        
        editButton.target = self
        editButton.action = "guardarbottonpress:"
        
        
        
        
        
        imImage.image = imagg
        tfNombre.text = nombres
        tfDosis.text = Dosis
        tfDuracion.text = Duracion
        
        
        
        
        
        
        pcPicker.selectRow(checarPosicionPicker(), inComponent: 0, animated: true)
        
        
        var viewSize = self.view.frame.size
        viewSize.height = 800
        viewSize.width = 100
        scScrollView.scrollEnabled = true;
        scScrollView.contentSize = viewSize
        scScrollView.showsVerticalScrollIndicator = false
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func Guardar() -> Bool {
        
        
        
        if(tfDuracion.text != "" && tfDosis.text != "" && tfNombre.text != "" ){
            
            
            let realm = try! Realm()
            
            try! realm.write {
                indMedicamento.sNombre = tfNombre.text!
                indMedicamento.dDosis = Double(tfDosis.text!)!
              
                indMedicamento.sViaAdministracion = pickerData[pcPicker.selectedRowInComponent(0)]
            }
            
            
            
            
            return true
            
            
            
        }
        else{
            let alerta = UIAlertController(title: "Error", message: "Dejaste casillas en blanco!",preferredStyle:  UIAlertControllerStyle.Alert)
            
            alerta.addAction(UIAlertAction(title: "Ok",style: UIAlertActionStyle.Cancel, handler:nil))
            
            
            presentViewController(alerta,animated:true, completion:nil)
            
            return false
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    func guardarbottonpress(sender:AnyObject){
        
        if(Guardar()){
            
            
            var refreshAlert = UIAlertController(title: "Guardar", message: "Los datos se guardaron correctamente ", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                
                self.performSegueWithIdentifier("unwind", sender: sender)
            }))
            
            
            presentViewController(refreshAlert, animated: true, completion: nil)
            
            
            
            
            
            
            
        }
        
        
        
        
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