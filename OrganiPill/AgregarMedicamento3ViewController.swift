//
//  AgregarMedicamento3ViewController.swift
//  OrganiPill
//
//  Created by David Benitez on 4/13/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class AgregarMedicamento3ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var pickerDosis: UIPickerView!
    @IBOutlet weak var pickerDuracion: UIPickerView!
    @IBOutlet weak var pickerViaAdmin: UIPickerView!
    @IBOutlet weak var fldDosis: UITextField!
    @IBOutlet weak var fldDuracion: UITextField!
    
    // MARK: - Global Variables
    let arrDosis = ["Miligramos", "Mililitros"]
    let arrDuracion = ["Dia(s)", "Semana(s)", "Mes(es)"]
    let arrViaAdmin = ["Oral", "Inyección", "Supositorio"]
    var medMedicina : Medicamento = Medicamento()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerDosis.dataSource = self
        self.pickerDosis.delegate = self
        self.pickerDosis.selectRow(1, inComponent: 0, animated: true)
        
        self.pickerDuracion.dataSource = self
        self.pickerDuracion.delegate = self
        self.pickerDuracion.selectRow(1, inComponent: 0, animated: true)
        
        self.pickerViaAdmin.dataSource = self
        self.pickerViaAdmin.delegate = self
        self.pickerViaAdmin.selectRow(1, inComponent: 0, animated: true)
        
        self.title = "Información de la receta"


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func emptyField(field : String){
        //creates popup message
        let alerta = UIAlertController(title: "Alerta!", message: "Parece que olvidaste llenar \(field)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Regresar", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
    }
    
    // MARK: - Picker Functions
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if(pickerView.tag == 0){
            return 1
        }
        else if(pickerView.tag == 1){
            return 1
        }
        else{
            return 1
        }
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 0){
            return arrDosis.count
        }
        else if(pickerView.tag == 1){
            return arrDuracion.count
        }
        else{
            return arrViaAdmin.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0){
            return arrDosis[row]
        }
        else if(pickerView.tag == 1){
            return arrDuracion[row]
        }
        else{
            return arrViaAdmin[row]
        }
    }

    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if(fldDosis.text != "" && fldDuracion.text != ""){
            return true
        }
        else{
            emptyField("algun campo")
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewSiguiente = segue.destinationViewController as! AgregarMedicamento4ViewController
        
        medMedicina.dDosis = Double(fldDosis.text!)!
        medMedicina.iDias = Int(fldDuracion.text!)!
        medMedicina.sViaAdministracion = arrViaAdmin[pickerViaAdmin.selectedRowInComponent(0)]
        
        viewSiguiente.medMedicina = medMedicina
    }

}
