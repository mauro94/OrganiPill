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
	@IBOutlet weak var viewNoHorario: UIView!
	
    // MARK: - Global Variables
    var medMedicina : Medicamento = Medicamento()
    var listaHorarios = List<CustomDate>()
    var notificaciones = Notificaciones()
    let calendar = NSCalendar.currentCalendar()
    var listaNotificaciones = NSMutableArray()
    var index : Int!
	var indexCell: NSIndexPath!
    let onBttnColor : UIColor = UIColor(red: 255/255, green: 70/255, blue: 89/255, alpha: 1)
	var iNumdias: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        self.title = "Horario"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(AgregarMedicamento4ViewController.newButtonPressed(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillAppear(animated: Bool) {
		if (listaHorarios.count > 0) {
			tableHorarios.hidden = false
			viewNoHorario.hidden = true
		}
		else {
			tableHorarios.hidden = true
			viewNoHorario.hidden = false
		}
	}
    
    //hace un segue para agregar horario
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
    
    //edita un horario
    func editarHorario(horario : CustomDate){
        let realm = try! Realm()
        
        try! realm.write {
        listaHorarios[index] = horario
        tableHorarios.reloadData()
        }
    }
    
    func quitaVista() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    //checa que el horario NUEVO no sea existente
    func revisarHorario(horario : CustomDate) -> Bool{
        for i in listaHorarios{
            if (i.horas == horario.horas && i.minutos == horario.minutos){
                return false
            }
        }
        
        return true
    }
    
    //checa que el horario EDITADO no sea existente
    func revisarHorarioEditar(horario : CustomDate) -> Bool{
        for i in 0...listaHorarios.count-1{
            if (index != i && listaHorarios[i].horas == horario.horas && listaHorarios[i].minutos == horario.minutos){
                return false
            }
        }
        
        return true
    }
    
    //borra un horario de la lista
    func borrarHorario(horario : CustomDate){
        listaHorarios.removeAtIndex(index)
        tableHorarios.reloadData()
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
        //formatoHoraConMeridiano.locale = NSLocale.init(localeIdentifier: "ES")
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

        //colorea los botones encendidos
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
	override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
		if (identifier == "comentario") {
			if(listaHorarios.count == 0){
				noHorarioAlert()
				return false
			}
			return true
		}
		return true
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
        //nuevo horario
        if(segue.identifier == "newH"){
			let viewAgregar = segue.destinationViewController as! AgregarHorarioViewController
			
			viewAgregar.delegado = self
			
            viewAgregar.horaEdit = "12:00"
			viewAgregar.iNumDias = iNumdias
        }
        //editar horario
        else if(segue.identifier == "editH"){
			let viewAgregar = segue.destinationViewController as! AgregarHorarioViewController
			
			viewAgregar.delegado = self
			
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
			
            viewAgregar.iNumDias = iNumdias
            viewAgregar.editing = true
        }
		
		else if(segue.identifier == "comentario"){
			let viewAgregar = segue.destinationViewController as! AgregarMedicamento5ViewController
			
			medMedicina.horario = listaHorarios
			
			viewAgregar.medMedicina = medMedicina
		}
    }
    
    //alerta si no hay ningun horario
    func noHorarioAlert(){
        //creates popup message
        let alerta = UIAlertController(title: "¡Alerta!", message: "Parece que olvidaste agregar un horario", preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Regresar", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
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
