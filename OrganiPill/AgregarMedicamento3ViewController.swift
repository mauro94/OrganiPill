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
    
    // MARK: - Global Variables
    let arrDosis = ["Miligramos", "Mililitros"]
    let arrDuracion = ["Dia(s)", "Semana(s)", "Mes(es)"]
    let arrViaAdmin = ["Oral", "Inyección", "Supositorio"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerDosis.dataSource = self
        self.pickerDosis.delegate = self
        self.pickerDuracion.dataSource = self
        self.pickerDuracion.delegate = self
        self.pickerViaAdmin.dataSource = self
        self.pickerViaAdmin.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
