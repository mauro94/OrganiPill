//
//  ViewControllerEditar.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 4/18/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerEditar: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    //OUTLETS
    @IBOutlet weak var txviewComentario: UITextView!
    @IBOutlet weak var swAlimentos: UISwitch!
    @IBOutlet weak var txCajaActual: UITextField!
    @IBOutlet weak var txMiligramosCaja: UITextField!
	@IBOutlet weak var sgmTipoCantidad: UISegmentedControl!
	@IBOutlet weak var pckCantidad: UIPickerView!
	@IBOutlet weak var pckNumeroCaja: UIPickerView!
    @IBOutlet weak var scScrollView: UIScrollView!
	@IBOutlet weak var pckDosis: UIPickerView!
    @IBOutlet weak var pckTipoMed: UIPickerView!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfDosis: UITextField!
	@IBOutlet weak var lbNumeroMedsEnCaja: UILabel!
	@IBOutlet weak var lbDosisPorMed: UILabel!
	
	//VARIABLES
	let arrTiposMedicamento = ["Supositorio", "Inyección", "Cápsula", "Pastilla", "Tableta", "Suspensión"]
    let pickerDataDuracion = ["Dia(s)","Semana(s)","Mes(es)"]
	var arrValoresCaja = [Int]()
	var arrValoresCantidad = [Int]()
	var arrValores = [Int]()
	
    var delegado = ProtocoloReloadTable!(nil)
    var indMedicamento : Medicamento! = Medicamento()
	
	override func viewDidLoad() {
		super.viewDidLoad()
        tfNombre.delegate = self
		
		self.title = "Editar"
		
		let editButton : UIBarButtonItem = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(guardarbottonpress))
		
		self.navigationItem.rightBarButtonItem = editButton
		
		var titulo: String! = ""
		var subTitulo: String! = ""
		
		//nombre
		tfNombre.text = indMedicamento.sNombre
		
		//tipo de medicamento
		pckTipoMed.delegate = self
		pckTipoMed.dataSource = self
		let ubicacion = arrTiposMedicamento.indexOf(indMedicamento.sTipoMedicina)
		pckTipoMed.selectRow(ubicacion!, inComponent: 0, animated: true)
		pckTipoMed.tag = 1
		
		switch(indMedicamento.sTipoMedicina){
		case "Pastilla":
			titulo = "Número de pastillas restantes:"
			subTitulo = "Dosis por pastilla:"
			break
		case "Inyección":
			titulo = "Número de botes restantes:"
			subTitulo = "Dosis por bote:"
			break
		case "Supositorio":
			titulo = "Número de supositorios restantes:"
			subTitulo = "Dosis por supositorio:"
			break
		case "Suspensión":
			titulo = "Número de botes restantes:"
			subTitulo = "Dosis por bote:"
			break
		case "Cápsula":
			titulo = "Número de cápsulas restantes:"
			subTitulo = "Dosis por cápsula:"
			break
		case "Tableta":
			titulo = "Número de tabletas restantes:"
			subTitulo = "Dosis por tableta:"
			break
		default:
			break
		}
		
		lbNumeroMedsEnCaja.text = titulo
		
		//alimento
		if (indMedicamento.bNecesitaAlimento) {
			swAlimentos.on = true
		}
		
		//numero de meds en caja
        
        
		txCajaActual.text = String(indMedicamento.dCantidadPorCajaActual)
		
		pckNumeroCaja.delegate = self
		pckNumeroCaja.dataSource = self
		pckNumeroCaja.tag = 2
		
		//cantidad de meds por caja
		lbDosisPorMed.text = subTitulo
		
		txMiligramosCaja.text = String(indMedicamento.dDosisPorTipo)
		
		pckCantidad.delegate = self
		pckCantidad.dataSource = self
		pckCantidad.tag = 3
		
		switch indMedicamento.sUnidadesDosis {
		case "Miligramos":
			sgmTipoCantidad.selectedSegmentIndex = 0
		case "Mililitros":
			sgmTipoCantidad.selectedSegmentIndex = 1
		case "Microgramos":
			sgmTipoCantidad.selectedSegmentIndex = 2
		default:
			print("ERROR")
		}
		
		//dosis
		tfDosis.text = String( indMedicamento.dDosisRecetada)
		
		pckDosis.delegate = self
		pckDosis.dataSource = self
		pckDosis.tag = 4
		
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
	
	override func viewDidAppear(animated: Bool) {
		pckNumeroCaja.selectRow(Int(indMedicamento.dCantidadPorCajaActual)-1, inComponent: 0, animated: true)
		pckCantidad.selectRow(Int((indMedicamento.dDosisPorTipo-10)/10), inComponent: 0, animated: true)
		
		pckDosis.selectRow(Int(indMedicamento.dDosisRecetada) - 1, inComponent: 0, animated: true)
		
	}
	
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

    
    func Guardar() -> Bool {
        if(tfDosis.text != "" && tfNombre.text != "" ){
            //actualiza las notificaciones al nuevo nombre
            if(indMedicamento.sNombre != tfNombre.text!){
                //actualizarNotificaciones()
            }
            
            let realm = try! Realm()
            
            try! realm.write {
                indMedicamento.sNombre = tfNombre.text!
                indMedicamento.dDosisRecetada = Double(tfDosis.text!)!
                
                indMedicamento.dDosisPorTipo = Double(txMiligramosCaja.text!)!
              
                indMedicamento.dCantidadPorCajaActual = Double(txCajaActual.text!)!
				
				indMedicamento.sTipoMedicina = arrTiposMedicamento[pckTipoMed.selectedRowInComponent(0)]
				
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
        else {
            let alerta = UIAlertController(title: "ERROR", message: "¡Dejaste casillas en blanco!",preferredStyle:  UIAlertControllerStyle.Alert)
            
            alerta.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.Cancel, handler:nil))
            
            
            presentViewController(alerta,animated:true, completion:nil)
            
            return false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        textField.resignFirstResponder()
        return true
    }
	
    /*
    //cambia los nombres de las medicinas en todas las listas de medicinas
    func actualizarNotificaciones(){
        let realm = try! Realm()
        let listasNotif = realm.objects(Notificaciones)
		
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
    */
    
    
	func guardarbottonpress(sender:AnyObject) {
		if(Guardar()) {
            let refreshAlert = UIAlertController(title: "Datos Actualizados", message: "Los datos se grabaron correctamente ", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction!) in
                
                self.performSegueWithIdentifier("unwind", sender: sender)
            }))
            
            
            presentViewController(refreshAlert, animated: true, completion: nil)
		}
    }
    
	
    @IBAction func btnBorrarMedicamento(sender: AnyObject) {
		
		let adv = UIAlertController(title: "Borrar " + indMedicamento.sNombre, message: "¿Estás seguro?", preferredStyle: UIAlertControllerStyle.Alert)
		
		adv.addAction(UIAlertAction(title: "Cancelar", style: .Default, handler: nil))
		
		adv.addAction(UIAlertAction(title: "Borrar", style: .Destructive, handler: {(action: UIAlertAction!) in self.borrar()}))
		
		presentViewController(adv, animated: true, completion: nil)
    }
	
	func borrar() {
		let realm = try! Realm()
		
		let handler = HandlerNotificaciones()
		
		handler.deleteNotifcationsFromMed(indMedicamento)
		
		try! realm.write {
			realm.delete(indMedicamento)
		}
        
        handler.rescheduleNotificaciones()
		
		self.navigationController?.popToRootViewControllerAnimated(true)
	}
	
	
	// MARK: - Picker Functions
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		if (pickerView.tag == 1) {
			return 1
		}
		else if (pickerView.tag == 2) {
			return 1
		}
		else if (pickerView.tag == 3) {
			return 1
		}
		else if (pickerView.tag == 4) {
			return 1
		}
		else {
			return 1
		}
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
		else {
			tfDosis.text = "\(pickerView.selectedRowInComponent(component)+1)"
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