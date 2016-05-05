//
//  notificaciones.swift
//  OrganiPill
//
//  Created by David Benitez on 5/1/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class HandlerNotificaciones{
    let calendar = NSCalendar.currentCalendar()
    var medMedicina = Medicamento()
    var listaNSDates = NSMutableArray()
    var listaNotif = Notificaciones()
    
    init(medMedicamento : Medicamento){
        medMedicina = medMedicamento
    }
    
    init(){
        
    }
    
    //controlador para generar notificaciones
    func generarNotificaciones(){
        let fechaActual = NSDate()
        let units: NSCalendarUnit = [.Hour, .Minute, .Weekday]
        let myComponents = calendar.components(units, fromDate: fechaActual)
        let unidadRestantes = medMedicina.iDuracion
        
        
        //recorre horarios
        for i in 0...medMedicina.horario.count - 1{
            
            let j = getFirstDay(i, myComponents: myComponents)
            
            myComponents.hour = medMedicina.horario[i].horas
            myComponents.minute = medMedicina.horario[i].minutos
            
            //duracion es en dias
            if(medMedicina.sTipoDuracion == "d"){
                generarListaNotifDias(i, firstDay: j, myComponents: myComponents, unidadRestantes: unidadRestantes, fecha: fechaActual)
            }
                //duracion es en semanas
            else if(medMedicina.sTipoDuracion == "s"){
                generarListaNotifSemanas(i, firstDay: j, myComponents: myComponents, unidadRestantes: unidadRestantes, fecha: fechaActual)
            }
                //duracion es en meses
            else if(medMedicina.sTipoDuracion == "m"){
                //1 mes = 4 semanas
                generarListaNotifSemanas(i, firstDay: j, myComponents: myComponents, unidadRestantes: unidadRestantes*4, fecha: fechaActual)
            }
        }
        
        //ordena las fechas
        sortNSDatesAsc(listaNSDates)
        
        //genera las listas finales (recorta las fechas excedidas)
        if(medMedicina.sTipoDuracion == "d"){
            finalizarListaNotif_D()
        }
        else if(medMedicina.sTipoDuracion == "s"){
            finalizarListaNotif_S(medMedicina.iDuracion)
        }
        else if(medMedicina.sTipoDuracion == "m"){
            //1 mes = 4 semanas
            finalizarListaNotif_S(medMedicina.iDuracion*4)
        }
        
        guardarNotificaciones()
    }
    
    //genera una lista de NSDates para cuando la unidad de duracion son dias
    func generarListaNotifDias(i : Int, firstDay : Int, myComponents : NSDateComponents, unidadRestantes : Int, fecha : NSDate){
        
        var diasRestantes = unidadRestantes
        var j = firstDay
        var aux = fecha
        let cantDias = medMedicina.horario[i].listaDias.count
        
        while(diasRestantes > 0){
            
            //se actualiza el dia del componente a buscar
            myComponents.weekday = medMedicina.horario[i].listaDias[j].dia
            
            //busca la siguiente fecha con el dia y hora
            aux = calendar.nextDateAfterDate(aux, matchingComponents: myComponents, options: .MatchStrictly)!
            
            j = (j+1)%cantDias
            diasRestantes -= 1
            
            listaNSDates.addObject(aux)
        }
    }
    
    //genera una lista de NSDates para cuando la unidad de duracion son semanas/meses
    func generarListaNotifSemanas(i : Int, firstDay : Int, myComponents : NSDateComponents, unidadRestantes : Int, fecha : NSDate){
        
        var semanasRestantes = unidadRestantes
        var j = firstDay
        var aux = fecha
        let cantDias = medMedicina.horario[i].listaDias.count
        
        //hace la lista de NSDATES para tomar medicina
        repeat{
            //recorre cantidad de dias de la semana
            for _ in 1...cantDias{
                //busca la siguiente fecha con el dia y hora
                myComponents.weekday = medMedicina.horario[i].listaDias[j].dia
                
                aux = calendar.nextDateAfterDate(aux, matchingComponents: myComponents, options: .MatchStrictly)!
                
                listaNSDates.addObject(aux)
                
                j = (j+1)%cantDias
            }
            
            semanasRestantes -= 1
        }while(semanasRestantes > 0)
    }
    
    //regresa el indice del primer día que se puede tomar la medicina con el horario en indice i a partir de la fecha actual
    func getFirstDay(i : Int, myComponents : NSDateComponents) -> Int{
        var firstDayIndex : Int = 0
        let weekDay = myComponents.weekday
        let cantDias = medMedicina.horario[i].listaDias.count
        
        //busca el dia siguiente en la lista mas cercano a hoy
        for k in 0...cantDias-1{
            if(medMedicina.horario[i].listaDias[k].dia >= weekDay){
                firstDayIndex = k
                break
            }
        }
        
        //si es el mismo dia, checar hora
        if(medMedicina.horario[i].listaDias[firstDayIndex].dia == weekDay){
            let currentHour = getHourAsString(myComponents)
            
            myComponents.hour = medMedicina.horario[i].horas
            myComponents.minute = medMedicina.horario[i].minutos
            let medHour = getHourAsString(myComponents)
            
            if(medHour < currentHour){
                //no se puede tomar hoy, empezar el siguiente dia
                firstDayIndex += 1
                firstDayIndex = firstDayIndex%cantDias
            }
        }
        
        return firstDayIndex
    }
    
    //genera una lista con notificaciones para iDuracion semanas o iDuracion meses (iDuracion*4)
    func finalizarListaNotif_S(semanas : Int){
        var i : Int = 0
        var semanaCount : Int = 0
        
        //componentes de la primera fecha donde se toma la medicina
        let primerWDiaMedicina = calendar.components(.Weekday, fromDate: listaNSDates[i] as! NSDate)
        let primerHoraMedicina = calendar.components(.Hour, fromDate: listaNSDates[i] as! NSDate)
        let primerMinutoMedicina = calendar.components(.Minute, fromDate: listaNSDates[i] as! NSDate)
        
        let fechaAux = Fecha()
        fechaAux.fechaOriginal = listaNSDates[i] as! NSDate
        
        fechaAux.nombreMed = medMedicina.sNombre
        registrarFecha(fechaAux)
        
        i += 1
        
        //registra notificaciones para la cantidad de semanas
        while(semanaCount < semanas && i < listaNSDates.count){
            let fechaAux = Fecha()
            fechaAux.fechaOriginal = listaNSDates[i] as! NSDate
            
            fechaAux.nombreMed = medMedicina.sNombre
            registrarFecha(fechaAux)
            
            //compara la primera fecha donde se toma la medicina con la actual de la lista para saber si ya pasó una semana
            if(primerWDiaMedicina == calendar.components(.Weekday, fromDate: fechaAux.fechaOriginal) && primerHoraMedicina == calendar.components(.Hour, fromDate: fechaAux.fechaOriginal) && primerMinutoMedicina == calendar.components(.Minute, fromDate: fechaAux.fechaOriginal)){
                
                semanaCount += 1
            }
            
            i += 1
            
        }
    }
    
    //TODO arreglar porque los primeros tienen el mismo dia
    //genera una lista con notificaciones para iDuracion dias
    func finalizarListaNotif_D(){
        var i : Int = 0
        var diasCount : Int = 0
        
        //checa el numero del dia de la primera vez a tomar la medicina
        var diaAux = calendar.components(.Day, fromDate: listaNSDates[i] as! NSDate)
        
        //registra notificaciones para la cantidad de dias
        repeat{
            let fechaAux = Fecha()
            fechaAux.fechaOriginal = listaNSDates[i] as! NSDate

            //compara el numero de dia entre las fechas de la lista
            if(diaAux != calendar.components(.Day, fromDate: fechaAux.fechaOriginal)){
                diasCount += 1
                diaAux = calendar.components(.Day, fromDate: fechaAux.fechaOriginal)
            }
            
            fechaAux.nombreMed = medMedicina.sNombre
            registrarFecha(fechaAux)
            
            i += 1
            
        }while(i < listaNSDates.count && diasCount < medMedicina.iDuracion)
    }
    
    //agrega un NSDate y el nombre de la medicina a la lista de notificaciones
    func registrarFecha(fecha : Fecha){
        fecha.fechaAlerta = fecha.fechaOriginal
        listaNotif.listaNotificaciones.append(fecha)
    }
    
    //extrae y actualiza la lista de notificaciones de la base de datos
    func guardarNotificaciones(){
        let realm = try! Realm()
        var listaActual = Notificaciones()
        listaNotif.id = 1
        
        //leer lista actual guardada
        let notif = realm.objects(Notificaciones).filter("id == 1")
        //print(notif)

        //escribe nueva lista
        if(notif.count == 0){
            //creo la lista de (fechas de) medicinas tomadas
            let listaTomadas = Notificaciones()
            listaTomadas.id = 2
            
            //creo la lista de (fechas de) medicinas que no se tomaron
            let listaPasadas = Notificaciones()
            listaPasadas.id = 3
            
            try! realm.write{
                realm.add(listaNotif)
                realm.add(listaTomadas)
                realm.add(listaPasadas)
            }
            
        }
        //se debe de actualizar la lista
        else{
            listaActual = notif.first!
            
            try! realm.write{
                //se actualiza la lista
                print(listaNotif.listaNotificaciones.count)
                for i in 0...listaNotif.listaNotificaciones.count-1{
                    listaActual.listaNotificaciones.append(listaNotif.listaNotificaciones[i])
                }
                
                //se ordena la lista actualizada
                listaNotif.listaNotificaciones = sortNotifDates(listaActual.listaNotificaciones)
                
                //sobreescribe nueva ordenada a realm
                realm.add(listaNotif, update: true)
            
            }
        }

        //registrar primeros 64 notif
        
        var i : Int = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        //ALERT: .count-1
        while(i < 64 && i < listaNotif.listaNotificaciones.count){
            scheduleLocal(listaNotif.listaNotificaciones[i])
            i += 1
        }
    }
    
    func rescheduleNotificaciones(){
        let realm = try! Realm()

        try! realm.write{
            let listaPendientes = realm.objects(Notificaciones).filter("id == 1").first!
            //var listaOrdenada = sortNotifDates(listaPendientes.listaNotificaciones)
            var listaOrdenada = List<Fecha>()
            
            if(listaPendientes.listaNotificaciones.count != 0){
                listaOrdenada = sortNotifDates(listaPendientes.listaNotificaciones)
            }
        
            realm.delete(listaPendientes)
            
            var notifNuevo = Notificaciones()
            notifNuevo.id = 1
            notifNuevo.listaNotificaciones = listaOrdenada

            realm.add(notifNuevo, update: true)

        }
        
        let listaPendientes = realm.objects(Notificaciones).filter("id == 1").first!
        
        var i : Int = 0
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        //ALERT: .count-1
        while(i < 64 && i < listaPendientes.listaNotificaciones.count){
            scheduleLocal(listaPendientes.listaNotificaciones[i])
            i += 1
        }

    }
    
    func scheduleLocal(obj : Fecha) {
        let notification = UILocalNotification()
        
        notification.fireDate = obj.fechaAlerta
        notification.alertBody = "Hora de tomar \(obj.nombreMed)"
        notification.alertAction = "Abrir aplicación"
        notification.soundName = UILocalNotificationDefaultSoundName
        //notification.userInfo = ["fecha": obj.fechaAlerta, "nombre": obj.nombreMed]
        notification.userInfo = ["fechaAlerta": obj.fechaAlerta, "fechaOriginal": obj.fechaOriginal, "nombre": obj.nombreMed]
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    //ordena un arreglo de NSDates de forma ascendente
    func sortNSDatesAsc(lista : NSMutableArray){
        //ordena los horarios por fecha
        lista.sortUsingComparator(){(firstDate : AnyObject!, secondDate : AnyObject!) -> NSComparisonResult in
            if ((firstDate as! NSDate).earlierDate(secondDate as! NSDate) == firstDate as! NSDate){
                return NSComparisonResult.OrderedAscending
            }
            else if ((firstDate as! NSDate).earlierDate(secondDate as! NSDate) == secondDate as! NSDate){
                return NSComparisonResult.OrderedDescending
            }
            else{
                return NSComparisonResult.OrderedSame
            }
        }
    }

    //ordena una lista de Fecha (NSDate) y su Medicina correspondiente
    func sortNotifDates(lista : List<Fecha>) -> List<Fecha>{
        //ordena la List<> y regresa un Result<>
        let listaOrdenada = lista.sorted("fechaAlerta")
        let listaNueva = List<Fecha>()
        
        //copia Result<> ordenado a arreglo
        for i in 0...listaOrdenada.count-1{
            listaNueva.append(listaOrdenada[i])
        }
        
        return listaNueva
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
    
    /**func setupNotificationSettings(){
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)

        if(notificationSettings.types == UIUserNotificationType.None){

        var notificationTypes = UIUserNotificationType()

        var tomarNotif = UIMutableUserNotificationAction()
        tomarNotif.identifier = "tomarMed"
        tomarNotif.title = "Tomar medicina"
        tomarNotif.activationMode = UIUserNotificationActivationMode.Foreground
        tomarNotif.destructive = false
        tomarNotif.authenticationRequired = false
        
        var snoozeNotif = UIMutableUserNotificationAction()
        snoozeNotif.identifier = "snoozeMed"
        snoozeNotif.title = "Aplazar"
        snoozeNotif.activationMode = UIUserNotificationActivationMode.Background
        snoozeNotif.destructive = false
        snoozeNotif.authenticationRequired = true
        
        let actionsArray = NSArray(objects: tomarNotif, snoozeNotif)
        
        var medicinaCategory = UIMutableUserNotificationCategory()
        medicinaCategory.identifier = "medicinaCategory"
        medicinaCategory.setActions(actionsArray as! [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
        
        let categoriesForSettings = NSSet(objects: medicinaCategory)
        
        let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings as! Set<UIUserNotificationCategory>)
            
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)

        }
        
        
    }**/
}
