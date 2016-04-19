//
//  AgregarMedicamento4ViewController.swift
//  OrganiPill
//
//  Created by David Benitez on 4/17/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class AgregarMedicamento4ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,ProtocoloAgregarHorario {
    
    // MARK: - Global Variables
    var medMedicina : Medicamento = Medicamento()
    var listaHorarios = List<CustomDate>()

    @IBOutlet weak var tableHorarios: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Horario"
        
        let newButton : UIBarButtonItem = UIBarButtonItem(title: "+", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = newButton
        
        newButton.target = self
        newButton.action = #selector(AgregarMedicamento4ViewController.newButtonPressed(_:))


        print(medMedicina.dDosis)
        print(medMedicina.dMiligramosCaja)
        //print(medMedicina.iDias)
        print(medMedicina.sFotoCaja)
        print(medMedicina.sFotoPastillero)
        print(medMedicina.sFotoMedicamento)
        print(medMedicina.sNombre)
        print(medMedicina.sViaAdministracion)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func newButtonPressed(sender: AnyObject){
        performSegueWithIdentifier("newH", sender: sender)
    }
    
    func agregarHorario(horario : CustomDate) {
        listaHorarios.append(horario)
        print(listaHorarios)
        //print(horario.horas)
        //print(horario.minutos)
        //print(horario.meridiano)
        //print(horario.listaDias)
        tableHorarios.reloadData()
    }
    
    //data source
    func quitaVista() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func tableView ( tableView: UITableView,
                     numberOfRowsInSection section: Int) -> Int{
        return listaHorarios.count
    }
    
    func getDia(dia : Int) -> String{
        switch(dia){
            case 1:
                return "Domingo"
            case 2:
                return "Lunes"
            case 3:
                return "Martes"
            case 4:
                return "Miercoles"
            case 5:
                return "Jueves"
            case 6:
                return "Viernes"
            case 7:
                return "Sabado"
            default:
                return "Dia raro"
        }
    }
    
    //data source
    func tableView(tableView: UITableView, cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "cell", forIndexPath: indexPath)
        
        let hora = "\(listaHorarios[indexPath.row].horas):\(listaHorarios[indexPath.row].minutos) \(listaHorarios[indexPath.row].meridiano)"
        
        cell.textLabel?.text = hora
        
        cell.detailTextLabel?.text = getDia(listaHorarios[indexPath.row].listaDias[0].dia)

        return cell
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let viewAgregar = segue.destinationViewController as! AgregarHorarioViewController
        
        viewAgregar.delegado = self
    }

}
