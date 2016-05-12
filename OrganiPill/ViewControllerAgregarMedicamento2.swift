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
	@IBOutlet weak var pickerCantidadCaja: UIPickerView!
	@IBOutlet weak var sgmUnidadDosis: UISegmentedControl!
    
    
    @IBAction func quitateclado(){
        view.endEditing(true)
    }
    
    // MARK: - Global Variables
    //var arrMedidas = NSMutableArray()
    var arrValoresCaja = [Int]()
	var arrValoresCantidad = [Int]()
    var titulo : String!
    var subTitulo : String!
	var valorEscrito: Int! = -1
    var medMedicina : Medicamento = Medicamento()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.pickerMedidas.dataSource = self
        self.pickerMedidas.delegate = self
        self.pickerMedidas.selectRow(1, inComponent: 0, animated: true)
		self.pickerMedidas.tag = 1
		
		self.pickerCantidadCaja.dataSource = self
		self.pickerCantidadCaja.delegate = self
		self.pickerCantidadCaja.selectRow(1, inComponent: 0, animated: true)
		self.pickerCantidadCaja.tag = 2
		
        self.title = "Información del Medicamento"
        
        decideTitulo()
        lblTitulo.text = titulo
        lblSubTitulo.text = subTitulo
		
		registrarseParaNotificacionesDeTeclado()
		
		fldNumeroPCaja.text = "\(1)"
		fieldCantidadPCaja.text = "\(10)"
		
		//llenar arreglo con dato numericos
		for i in 1...100 {
			arrValoresCaja.append(i)
			arrValoresCantidad.append(i*10)
		}
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
		pickerMedidas.userInteractionEnabled = false
		pickerCantidadCaja.userInteractionEnabled = false
	}
	
	func keyboardWillBeHidden (aNotification : NSNotification) {
		pickerMedidas.userInteractionEnabled = true
		pickerCantidadCaja.userInteractionEnabled = true
		
		if (fldNumeroPCaja.text != "") {
			//si valor nuevo de text field esta en picker seleccionarlo
			let row = arrValoresCaja.indexOf(Int(fldNumeroPCaja.text!)!)
			
			if (row != nil) {
				pickerCantidadCaja.selectRow(row!, inComponent: 0, animated: true)
			}
			else {
				if(Int(fldNumeroPCaja.text!) > 100) {
					valorEscrito = Int(fldNumeroPCaja.text!)
					pickerView(pickerCantidadCaja, didSelectRow: 99, inComponent: 0)
					pickerCantidadCaja.selectRow(99, inComponent: 0, animated: true)
				}
				
				if(Int(fldNumeroPCaja.text!) < 1) {
					pickerCantidadCaja.selectRow(0, inComponent: 0, animated: true)
				}
			}
		}
		
		if (fieldCantidadPCaja.text != "") {
			var row2 = arrValoresCantidad.indexOf(Int(fieldCantidadPCaja.text!)!)
			
			if (row2 != nil) {
				pickerMedidas.selectRow(row2!, inComponent: 0, animated: true)
			}
				
			else {
				row2 = Int(Int(fieldCantidadPCaja.text!)!/10)
				row2 = arrValoresCantidad.indexOf(row2!*10)
				if (row2 != nil) {
					valorEscrito = Int(fieldCantidadPCaja.text!)
					
					pickerView(pickerMedidas, didSelectRow: row2!, inComponent: 0)
					pickerMedidas.selectRow(row2!, inComponent: 0, animated: true)
				}
				
				if(Int(fieldCantidadPCaja.text!) > 1000) {
					valorEscrito = Int(fieldCantidadPCaja.text!)
					pickerView(pickerMedidas, didSelectRow: 99, inComponent: 0)
					pickerMedidas.selectRow(99, inComponent: 0, animated: true)
				}
				
				if(Int(fieldCantidadPCaja.text!) < 10) {
					valorEscrito = Int(fieldCantidadPCaja.text!)
					pickerView(pickerMedidas, didSelectRow: 0, inComponent: 0)
					pickerMedidas.selectRow(0, inComponent: 0, animated: true)
				}
			}
		}
	}
	
	@IBAction func quitarTeclado() {
		self.view.endEditing(true)
	}
	
    //alerta si no todo está completo
    func emptyField(field : String){
        //creates popup message
        let alerta = UIAlertController(title: "¡Alerta!", message: "\(field)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Regresar", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
    }
    
    func decideTitulo(){
        //decide titulo de la siguiente vista
        switch(medMedicina.sTipoMedicina){
        case "Pastilla":
            titulo = "Número de pastillas por caja:"
            subTitulo = "Dosis por pastilla:"
			sgmUnidadDosis.selectedSegmentIndex = 0
			sgmUnidadDosis.setEnabled(true, forSegmentAtIndex: 0)
			sgmUnidadDosis.setEnabled(false, forSegmentAtIndex: 1)
			sgmUnidadDosis.setEnabled(true, forSegmentAtIndex: 2)
            break
        case "Inyección":
            titulo = "Número de frascos por caja:"
            subTitulo = "Dosis por frasco:"
			sgmUnidadDosis.selectedSegmentIndex = 1
			sgmUnidadDosis.setEnabled(false, forSegmentAtIndex: 0)
			sgmUnidadDosis.setEnabled(true, forSegmentAtIndex: 1)
			sgmUnidadDosis.setEnabled(false, forSegmentAtIndex: 2)
            break
        case "Supositorio":
            titulo = "Número de supositorios por caja:"
            subTitulo = "Dosis por supositorio:"
			sgmUnidadDosis.selectedSegmentIndex = 0
			sgmUnidadDosis.setEnabled(true, forSegmentAtIndex: 0)
			sgmUnidadDosis.setEnabled(false, forSegmentAtIndex: 1)
			sgmUnidadDosis.setEnabled(true, forSegmentAtIndex: 2)
            break
        case "Suspensión":
            titulo = "Número de botes por caja:"
            subTitulo = "Dosis por bote:"
			sgmUnidadDosis.selectedSegmentIndex = 1
			sgmUnidadDosis.setEnabled(false, forSegmentAtIndex: 0)
			sgmUnidadDosis.setEnabled(true, forSegmentAtIndex: 1)
			sgmUnidadDosis.setEnabled(false, forSegmentAtIndex: 2)
            break
        case "Cápsula":
            titulo = "Número de cápsulas por caja:"
            subTitulo = "Dosis por cápsula:"
			sgmUnidadDosis.selectedSegmentIndex = 0
			sgmUnidadDosis.setEnabled(true, forSegmentAtIndex: 0)
			sgmUnidadDosis.setEnabled(false, forSegmentAtIndex: 1)
			sgmUnidadDosis.setEnabled(true, forSegmentAtIndex: 2)
            break
		case "Tableta":
			titulo = "Número de tabletas por caja:"
			subTitulo = "Dosis por tableta:"
			sgmUnidadDosis.selectedSegmentIndex = 0
			sgmUnidadDosis.setEnabled(true, forSegmentAtIndex: 0)
			sgmUnidadDosis.setEnabled(false, forSegmentAtIndex: 1)
			sgmUnidadDosis.setEnabled(true, forSegmentAtIndex: 2)
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
		if (pickerView.tag == 1) {
			return arrValoresCaja.count
		}
		else {
			return arrValoresCantidad.count
		}
		
    }
    
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if (pickerView.tag == 1) {
			return "\(arrValoresCantidad[row])"
		}
		else {
			return "\(arrValoresCaja[row])"
		}
    }
	
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if (pickerView.tag == 1) {
			if (valorEscrito != -1) {
				arrValoresCantidad[row] = valorEscrito
				valorEscrito = -1
			}
			else {
				//llenar arreglo con dato numericos
				for i in 1...100 {
					arrValoresCaja[i-1] = i
					arrValoresCantidad[i-1] = i*10
				}
			}
			
			fieldCantidadPCaja.text = "\(arrValoresCantidad[row])"
		}
			
		else {
			if (valorEscrito != -1) {
				arrValoresCaja[row] = valorEscrito
				valorEscrito = -1
			}
			else {
				//llenar arreglo con dato numericos
				for i in 1...100 {
					arrValoresCaja[i-1] = i
					arrValoresCantidad[i-1] = i*10
				}
			}
			
			fldNumeroPCaja.text = "\(arrValoresCaja[row])"
		}
		
		pickerView.reloadComponent(0)
	}
    
    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
		let dNumCaja: Double? = Double(fldNumeroPCaja.text!)
		let dCantidadCaja: Double? = Double(fieldCantidadPCaja.text!)
        if(dNumCaja != nil && dCantidadCaja != nil){
			if (dNumCaja > 0 && dCantidadCaja > 0) {
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
        let viewPastillero = segue.destinationViewController as! ViewControllerAgregarMedicamentoFoto1
        
        //guarda los datos del medicamento de esta vista
        medMedicina.dCantidadPorCaja = Double(fldNumeroPCaja.text!)!
		medMedicina.dCantidadPorCajaActual = medMedicina.dCantidadPorCaja
		
		switch sgmUnidadDosis.selectedSegmentIndex {
		case 0:
			medMedicina.sUnidadesDosis = "Miligramos"
		case 1:
			medMedicina.sUnidadesDosis = "Mililitros"
		case 2:
			medMedicina.sUnidadesDosis = "Microgramos"
		default:
			print("ERROR")
		}
        
        medMedicina.dDosisPorTipo = Double(fieldCantidadPCaja.text!)!
		
		viewPastillero.medMedicina = medMedicina
	}

}
