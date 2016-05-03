//
//  NotificacionViewController.swift
//  OrganiPill
//
//  Created by David Benitez on 5/1/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class NotificacionViewController: UIViewController {

    var sNombre : String!
    var fechaAlerta : NSDate!
    var fechaOriginal : NSDate!
    var notificacion : UILocalNotification!
    
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblTipo: UILabel!
    @IBOutlet weak var lblHora: UILabel!
    @IBOutlet weak var lblComida: UILabel!
    @IBOutlet weak var lblDosis: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDatos()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDatos(){

        let realm = try! Realm()
        let resMedicina = realm.objects(Medicamento).filter("sNombre == %@", sNombre)
        let medicina = resMedicina.first
        
        let formatoHora = NSDateFormatter()
        formatoHora.dateFormat = "EEEE, dd 'de' MMMM h:mm a"

        lblNombre.text = sNombre
        lblTipo.text = medicina?.sViaAdministracion
        lblHora.text = formatoHora.stringFromDate(fechaAlerta)
        
        if(medicina!.bNecesitaAlimento){
            lblComida.text = "Necesita alimento"
        }
        else{
            lblComida.text = "No necesita alimento"
        }
        
        lblDosis.text = String(medicina!.dDosis)
        
    }
// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "tomarMedicina"){
            var fechaAux = Fecha()
            
            //se cancela la notificacion que mandó a esta vista
            UIApplication.sharedApplication().cancelLocalNotification(notificacion)
            
            //saca las listas de notificaciones
            let realm = try! Realm()
            let listasNotif = realm.objects(Notificaciones)
            
            try! realm.write{
                var listaPendientes = listasNotif.filter("id == 1").first!
                var listaTomadas = listasNotif.filter("id == 2").first!
                
                //borrar notificacion actual de la lista de notificaciones
                for i in 0...listaPendientes.listaNotificaciones.count-1{
                    //found a match
                    if(listaPendientes.listaNotificaciones[i].fechaAlerta == fechaAlerta && listaPendientes.listaNotificaciones[i].nombreMed == sNombre){
                        //guarda la fecha para usarla en la lista de tomadas
                        fechaAux = listaPendientes.listaNotificaciones[i]
                        
                        //la borra de las pendientes
                        listaPendientes.listaNotificaciones.removeAtIndex(i)
                        break
                    }
                }

                //guardar en lista tomadas
                fechaAux.fechaAlerta = NSDate()
                listaTomadas.listaNotificaciones.append(fechaAux)
                
                //actualiza ambas listas
                realm.add(listaPendientes, update: true)
                realm.add(listaTomadas, update: true)
                
                //notif.rescheduleNotificaciones()
            }
            //hace un reschedule de las notificaciones
            let notif : HandlerNotificaciones = HandlerNotificaciones()
            notif.rescheduleNotificaciones()
        }
        else if(segue.identifier == "snoozeMedicina"){
            var fechaAux = Fecha()
            
            //se cancela la notificacion que mandó a esta vista
            UIApplication.sharedApplication().cancelLocalNotification(notificacion)
            
            //saca las listas de notificaciones
            let realm = try! Realm()
            let listasNotif = realm.objects(Notificaciones)
            
            try! realm.write{
                let listaPendientes = listasNotif.filter("id == 1").first!
                
                //borrar notificacion actual de la lista de notificaciones
                for i in 0...listaPendientes.listaNotificaciones.count-1{
                    //found a match
                    if(listaPendientes.listaNotificaciones[i].fechaAlerta == fechaAlerta && listaPendientes.listaNotificaciones[i].nombreMed == sNombre){
                        //guarda la fecha para usarla despues
                        fechaAux = listaPendientes.listaNotificaciones[i]
                        
                        //la borra de las pendientes
                        listaPendientes.listaNotificaciones.removeAtIndex(i)
                        break
                    }
                }
                
                //genera la nueva fecha y la agrega a la lista
                //let nuevaFecha = NSDate(timeInterval: 1*60, sinceDate: fechaAux.fechaAlerta)
                let nuevaFecha = NSDate(timeIntervalSinceNow: 1*60)
                fechaAux.fechaAlerta = nuevaFecha
                listaPendientes.listaNotificaciones.append(fechaAux)
                
                //actualiza la lista de notificaciones en REALM
                realm.add(listaPendientes, update: true)
                
            }
            //hace un reschedule de las notificaciones
            let notif : HandlerNotificaciones = HandlerNotificaciones()
            
            notif.rescheduleNotificaciones()
        }
    }

}
