//
//  ViewControllerEditar.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 4/18/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerEditar: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    //OUTLETS
    @IBOutlet weak var txviewComentario: UITextView!
    @IBOutlet weak var swAlimentos: UISwitch!
    @IBOutlet weak var txCajaActual: UITextField!
    @IBOutlet weak var txMiligramosCaja: UITextField!
    @IBOutlet weak var pickDuracion: UIPickerView!
    @IBOutlet weak var txDuracion: UITextField!
	@IBOutlet weak var sgmTipoCantidad: UISegmentedControl!
	@IBOutlet weak var sgmTipoDuracion: UISegmentedControl!
	@IBOutlet weak var pckCantidad: UIPickerView!
	@IBOutlet weak var pckNumeroCaja: UIPickerView!
    @IBOutlet weak var scScrollView: UIScrollView!
	@IBOutlet weak var pckDosis: UIPickerView!
    @IBOutlet weak var pckTipoMed: UIPickerView!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfDosis: UITextField!
	
	//VARIABLES
	let arrTiposMedicamento = ["Supositorio", "Inyección", "Cápsula", "Pastilla", "Tableta", "Suspensión"]
    let pickerDataDuracion = ["Dia(s)","Semana(s)","Mes(es)"]
	var arrValoresCaja = [Int]()
	var arrValoresCantidad = [Int]()
	var arrValores = [Int]()
	
    
    var indMedicamento : Medicamento = Medicamento()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let editButton : UIBarButtonItem = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(guardarbottonpress))
		
		self.navigationItem.rightBarButtonItem = editButton
		
		//nombre
		tfNombre.text = indMedicamento.sNombre
		
		//tipo de medicamento
		pckTipoMed.delegate = self
		pckTipoMed.dataSource = self
		pckTipoMed.selectRow(2, inComponent: 0, animated: true)
		pckTipoMed.tag = 1
		
		//alimento
		if (indMedicamento.bNecesitaAlimento) {
			swAlimentos.on = true
		}
		
		//numero de meds en caja
		txCajaActual.text = String(indMedicamento.dCantidadPorCaja)
		
		pckNumeroCaja.delegate = self
		pckNumeroCaja.dataSource = self
		pckNumeroCaja.selectRow(Int(indMedicamento.dCantidadPorCaja), inComponent: 0, animated: true)
		pckNumeroCaja.tag = 2
		
		//cantidad de meds por caja
		txMiligramosCaja.text = String(indMedicamento.dDosisPorTipo)
		
		pckCantidad.delegate = self
		pckCantidad.dataSource = self
		pckCantidad.selectRow(Int(indMedicamento.dDosisPorTipo/10), inComponent: 0, animated: true)
		pckCantidad.tag = 3
		//FALTA SEGMENT CONTROL DEFIIR EL TAMANO
		
		//dosis
		tfDosis.text = String( indMedicamento.dDosisRecetada)
		
		pckDosis.delegate = self
		pckDosis.dataSource = self
		pckDosis.selectRow(Int(indMedicamento.dDosisRecetada), inComponent: 0, animated: true)
		pckDosis.tag = 4
		
		//duracion
		txDuracion.text = String(indMedicamento.iDuracion)
		
		pickDuracion.delegate = self
		pickDuracion.dataSource = self
		pickDuracion.selectRow(Int(indMedicamento.iDuracion), inComponent: 0, animated: true)
		pickDuracion.tag = 5
		
		let tipoDuracion = indMedicamento.sTipoDuracion
		
		switch tipoDuracion {
		case "s":
			sgmTipoDuracion.selectedSegmentIndex = 0
		case "d":
			sgmTipoDuracion.selectedSegmentIndex = 1
		case "m":
			sgmTipoDuracion.selectedSegmentIndex = 2
		default:
			print("ERROR")
		}
		
		//comentarios
		txviewComentario.text = indMedicamento.sComentario
		
		//llenar arreglo con dato numericos
		for i in 1...100 {
			arrValoresCaja.append(i)
			arrValoresCantidad.append(i*10)
		}
		for i in 1...10 {
			arrValores.append(i)
		}

		scScrollView.contentSize = self.view.frame.size
	}
	
    func checarPosicionPicker() -> Int{
        if(indMedicamento.sTipoMedicina == "Injeccion"){
            return 0
        }
        else if(indMedicamento.sTipoMedicina == "Comestible"){
            return 1
        }
        else if(indMedicamento.sTipoMedicina == "Supositorio"){
            return 2
        }
        else if(indMedicamento.sTipoMedicina == "Tomable"){
            return 3
        }
        else{
            return 4
            
        }
    }
    
    func checarPosicionPickerDuracion() -> Int{
        if(indMedicamento.sTipoDuracion == "d"){
            return 0
        }
        else if(indMedicamento.sTipoDuracion == "s"){
            return 1
        }
        else{
            return 2
        }
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
    
    
    
    func Guardar() -> Bool {
        
        
        
        if(txDuracion.text != "" && tfDosis.text != "" && tfNombre.text != "" ){
            
            //actualiza las notificaciones al nuevo nombre
            if(indMedicamento.sNombre != tfNombre.text!){
                actualizarNotificaciones()
            }
            
            
            let realm = try! Realm()
            
            try! realm.write {
                indMedicamento.sNombre = tfNombre.text!
                indMedicamento.dDosisRecetada = Double(tfDosis.text!)!
                
                indMedicamento.dCantidadPorCaja = Double(txMiligramosCaja.text!)!
              
                indMedicamento.dCantidadPorCajaActual = Double(txCajaActual.text!)!
                
				indMedicamento.sTipoMedicina = arrTiposMedicamento[pckTipoMed.selectedRowInComponent(0)]
                
                if(pickerDataDuracion[pickDuracion.selectedRowInComponent(0)] == "Dia(s)"){
                    indMedicamento.sTipoDuracion = "d"
                }
                else if(pickerDataDuracion[pickDuracion.selectedRowInComponent(0)] == "Semana(s)"){
                    indMedicamento.sTipoDuracion = "s"
                }
                
                else{
                    indMedicamento.sTipoDuracion = "m"
                }
                
               
                
                if(swAlimentos.on){
                    indMedicamento.bNecesitaAlimento = true
                }
                else{
                    indMedicamento.bNecesitaAlimento = false
                }
                
                
                indMedicamento.sComentario = txviewComentario.text
                
                
            }
            
            
            
            
            return true
            
            
            
        }
        else{
            let alerta = UIAlertController(title: "Error", message: "Dejaste casillas en blanco!",preferredStyle:  UIAlertControllerStyle.Alert)
            
            alerta.addAction(UIAlertAction(title: "Ok",style: UIAlertActionStyle.Cancel, handler:nil))
            
            
            presentViewController(alerta,animated:true, completion:nil)
            
            return false
            
            
        }
        
        
        
        
        
        
        
    }
    
    //cambia los nombres de las medicinas en todas las listas de medicinas
    func actualizarNotificaciones(){
        let realm = try! Realm()
        let listasNotif = realm.objects(Notificaciones)
        print("0")
        
        try! realm.write {
            print("0.1")
            var listaPendientes = listasNotif.filter("id == 1").first!
            print("l1")
            var listaTomadas = listasNotif.filter("id == 2").first!
            print("l2")

            var listaAnulada = listasNotif.filter("id == 3").first!
            
            print("1")
            //busca en la lista de medicinas pendientes
            var i = 0
            while(i < listaPendientes.listaNotificaciones.count){
                //encuentra un match
                if(listaPendientes.listaNotificaciones[i].nombreMed == indMedicamento.sNombre){
                    listaPendientes.listaNotificaciones[i].nombreMed = tfNombre.text!
                }
                i += 1
            }
            print("2")

            
            //busca en la lista de medicinas tomadas
            i = 0
            while(i < listaTomadas.listaNotificaciones.count){
                //encuentra un match
                if(listaTomadas.listaNotificaciones[i].nombreMed == indMedicamento.sNombre){
                    listaTomadas.listaNotificaciones[i].nombreMed = tfNombre.text!
                }
                i += 1
            }
            
            print("3")

            //busca en la lista de medicinas anuladas
            i = 0
            while(i < listaAnulada.listaNotificaciones.count){
                //encuentra un match
                if(listaAnulada.listaNotificaciones[i].nombreMed == indMedicamento.sNombre){
                    listaAnulada.listaNotificaciones[i].nombreMed = tfNombre.text!
                }
                i += 1
            }
            
            print("4")

            //actualiza las listas
            realm.add(listaPendientes, update: true)
            realm.add(listaTomadas, update: true)
            realm.add(listaAnulada, update: true)
            print("5")

        }
    }
    
    
    
    func guardarbottonpress(sender:AnyObject){
        
        if(Guardar()){
            
            
            let refreshAlert = UIAlertController(title: "Guardar", message: "Los datos se guardaron correctamente ", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                
                self.performSegueWithIdentifier("unwind", sender: sender)
            }))
            
            
            presentViewController(refreshAlert, animated: true, completion: nil)
            
            
            
            
            
            
            
        }
        
        
        
        
    }
    
    
    @IBAction func btnBorrarMedicamento(sender: AnyObject) {
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.delete(indMedicamento)
        }
        
        
        
        
        let refreshAlert = UIAlertController(title: "Borrado", message: "El medicamento ha sido borrado correctamente", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.navigationController?.popToRootViewControllerAnimated(true)
            
        }))
        
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        
        
    }
	
	
	// MARK: - Picker Functions
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if (pickerView.tag == 1) {
			return arrTiposMedicamento.count;
		}
		else if (pickerView.tag == 2) {
			return arrValoresCaja.count
		}
		else if (pickerView.tag == 3) {
			return arrValoresCantidad.count
		}
		else if (pickerView.tag == 4) {
			return arrValores.count
		}
		else {
			return arrValores.count
		}
		
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if (pickerView.tag == 1) {
			return arrTiposMedicamento[row]
		}
		else if (pickerView.tag == 2) {
			txCajaActual.text = "\(pickerView.selectedRowInComponent(component)+1)"
			return "\(arrValoresCaja[row])"
		}
		else if (pickerView.tag == 3) {
			txMiligramosCaja.text = "\((pickerView.selectedRowInComponent(component)+1)*10)"
			return "\(arrValoresCantidad[row])"
		}
		else if (pickerView.tag == 4) {
			tfDosis.text = "\(pickerView.selectedRowInComponent(component)+1)"
			return "\(arrValores[row])"
		}
		else {
			txDuracion.text = "\(pickerView.selectedRowInComponent(component)+1)"
			return "\(arrValores[row])"
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