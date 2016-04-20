//
//  AgregarHorarioViewController.swift
//  OrganiPill
//
//  Created by David Benitez on 4/18/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

protocol ProtocoloAgregarHorario{
    func agregarHorario(horario : CustomDate)
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
    
    var delegado = ProtocoloAgregarHorario!(nil)
    var horario : CustomDate = CustomDate()
    let onBttnColor : UIColor = UIColor(red: 255/255, green: 70/255, blue: 89/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = UIDatePickerMode.Time
        
        self.title = "Agregar Horario"
        
        let guardarButton : UIBarButtonItem = UIBarButtonItem(title: "Guardar", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = guardarButton
        
        guardarButton.target = self
        guardarButton.action = #selector(AgregarHorarioViewController.guardarButtonPressed(_:))
    
        let cancelarButton : UIBarButtonItem = UIBarButtonItem(title: "Cancelar", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationItem.leftBarButtonItem = cancelarButton
        
        cancelarButton.target = self
        cancelarButton.action = #selector(AgregarHorarioViewController.cancelarButtonPressed(_:))
        
        agregaBorderButton(bttnD)
        agregaBorderButton(bttnL)
        agregaBorderButton(bttnMa)
        agregaBorderButton(bttnMi)
        agregaBorderButton(bttnJ)
        agregaBorderButton(bttnV)
        agregaBorderButton(bttnS)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button functions
    //funcion que agregar bordes a los botones
    func agregaBorderButton(sender: UIButton) {
        sender.layer.borderWidth = 0.5
        sender.layer.borderColor = onBttnColor.CGColor
    }
    
    @IBAction func selectDay(sender: UIButton) {
        //color de prendido
        if(!sender.selected){
            sender.backgroundColor = onBttnColor
        }
        //color de apagado
        else{
            sender.backgroundColor = UIColor.whiteColor()
        }
        
        //voltea el valor
        sender.selected = !sender.selected
    }
    
    func cancelarButtonPressed(sender: AnyObject){
        navigationController?.popViewControllerAnimated(true)
    }
    
    func guardarButtonPressed(sender: AnyObject){
        //saca la hora del picker
        let components = datePicker.calendar.components([.Hour, .Minute], fromDate: datePicker.date)
        
        horario.minutos = components.minute
        
        if(components.hour >= 12 && components.hour < 24){
            horario.meridiano = "PM"
        }
        else{
            horario.meridiano = "AM"
        }
        
        horario.horas = components.hour%12
        
        if(horario.horas == 0){
            horario.horas = 12
        }
        
        //hace la lista de dias programados
        
        if(bttnD.selected){
            let dia : RealmInt = RealmInt()
            dia.dia = 1
            horario.listaDias.append(dia)
        }
        if(bttnL.selected){
            let dia : RealmInt = RealmInt()
            dia.dia = 2
            horario.listaDias.append(dia)
        }
        if(bttnMa.selected){
            let dia : RealmInt = RealmInt()
            dia.dia = 3
            horario.listaDias.append(dia)
        }
        if(bttnMi.selected){
            let dia : RealmInt = RealmInt()
            dia.dia = 4
            horario.listaDias.append(dia)
        }
        if(bttnJ.selected){
            let dia : RealmInt = RealmInt()
            dia.dia = 5
            horario.listaDias.append(dia)
        }
        if(bttnV.selected){
            let dia : RealmInt = RealmInt()
            dia.dia = 6
            horario.listaDias.append(dia)
        }
        if(bttnS.selected){
            let dia : RealmInt = RealmInt()
            dia.dia = 7
            horario.listaDias.append(dia)
        }
        
        //print(horario.listaDias.count)
        
        //print(horario.horas)
        //print(horario.minutos)
        //print(horario.meridiano)
        delegado.agregarHorario(horario)
        delegado.quitaVista()
        
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
