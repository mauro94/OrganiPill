//
//  AgregarHorarioViewController.swift
//  OrganiPill
//
//  Created by David Benitez on 4/18/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

//Delegado para agregar o editar un horario
protocol ProtocoloAgregarHorario{
    func agregarHorario(horario : CustomDate)
    func editarHorario(horario : CustomDate)
    func revisarHorario(horario : CustomDate) -> Bool
    func revisarHorarioEditar(horario : CustomDate) -> Bool
    func borrarHorario(horario : CustomDate)
    func quitaVista()
}

class AgregarHorarioViewController: UIViewController{

    //MARK: - Outlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var bttnD: UIButton!
    @IBOutlet weak var bttnL: UIButton!
    @IBOutlet weak var bttnMa: UIButton!
    @IBOutlet weak var bttnMi: UIButton!
    @IBOutlet weak var bttnJ: UIButton!
    @IBOutlet weak var bttnV: UIButton!
    @IBOutlet weak var bttnS: UIButton!
    
    //Mark: - Global Variables
    var delegado = ProtocoloAgregarHorario!(nil)
    var horario : CustomDate = CustomDate()
    let onBttnColor : UIColor = UIColor(red: 255/255, green: 70/255, blue: 89/255, alpha: 1)
    var bEditing : Bool = false
    var horaEdit : String!
    var diasEdit : [Int] = []
    var bttnDias = [UIButton]!(nil)
	var iNumDias: Int!
	var counterDias: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = UIDatePickerMode.Time
		if (!bEditing) {
			self.title = "Nuevo Horario"
		}
		else {
			self.title = "Editar Horario"
		}
        
        //Agrega boton derecho a la barra de navegacion
		if (editing) {
			navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Borrar", style: UIBarButtonItemStyle.Done, target: self, action: #selector(AgregarHorarioViewController.borrarButtonPressed(_:)))
		}
        
        //Agrega boton izquierdo a la barra de navegacion
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AgregarHorarioViewController.cancelarButtonPressed(_:)))
        
        bttnDias = [bttnD, bttnL, bttnMa, bttnMi, bttnJ, bttnV, bttnS]
        
        //agrega marcos a botones de dias
        for i in 0...6{
            agregaBorderButton(bttnDias[i])
        }
        
        //prende los dias del horario a editar
        if(editing){
            for i in diasEdit{
                selectDay(bttnDias[i-1])
            }
        }
        
        //muestra la hora default del datePicker
        let dateFormatter = NSDateFormatter()
        //dateFormatter.locale = NSLocale.init(localeIdentifier: "ES")
        dateFormatter.dateFormat =  "HH:mm"
        let date = dateFormatter.dateFromString(horaEdit)
        datePicker.date = date!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //alerta si deja los dias vacios
    func noDayAlert(){
        //creates popup message
        let alerta = UIAlertController(title: "¡Alerta!", message: "Parece que olvidaste seleccionar un día", preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Regresar", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
    }
    
    //alerta si ya existe la hora
    func duplicadoAlert(){
        //creates popup message
        let alerta = UIAlertController(title: "¡Alerta!", message: "Ya tienes esta hora registrada, puedes editar los días haciendo click en la lista", preferredStyle: UIAlertControllerStyle.Alert)
        
        let quitarVista = {
            () -> ((UIAlertAction!) -> ()) in
            return{
                _ in
                self.delegado.quitaVista()
            }}
        
        alerta.addAction(UIAlertAction(title: "Regresar a la lista", style: UIAlertActionStyle.Cancel, handler: quitarVista()))
        
        presentViewController(alerta, animated: true, completion: nil)
    }

    
    // MARK: - Button functions
    func agregaBorderButton(sender: UIButton) {
        sender.layer.borderWidth = 0.5
        sender.layer.borderColor = onBttnColor.CGColor
    }
    
    //pinta el dia
    @IBAction func selectDay(sender: UIButton) {
		if (counterDias < iNumDias) {
			//color de prendido
			if(!sender.selected){
				sender.backgroundColor = onBttnColor
				counterDias += 1
			}
				//color de apagado
			else{
				sender.backgroundColor = UIColor.whiteColor()
				counterDias -= 1
			}
			
			//voltea el valor
			sender.selected = !sender.selected
		}
		else {
			if(sender.selected){
				//voltea el valor
				sender.selected = !sender.selected
				sender.backgroundColor = UIColor.whiteColor()
				counterDias -= 1
			}
			else {
			let alerta = UIAlertController(title: "¡Alerta!", message: "La duración seleccionada es de \(iNumDias!) día(s)", preferredStyle: UIAlertControllerStyle.Alert)
			
			alerta.addAction(UIAlertAction(title: "Regresar", style: UIAlertActionStyle.Cancel, handler: nil))
			
			presentViewController(alerta, animated: true, completion: nil)
			}
		}
    }
	
    //maneja la navegacion sin guardar
    func cancelarButtonPressed(sender: AnyObject){
        navigationController?.popViewControllerAnimated(true)
    }
    
    //maneja el boton de borrar
    func borrarButtonPressed(sender: AnyObject){
        let aux = CustomDate()
        delegado.borrarHorario(aux)
        delegado.quitaVista()
    }
    
    //guarda la fecha
    @IBAction func guardarButtonPressed(sender: AnyObject){
        //hace la lista de dias programados
        for i in 0...6{
            if(bttnDias[i].selected){
                let dia : RealmInt = RealmInt()
                dia.dia = i+1
                horario.listaDias.append(dia)
            }
        }
        
        if(horario.listaDias.count == 0){
            noDayAlert()
            return
        }
        
        //saca la hora del picker
        let components = datePicker.calendar.components([.Hour, .Minute], fromDate: datePicker.date)
        
        horario.minutos = components.minute
        horario.horas = components.hour
        
        
        //llama al metodo adecuado para generar o editar horario
        if(!editing){
            if(delegado.revisarHorario(horario)){
                delegado.agregarHorario(horario)
                delegado.quitaVista()
            }
            else{
                duplicadoAlert()
            }
            
        }
        else{
            if(delegado.revisarHorarioEditar(horario)){
                delegado.editarHorario(horario)
                editing = false
                delegado.quitaVista()
            }
            else{
                duplicadoAlert()
            }
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
