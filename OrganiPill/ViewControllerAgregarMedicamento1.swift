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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerTipoMedicamentos.dataSource = self
        self.pickerTipoMedicamentos.delegate = self
		self.title = "Agregar Medicamento"
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(fldNombre.text != nil){
            
        }
    }

}
