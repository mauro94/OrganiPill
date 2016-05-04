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
    @IBOutlet weak var segmentedControlTipoDuracion: UISegmentedControl!
    
    
    // MARK: - Global Variables
    let arrDosis = ["Pastillas", "Cucharadas", ]
    let arrDuracion = ["Dia(s)", "Semana(s)", "Mes(es)"]
    var medMedicina : Medicamento = Medicamento()
	var arrValores = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerDosis.dataSource = self
        self.pickerDosis.delegate = self
        self.pickerDosis.selectRow(1, inComponent: 0, animated: true)
		self.pickerDosis.tag = 1
        
        self.pickerDuracion.dataSource = self
        self.pickerDuracion.delegate = self
        self.pickerDuracion.selectRow(1, inComponent: 0, animated: true)
		self.pickerDuracion.tag = 2
        
        self.title = "Información de la receta"
		
		//llenar arreglo con dato numericos
		for i in 1...10 {
			arrValores.append(i)
		}


        // Do any additional setup after loading the view.
    }
    @IBAction func quitateclado(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func quitarTeclado() {
		self.view.endEditing(true)
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
		return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return arrValores.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if (pickerView.tag == 1) {
			fldDosis.text = "\(pickerView.selectedRowInComponent(component)+1)"
			return "\(arrValores[row])"
		}
			
		else {
			fldDuracion.text = "\(pickerView.selectedRowInComponent(component)+1)"
			return "\(arrValores[row])"
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
        medMedicina.dDosisRecetada = Double(fldDosis.text!)!
        medMedicina.iDuracion = Int(fldDuracion.text!)!
        medMedicina.sTipoDuracion = getTipoDuracion()
        
        viewSiguiente.medMedicina = medMedicina
    }
    
    //funcion que regresa un tipo caracter indicando la unidad de duracion
    func getTipoDuracion() -> String{
    switch(segmentedControlTipoDuracion.selectedSegmentIndex){
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
