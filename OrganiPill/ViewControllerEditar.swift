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
    
    @IBOutlet weak var txviewComentario: UITextView!
    @IBOutlet weak var swAlimentos: UISwitch!
    @IBOutlet weak var txCajaActual: UITextField!
    @IBOutlet weak var txMiligramosCaja: UITextField!
    @IBOutlet weak var pickDuracion: UIPickerView!
    @IBOutlet weak var txDuracion: UITextField!
    @IBOutlet weak var imImage: UIImageView!
    
    @IBOutlet weak var scScrollView: UIScrollView!
    
    @IBOutlet weak var pcPicker: UIPickerView!
    @IBOutlet weak var tfNombre: UITextField!
   
    @IBOutlet weak var tfDosis: UITextField!
    
    let pickerData = ["Injeccion","Comestible","Supositorio", "Tomable"]
    let pickerDataDuracion = ["Dia(s)","Semana(s)","Mes(es)"]
    
    
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
    
    func checarPosicionPickerDuracion() -> Int{
        if(indMedicamento.sTipoDuracion == "d"){
            return 0
        }
        else if(indMedicamento.sTipoDuracion == "s"){
            return 1
        }
        else{
            return 2
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let editButton : UIBarButtonItem = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.Plain, target: self, action: Selector(""))
        
        self.navigationItem.rightBarButtonItem = editButton
        
        
        editButton.target = self
        editButton.action = "guardarbottonpress:"
        
        txviewComentario.text = indMedicamento.sComentario
        
        
        if(indMedicamento.bNecesitaAlimento){
            swAlimentos.on = true
        }
        
        
        tfNombre.text = indMedicamento.sNombre
        tfDosis.text = String( indMedicamento.dDosis)
        
        txDuracion.text = String(indMedicamento.iDuracion)
        
        txCajaActual.text = String(indMedicamento.dMiligramosCajaActual)
        txMiligramosCaja.text = String(indMedicamento.dMiligramosCaja)
        
        
        
        
        
        
        pcPicker.selectRow(checarPosicionPicker(), inComponent: 0, animated: true)
        pickDuracion.selectRow(checarPosicionPickerDuracion(), inComponent: 0, animated: true)
        
        var viewSize = self.view.frame.size
        viewSize.height = 2000
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
        
        if(pickerView.tag == 1){
            return pickerData[row]
        }
        else if(pickerView.tag == 2){
            return pickerDataDuracion[row]
        }
        else{
            return "hola"
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 1){
            return pickerData.count
        }
        else if(pickerView.tag == 2){
            return pickerDataDuracion.count
        }
        else{
            return 1
        }
        
        
        
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func Guardar() -> Bool {
        
        
        
        if(txDuracion.text != "" && tfDosis.text != "" && tfNombre.text != "" ){
            
            
            let realm = try! Realm()
            
            try! realm.write {
                indMedicamento.sNombre = tfNombre.text!
                indMedicamento.dDosis = Double(tfDosis.text!)!
                
                indMedicamento.dMiligramosCaja = Double(txMiligramosCaja.text!)!
              
                indMedicamento.dMiligramosCajaActual = Double(txCajaActual.text!)!
                
                indMedicamento.sViaAdministracion = pickerData[pcPicker.selectedRowInComponent(0)]
                
                if(pickerDataDuracion[pickDuracion.selectedRowInComponent(0)] == "Dia(s)"){
                    indMedicamento.sTipoDuracion = "d"
                }
                else if(pickerDataDuracion[pickDuracion.selectedRowInComponent(0)] == "Semana(s)"){
                    indMedicamento.sTipoDuracion = "s"
                }
                
                else{
                    indMedicamento.sTipoDuracion = "m"
                }
                
               
                
                if(swAlimentos.on){
                    indMedicamento.bNecesitaAlimento = true
                }
                else{
                    indMedicamento.bNecesitaAlimento = false
                }
                
                
                indMedicamento.sComentario = txviewComentario.text
                
                
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
            
            
            let refreshAlert = UIAlertController(title: "Guardar", message: "Los datos se guardaron correctamente ", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                
                self.performSegueWithIdentifier("unwind", sender: sender)
            }))
            
            
            presentViewController(refreshAlert, animated: true, completion: nil)
            
            
            
            
            
            
            
        }
        
        
        
        
    }
    
    
    @IBAction func btnBorrarMedicamento(sender: AnyObject) {
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(indMedicamento)
        }
        
        
        
        
        let refreshAlert = UIAlertController(title: "Borrado", message: "El medicamento ha sido borrado correctamente", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popToRootViewControllerAnimated(true)
            
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