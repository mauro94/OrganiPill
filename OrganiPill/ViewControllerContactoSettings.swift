//
//  ViewControllerSetupInicial3.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/24/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerContactoSettings: UIViewController, UITableViewDelegate, UITableViewDataSource, ProtocoloGuardarContacto {
    //outlets
    @IBOutlet weak var btnhide: UIButton!
    @IBOutlet weak var tbvTabla: UITableView!
    @IBOutlet weak var vwNoContactos: UIView!
    
    //variables
    var paciente: Persona!
    var doctor: Persona!
    let realm = try! Realm()
   
    var filaSeleccionada: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnhide.hidden = true
        
        // Do any additional setup after loading the view.
        tbvTabla.delegate = self
        tbvTabla.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        tbvTabla.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        let contactosRealm = realm.objects(Persona)
        
        
        if (contactosRealm.count > 2) {
            tbvTabla.hidden = false
            vwNoContactos.hidden = true
        }
        else {
            tbvTabla.hidden = true
            vwNoContactos.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        self.title = "Contactos"
    }
    
    // MARK: - UITableView
    
    // numero de filas de la table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contactosRealm = realm.objects(Persona)
        return (contactosRealm.count - 2)
    }
    
    
    
    // crea la celda de la tabla
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let contactosRealm = realm.objects(Persona)
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = contactosRealm[indexPath.row + 2].sNombre
        
        return cell
    }
    
    //MARK: Meotodos de protocolo contatco
    func guardaContacto(contacto: Persona) {
        let contactosRealm = realm.objects(Persona)
       // contactosRealm.append(contacto)
        tbvTabla.reloadData()
    }
    
    func editarContacto(contacto: Persona) {
        let contactosRealm = realm.objects(Persona)
       // contactosRealm[filaSeleccionada] = contacto
        tbvTabla.reloadData()
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let contactosRealm = realm.objects(Persona)
        if segue.identifier == "segueContact" {
            let view = segue.destinationViewController as! ViewControllerAgregarContactoSettings
            
        }
        else if segue.identifier == "editContact" {
            let indexPath = tbvTabla.indexPathForSelectedRow
            let view = segue.destinationViewController as! ViewControllerAgregarContactoSettings
            filaSeleccionada = (indexPath!.row + 2)
            
            
            view.sNombre = contactosRealm[indexPath!.row + 2].sNombre
            view.sTelefono = contactosRealm[indexPath!.row + 2].sTelefono
            view.sTelefono2 = contactosRealm[indexPath!.row + 2].sTelefonoSecundario
            view.sCorreoElectronico = contactosRealm[indexPath!.row + 2].sCorreoElectronico
            
            view.auxPersonaEdit = contactosRealm[indexPath!.row + 2]
            
            view.isEdit = true
            
        }
         
    }
    
    @IBAction func unwindContacto(sender: UIStoryboardSegue) {
        //en balnco... no se requiere hacer nada al regresar
    }
    
    
}
