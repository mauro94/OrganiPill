//
//  AgregarMedicamento4ViewController.swift
//  OrganiPill
//
//  Created by David Benitez on 4/17/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class MisMedicamentosVerHorario: UIViewController, UITableViewDataSource, UITableViewDelegate, ProtocoloAgregarHorario1 {
    
    // MARK: - Outlets
    @IBOutlet weak var tableHorarios: UITableView!
    
    // MARK: - Global Variables
    var medMedicina : Medicamento = Medicamento()

    var listaHorarios = List<CustomDate>()
    var auxlistaHorarios = List<CustomDate>()
    
    var notificaciones = Notificaciones()
    let calendar = NSCalendar.currentCalendar()
    var listaNotificaciones = NSMutableArray()
    var index : Int!
    var indexCell: NSIndexPath!
    let onBttnColor : UIColor = UIColor(red: 255/255, green: 70/255, blue: 89/255, alpha: 1)
    
    override func viewDidAppear(animated: Bool) {
        tableHorarios.reloadData()
        super.viewDidLoad()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableHorarios.reloadData()
        print(listaHorarios)
        //auxlistaHorarios = listaHorarios
        let realm = try! Realm()
        
        try! realm.write {
        //for i in 0...(listaHorarios.count - 1){
            
         //   auxlistaHorarios.append(listaHorarios[i])
            
       // }
            
            listaHorarios = medMedicina.horario
            
        }
        
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
        
        let realm = try! Realm()
        
        try! realm.write {
            listaHorarios.append(horario)
            tableHorarios.reloadData()
        }
        
    }
    
    func editarHorario(horario : CustomDate){
        
        let realm = try! Realm()
        
        try! realm.write {
        
            listaHorarios[index] = horario
            tableHorarios.reloadData()
        }
    }
    
    func borrarHorario(horario : CustomDate){
        
        
        if (listaHorarios.count > 1){
            
            let realm = try! Realm()
            
            try! realm.write {
                
                realm.delete(listaHorarios[index])
                
                tableHorarios.reloadData()
            }
            
        }
        
        else{
            let alerta = UIAlertController(title: "Alerta!", message: "No puedes borrar la unica alarma que tienes", preferredStyle: UIAlertControllerStyle.Alert)
            
            alerta.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            presentViewController(alerta, animated: true, completion: nil)
            
            
            
        }
        
        
        
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
        
        //resetea los colores de los horarios
        for i in 0...6{
            cell.bttnDias?[i].backgroundColor = UIColor.whiteColor()
            cell.bttnDias?[i].setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        }
        
        //colorea los botones prendidos
        let numElementos = listaHorarios[indexPath.row].listaDias.count
        for i in 0...(numElementos-1){
            let dia = listaHorarios[indexPath.row].listaDias[i]
            cell.bttnDias?[(dia.dia - 1)].backgroundColor = onBttnColor
            cell.bttnDias?[(dia.dia - 1)].setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        
        //agrega marcos a los botones
        for i in 0...6{
            agregaBorderButton(cell.bttnDias[i])
        }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 0.2)
        cell.selectedBackgroundView = backgroundView
        
        cell.setNeedsDisplay()
        
        return cell
    }
    
    //funcion que agregar bordes a los botones
    func agregaBorderButton(sender: UIButton) {
        sender.layer.borderWidth = 0.5
        sender.layer.borderColor = onBttnColor.CGColor
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let viewAgregar = segue.destinationViewController as! MisMedicamentosEditarHorario
        
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
            indexCell = indexPath
            
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
    /*
    @IBAction func presionaTerminar(sender: AnyObject) {
        if(auxlistaHorarios.count == 0){
            noHorarioAlert()
            return
        }
        else{
            let realm = try! Realm()
            
             try! realm.write {
                print("HOOOOOOOLA")
                print(auxlistaHorarios)
                medMedicina.horario = auxlistaHorarios
                realm.add(medMedicina,update: true)
                
                
                
            }
            
            
            
            //medMedicina.horario = listaHorarios
            //guardaRealm()
            navigationController?.popToRootViewControllerAnimated(true)
        }
    }
 */
    
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
