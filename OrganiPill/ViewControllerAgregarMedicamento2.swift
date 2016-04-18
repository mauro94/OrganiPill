//
//  ViewControllerAgregarMedicamento2.swift
//  OrganiPill
//
//  Created by David Benitez on 4/13/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class ViewControllerAgregarMedicamento2: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var pickerMedidas: UIPickerView!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var fldNumeroPCaja: UITextField!
    @IBOutlet weak var fieldCantidadPCaja: UITextField!
    
    // MARK: - Global Variables
    //var arrMedidas = NSMutableArray()
    let arrMedidas = ["Miligramos", "Mililitros"]
    var titulo : String!
    var tipoMedicamento : Int!
    var medMedicina : Medicamento = Medicamento()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerMedidas.dataSource = self
        self.pickerMedidas.delegate = self
        self.pickerMedidas.selectRow(1, inComponent: 0, animated: true)
        
        self.title = "Información del medicamento"
        
        decideTitulo()
        lblTitulo.text = titulo
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
    
    func decideTitulo(){
        //decide titulo de la siguiente vista
        switch(tipoMedicamento){
        //pastillas
        case 0:
            titulo = "Número de pastillas en caja"
            break
        //inyeccion
        case 1:
            titulo = "Número de inyecciones en WHAT?"
            break
        //supositorio
        case 2:
            titulo = "Número de WHAT en WHAT?"
            break
        //liquida
        case 3:
            titulo = "Número de algo en algo?"
            break
        default:
            break
        }
    }
    
    // MARK: - Picker Functions
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrMedidas.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrMedidas[row]
    }
    
    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if(fldNumeroPCaja.text != "" && fieldCantidadPCaja.text != ""){
            return true
        }
        else{
            emptyField("algun campo")
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewSiguiente = segue.destinationViewController as! ViewControllerAgregarMedicamentoFoto1
        
        medMedicina.dMiligramosCaja = Double(fldNumeroPCaja.text!)!*Double(fieldCantidadPCaja.text!)!
        
        viewSiguiente.medMedicina = medMedicina
    }

}
