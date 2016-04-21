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
    var index : Int!
    let onBttnColor : UIColor = UIColor(red: 255/255, green: 70/255, blue: 89/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Horario"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(AgregarMedicamento4ViewController.newButtonPressed(_:)))

        //print(medMedicina.dDosis)
        //print(medMedicina.dMiligramosCaja)
        //print(medMedicina.iDias)
        //print(medMedicina.sFotoCaja)
        //print(medMedicina.sFotoPastillero)
        //print(medMedicina.sFotoMedicamento)
        //print(medMedicina.sNombre)
        //print(medMedicina.sViaAdministracion)
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
        
        var hora = "\(listaHorarios[indexPath.row].horas):"
        
        if(listaHorarios[indexPath.row].minutos < 10){
            hora = hora + "0"
        }
        
        hora = hora + "\(listaHorarios[indexPath.row].minutos) \(listaHorarios[indexPath.row].meridiano)"
        
        cell.lblHora?.text = hora

        //colorea los botones
        let numElementos = listaHorarios[indexPath.row].listaDias.count
        for i in 0...(numElementos-1){
            var dia = listaHorarios[indexPath.row].listaDias[i]
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
            var sHoraActual = ""
            
            //agrega horas al string
            if(listaHorarios[index].meridiano == "AM"){
                if(listaHorarios[index].horas == 12){
                    sHoraActual = sHoraActual + "00:"

                }
                else{
                    sHoraActual = sHoraActual + "\(listaHorarios[index].horas):"
                }
            }
            else{
                if(listaHorarios[index].horas == 12){
                    sHoraActual = sHoraActual + "12:"
                }
                else{
                    sHoraActual = sHoraActual + "\(listaHorarios[index].horas + 12):"
                }
            }
            
            //agrega minutos al string
            sHoraActual = sHoraActual + "\(listaHorarios[index].minutos)"
            
            viewAgregar.horaEdit = sHoraActual
            
            for i in listaHorarios[index].listaDias{
                viewAgregar.diasEdit.append(i.dia)
            }
            
            viewAgregar.editing = true
        }
    }

    @IBAction func presionaTerminar(sender: AnyObject) {
        medMedicina.horario = listaHorarios
        guardaRealm()
        print(medMedicina)
    }
    
    //guarda la medicina a la base de datos REALM
    func guardaRealm(){
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(medMedicina)
        }
    }
}
