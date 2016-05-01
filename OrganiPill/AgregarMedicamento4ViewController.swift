//
//  AgregarMedicamento4ViewController.swift
//  OrganiPill
//
//  Created by David Benitez on 4/17/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class AgregarMedicamento4ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProtocoloAgregarHorario {

    // MARK: - Outlets
    @IBOutlet weak var tableHorarios: UITableView!
    
    // MARK: - Global Variables
    var medMedicina : Medicamento = Medicamento()
    var listaHorarios = List<CustomDate>()
    var notificaciones = Notificaciones()
    let calendar = NSCalendar.currentCalendar()
    var listaNotificaciones = NSMutableArray()
    var index : Int!
    let onBttnColor : UIColor = UIColor(red: 255/255, green: 70/255, blue: 89/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Horario"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(AgregarMedicamento4ViewController.newButtonPressed(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newButtonPressed(sender: AnyObject){
        performSegueWithIdentifier("newH", sender: sender)
    }
    
    //MARK: - Protocol functions
    func agregarHorario(horario : CustomDate) {
        listaHorarios.append(horario)
        tableHorarios.reloadData()
    }
    
    func editarHorario(horario : CustomDate){
        listaHorarios[index] = horario
        tableHorarios.reloadData()
    }
    
    func quitaVista() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: - Table View Data Source functions
    func tableView ( tableView: UITableView,
                     numberOfRowsInSection section: Int) -> Int{
        return listaHorarios.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "cell", forIndexPath: indexPath) as! CustomTableViewCell
        
        //formatea la hora a 1-12 xM y la muestra
        let formatoHoraConMeridiano = NSDateFormatter()
        formatoHoraConMeridiano.dateFormat = "h:mm a"
        let units: NSCalendarUnit = [.Hour, .Minute]
        let myComponents = calendar.components(units, fromDate: NSDate())
        myComponents.hour = listaHorarios[indexPath.row].horas
        myComponents.minute = listaHorarios[indexPath.row].minutos
        
        let hora = calendar.dateFromComponents(myComponents)
        cell.lblHora?.text = formatoHoraConMeridiano.stringFromDate(hora!)

        //colorea los botones
        let numElementos = listaHorarios[indexPath.row].listaDias.count
        for i in 0...(numElementos-1){
            let dia = listaHorarios[indexPath.row].listaDias[i]
            cell.bttnDias?[(dia.dia - 1)].backgroundColor = onBttnColor
        }
        
        //agrega marcos a los botones
        for i in 0...6{
            agregaBorderButton(cell.bttnDias[i])
        }
        
        return cell
    }
    
    //funcion que agregar bordes a los botones
    func agregaBorderButton(sender: UIButton) {
        sender.layer.borderWidth = 0.5
        sender.layer.borderColor = onBttnColor.CGColor
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let viewAgregar = segue.destinationViewController as! AgregarHorarioViewController
        
        viewAgregar.delegado = self
        
        //nuevo horario
        if(segue.identifier == "newH"){
            viewAgregar.horaEdit = "12:00"
        }
        //editar horario
        else if(segue.identifier == "editH"){
            //guarda el indice seleccionado
            let indexPath = self.tableHorarios.indexPathForSelectedRow
            index = indexPath!.row

            //se formatea un string con la hora seleccionada
            let units: NSCalendarUnit = [.Hour, .Minute]
            let myComponents = calendar.components(units, fromDate: NSDate())
            myComponents.hour = listaHorarios[index].horas
            myComponents.minute = listaHorarios[index].minutos
            viewAgregar.horaEdit = getHourAsString(myComponents)
            
            for i in listaHorarios[index].listaDias{
                viewAgregar.diasEdit.append(i.dia)
            }
            
            viewAgregar.editing = true
        }
    }
    
    func noHorarioAlert(){
        //creates popup message
        let alerta = UIAlertController(title: "Alerta!", message: "Parece que olvidaste agregar un horario", preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Regresar", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
    }

    @IBAction func presionaTerminar(sender: AnyObject) {
        if(listaHorarios.count == 0){
            noHorarioAlert()
            return
        }
        else{
            medMedicina.horario = listaHorarios
            guardaRealm()
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
    //guarda la medicina y notificaciones a la base de datos REALM
    func guardaRealm(){
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(medMedicina)
        }
        
        let notif : HandlerNotificaciones = HandlerNotificaciones(medMedicamento: medMedicina)
        
        notif.generarNotificaciones()
    }
    
    //genera un string en formato "HH:MM" a partir de componentes
    func getHourAsString(components : NSDateComponents) -> String{
        var hour : String = ""
        
        if(components.hour < 10){
            hour += "0"
        }
        
        hour += "\(components.hour):"
        
        if(components.minute < 10){
            hour += "0"
        }
        
        hour += "\(components.minute)"
        
        return hour
    }
}
