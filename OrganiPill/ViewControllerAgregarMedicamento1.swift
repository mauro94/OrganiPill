//
//  ViewControllerAgregarMedicamento1.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/7/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class ViewControllerAgregarMedicamento1: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
    
    
    
    // MARK: - Outlets
    @IBOutlet weak var pickerTipoMedicamentos: UIPickerView!
    @IBOutlet weak var fldNombre: UITextField!
    @IBOutlet weak var swAlimento: UISwitch!
    
    // MARK: - Global Variables
    let arrTiposMedicamento = ["Supositorio", "Inyección", "Cápsulas", "Pastilla", "Tabletas", "Suspensión"]
    var medMedicina : Medicamento = Medicamento()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerTipoMedicamentos.dataSource = self
        self.pickerTipoMedicamentos.delegate = self
        self.pickerTipoMedicamentos.selectRow(2, inComponent: 0, animated: true)
        
		self.title = "Agregar Medicamento"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func quitarTeclado() {
		self.view.endEditing(true)
	}
	
    func emptyField(field : String){
        //creates popup message
        let alerta = UIAlertController(title: "¡Alerta!", message: "Parece que olvidaste llenar el \(field)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Regresar", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
    }
    
    // MARK: - Picker Functions
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrTiposMedicamento.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrTiposMedicamento[row]
    }

    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if(fldNombre.text != ""){
            return true
        }
        else{
            emptyField("nombre del medicamento")
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewSiguiente = segue.destinationViewController as! ViewControllerAgregarMedicamento2
        
        //guarda los datos del medicamento de esta vista
        medMedicina.sNombre = fldNombre.text!
        medMedicina.bNecesitaAlimento = swAlimento.on
        medMedicina.sViaAdministracion = arrTiposMedicamento[pickerTipoMedicamentos.selectedRowInComponent(0)]
        
        viewSiguiente.medMedicina = medMedicina
    }

}
