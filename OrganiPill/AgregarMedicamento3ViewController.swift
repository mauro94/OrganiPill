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
	@IBOutlet weak var lbDosisRecetada: UILabel!
    
    // MARK: - Global Variables
    let arrDosis = ["Pastillas", "Cucharadas", ]
    let arrDuracion = ["Dia(s)", "Semana(s)", "Mes(es)"]
    var medMedicina : Medicamento = Medicamento()
	var arrValoresDosis = [Int]()
	var arrValoresDuracion = [Int]()
	var valorEscrito: Int! = -1

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.pickerDosis.dataSource = self
        self.pickerDosis.delegate = self
        self.pickerDosis.selectRow(1, inComponent: 0, animated: true)
		self.pickerDosis.tag = 1
        
        self.pickerDuracion.dataSource = self
        self.pickerDuracion.delegate = self
        self.pickerDuracion.selectRow(1, inComponent: 0, animated: true)
		self.pickerDuracion.tag = 2
        
        self.title = "Información de la receta"
		
		registrarseParaNotificacionesDeTeclado()
		
		//llenar arreglo con dato numericos
		if (medMedicina.sTipoMedicina != "Inyección" && medMedicina.sTipoMedicina != "Suspensión" ) {
			for i in 1...10 {
				arrValoresDosis.append(i)
				arrValoresDuracion.append(i)
			}
		}
		else {
			for i in 1...500 {
				arrValoresDosis.append(i)
				arrValoresDuracion.append(i)
			}
		}
		
		//definir text de dosis
		switch(medMedicina.sTipoMedicina){
		case "Pastilla":
			lbDosisRecetada.text = "Dosis recetada (Número de pastillas):"
			break
		case "Inyección":
			lbDosisRecetada.text = "Dosis recetada (mililitros):"
			break
		case "Supositorio":
			lbDosisRecetada.text = "Dosis recetada (Número de supositorios):"
			break
		case "Suspensión":
			lbDosisRecetada.text = "Dosis recetada (mililitros):"
			break
		case "Cápsula":
			lbDosisRecetada.text = "Dosis recetada (Número de cápsulas):"
			break
		case "Tableta":
			lbDosisRecetada.text = "Dosis recetada (Número de tabletas):"
			break
		default:
			break
		}
		
		fldDosis.text = "\(1)"
		fldDuracion.text = "\(1)"


        // Do any additional setup after loading the view.
    }
		
    @IBAction func quitateclado(){
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	private func registrarseParaNotificacionesDeTeclado() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyboardWasShown(_:)),
		                                                 name:UIKeyboardWillShowNotification, object:nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(keyboardWillBeHidden(_:)),
		                                                 name:UIKeyboardWillHideNotification, object:nil)
	}
	
	func keyboardWasShown (aNotification : NSNotification ) {
		pickerDosis.userInteractionEnabled = false
		pickerDuracion.userInteractionEnabled = false
	}
	
	func keyboardWillBeHidden (aNotification : NSNotification) {
		pickerDosis.userInteractionEnabled = true
		pickerDuracion.userInteractionEnabled = true
		
		if (fldDosis.text != "") {
			//si valor nuevo de text field esta en picker seleccionarlo
			let row = arrValoresDosis.indexOf(Int(fldDosis.text!)!)
			
			if (row != nil) {
				pickerDosis.selectRow(row!, inComponent: 0, animated: true)
			}
			else {
				if(Int(fldDosis.text!) > arrValoresDosis.count) {
					valorEscrito = Int(fldDosis.text!)
					pickerView(pickerDosis, didSelectRow: arrValoresDosis.count-1, inComponent: 0)
					pickerDosis.selectRow(arrValoresDosis.count-1, inComponent: 0, animated: true)
				}
				
				if(Int(fldDosis.text!) < 1) {
					pickerDosis.selectRow(0, inComponent: 0, animated: true)
				}
			}
		}
		
		if (fldDuracion.text != "") {
			//si valor nuevo de text field esta en picker seleccionarlo
			let row2 = arrValoresDuracion.indexOf(Int(fldDuracion.text!)!)
			
			if (row2 != nil) {
				pickerDuracion.selectRow(row2!, inComponent: 0, animated: true)
			}
			else {
				if(Int(fldDuracion.text!) > arrValoresDuracion.count) {
					valorEscrito = Int(fldDuracion.text!)
					pickerView(pickerDuracion, didSelectRow: arrValoresDuracion.count-1, inComponent: 0)
					pickerDuracion.selectRow(arrValoresDuracion.count-1, inComponent: 0, animated: true)
				}
				
				if(Int(fldDuracion.text!) < 1) {
					pickerDuracion.selectRow(0, inComponent: 0, animated: true)
				}
			}
		}
	}

	
	@IBAction func quitarTeclado() {
		self.view.endEditing(true)
	}
    
    //Hace una alerta si falta un dato por llenar
	func emptyField(msg: String){
        //creates popup message
        let alerta = UIAlertController(title: "¡Alerta!", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Regresar", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
    }
    
    // MARK: - Picker Functions
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return arrValoresDosis.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if (pickerView.tag == 1) {
			return "\(arrValoresDosis[row])"
		}
			
		else {
			return "\(arrValoresDuracion[row])"
		}
    }
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if (pickerView.tag == 1) {
			if (valorEscrito != -1) {
				arrValoresDosis[row] = valorEscrito
				valorEscrito = -1
			}
			else {
				//llenar arreglo con dato numericos
				if (medMedicina.sTipoMedicina != "Inyección" && medMedicina.sTipoMedicina != "Suspensión" ) {
					for i in 1...10 {
						arrValoresDosis[i-1] = i
					}
				}
				else {
					for i in 1...500 {
						arrValoresDosis[i-1] = i
					}
				}
			}
			
			fldDosis.text = "\(arrValoresDosis[row])"
		}
			
		else {
			if (valorEscrito != -1) {
				arrValoresDuracion[row] = valorEscrito
				valorEscrito = -1
			}
			else {
				//llenar arreglo con dato numericos
				if (medMedicina.sTipoMedicina != "Inyección" && medMedicina.sTipoMedicina != "Suspensión" ) {
					for i in 1...10 {
						arrValoresDuracion[i-1] = i
					}
				}
				else {
					for i in 1...500 {
						arrValoresDuracion[i-1] = i
					}
				}
				
			}
			
			fldDuracion.text = "\(arrValoresDuracion[row])"
		}
		
		pickerView.reloadComponent(0)
	}


    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
		let dDosis: Double? = Double(fldDosis.text!)
		let dDuracion: Double? = Double(fldDuracion.text!)
		if(dDosis != nil && dDuracion != nil){
			if (dDosis > 0 && dDuracion > 0) {
				return true
			}
			emptyField("Los cantidades deben ser mayores a 0")
			return false
		}
        else{
            emptyField("Parece que olvidaste llenar algún campo")
            return false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let viewSiguiente = segue.destinationViewController as! AgregarMedicamento4ViewController
        
        //guarda los datos del medicamento de esta vista
        medMedicina.dDosisRecetada = Double(fldDosis.text!)!
        medMedicina.iDuracion = Int(fldDuracion.text!)!
        medMedicina.sTipoDuracion = getTipoDuracion()
		
		if (medMedicina.sTipoDuracion == "d") {
			viewSiguiente.iNumdias = Int(fldDuracion.text!)
		}
		else {
			viewSiguiente.iNumdias = 100
		}
        
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
