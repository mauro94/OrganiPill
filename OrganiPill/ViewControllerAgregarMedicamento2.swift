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
    var medMedicina : Medicamento = Medicamento()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
	
	@IBAction func quitarTeclado() {
		self.view.endEditing(true)
	}
	
    func emptyField(field : String){
        //creates popup message
        let alerta = UIAlertController(title: "¡Alerta!", message: "Parece que olvidaste llenar \(field)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Regresar", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
    }
    
    func decideTitulo(){
        //decide titulo de la siguiente vista
        switch(medMedicina.sTipoMedicina){
        case "Pastilla":
            titulo = "Número de pastillas por caja:"
            subTitulo = "Dosis por pastilla:"
            break
        case "Inyección":
            titulo = "Número de botes por caja:"
            subTitulo = "Dosis por bote:"
            break
        case "Supositorio":
            titulo = "Número de supositorios por caja:"
            subTitulo = "Dosis por supositorio:"
            break
        case "Suspensión":
            titulo = "Número de botes por caja:"
            subTitulo = "Dosis por bote:"
            break
        case "Cápsula":
            titulo = "Número de cápsulas por caja:"
            subTitulo = "Dosis por cápsula:"
            break
		case "Tableta":
			titulo = "Número de tabletas por caja:"
			subTitulo = "Dosis por tableta:"
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
			fieldCantidadPCaja.text = "\((pickerView.selectedRowInComponent(component)+1)*10)"
			return "\(arrValoresCantidad[row])"
		}
		
		else {
			fldNumeroPCaja.text = "\(pickerView.selectedRowInComponent(component)+1)"
			return "\(arrValoresCaja[row])"
		}
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
        
        viewSiguiente.medMedicina = medMedicina
    }

}
