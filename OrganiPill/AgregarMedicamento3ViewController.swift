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
    @IBOutlet weak var fldDosis: UITextField!
    @IBOutlet weak var fldDuracion: UITextField!
    @IBOutlet weak var txtvComentarios: UITextView!
    
    // MARK: - Global Variables
    let arrDosis = ["Pastillas", "Cucharadas", ]
    let arrDuracion = ["Dia(s)", "Semana(s)", "Mes(es)"]
    var medMedicina : Medicamento = Medicamento()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerDosis.dataSource = self
        self.pickerDosis.delegate = self
        self.pickerDosis.selectRow(1, inComponent: 0, animated: true)
        
        self.pickerDuracion.dataSource = self
        self.pickerDuracion.delegate = self
        self.pickerDuracion.selectRow(1, inComponent: 0, animated: true)
        
        self.title = "Información de la receta"


        // Do any additional setup after loading the view.
    }
    @IBAction func quitateclado(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Hace una alerta si falta un dato por llenar
    func emptyField(){
        //creates popup message
        let alerta = UIAlertController(title: "Alerta!", message: "Parece que olvidaste llenar algun campo!", preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Regresar", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
    }
    
    // MARK: - Picker Functions
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if(pickerView.tag == 0){
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
        else{
            return arrDuracion.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0){
            return arrDosis[row]
        }
        else{
            return arrDuracion[row]
        }
    }

    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if(fldDosis.text != "" && fldDuracion.text != ""){
            return true
        }
        else{
            emptyField()
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewSiguiente = segue.destinationViewController as! AgregarMedicamento4ViewController
        
        //guarda los datos del medicamento de esta vista
        medMedicina.dDosis = Double(fldDosis.text!)!
        medMedicina.iDuracion = Int(fldDuracion.text!)!
        medMedicina.sComentario = txtvComentarios.text!
        medMedicina.sTipoDuracion = getTipoDuracion()
        
        viewSiguiente.medMedicina = medMedicina
    }
    
    //funcion que regresa un tipo caracter indicando la unidad de duracion
    func getTipoDuracion() -> String{
        switch(pickerDuracion.selectedRowInComponent(0)){
            case 0:
                return "d"
            case 1:
                return "s"
            case 2:
                return "m"
            default:
                return "x"
        }
    }

}
