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
    @IBOutlet weak var lblSubTitulo: UILabel!
    @IBOutlet weak var fldNumeroPCaja: UITextField!
    @IBOutlet weak var fieldCantidadPCaja: UITextField!
    
    
    @IBAction func quitateclado(){
        view.endEditing(true)
    }
    
    // MARK: - Global Variables
    //var arrMedidas = NSMutableArray()
    let arrMedidas = ["Miligramos", "Mililitros"]
    var titulo : String!
    var subTitulo : String!
    var medMedicina : Medicamento = Medicamento()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerMedidas.dataSource = self
        self.pickerMedidas.delegate = self
        self.pickerMedidas.selectRow(1, inComponent: 0, animated: true)
        
        self.title = "Información del medicamento"
        
        decideTitulo()
        lblTitulo.text = titulo
        lblSubTitulo.text = subTitulo
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
        switch(medMedicina.sViaAdministracion){
        case "Pastilla":
            titulo = "Número de pastillas por caja"
            subTitulo = "Cantidad por pastilla"
            break
        case "Inyección":
            titulo = "Número de botes por caja"
            subTitulo = "Cantidad por bote"
            break
        case "Supositorio":
            titulo = "Número de supositorios por caja"
            subTitulo = "Cantidad por supositorio"
            break
        case "Suspensión":
            titulo = "Número de botes por caja"
            subTitulo = "Cantidad por bote"
            break
        case "Cápsulas":
            titulo = "Número de cápsulas por caja"
            subTitulo = "Cantidad por cápsula"
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
        
        //guarda los datos del medicamento de esta vista
        medMedicina.dMiligramosCaja = Double(fldNumeroPCaja.text!)!*Double(fieldCantidadPCaja.text!)!
        medMedicina.dMiligramosCajaActual = medMedicina.dMiligramosCaja
        
        viewSiguiente.medMedicina = medMedicina
    }

}
