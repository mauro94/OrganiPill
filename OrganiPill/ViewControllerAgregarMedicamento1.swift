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
    
    // MARK: - Global Variables
    let arrTiposMedicamento = ["Pastilla", "Inyección", "Supositorio", "Liquida"]
    var medMedicina : Medicamento = Medicamento()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerTipoMedicamentos.dataSource = self
        self.pickerTipoMedicamentos.delegate = self
        self.pickerTipoMedicamentos.selectRow(2, inComponent: 0, animated: true)
        
		self.title = "Información del medicamento"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(fldNombre.text != nil){
            let viewSiguiente = segue.destinationViewController as! ViewControllerAgregarMedicamento2
        
            viewSiguiente.tipoMedicamento = pickerTipoMedicamentos.selectedRowInComponent(0)
        
            medMedicina.sNombre = fldNombre.text!
            viewSiguiente.medMedicina = medMedicina
        }
        else{
            //warning popup
        }
    }

}
