//
//  AppDelegate.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/5/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		storyboard()
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	//MARK - Modificar storyboard inicial
	func storyboard() {
		let storyboard: UIStoryboard = self.grabStoryboard()
		self.setInitialScreen(storyboard)
	}
	
	//funcion que decide que storyboard es el inicial
	func grabStoryboard() -> UIStoryboard {
		var storyboard: UIStoryboard
		
		let realm = try! Realm()
		let paciente = realm.objects(Paciente)

		//si no existe una  instancia de persona pedir datos
		if (paciente.count == 0) {
			storyboard = UIStoryboard(name: "setupInicial", bundle: nil)
		}
		
		else {
			storyboard = UIStoryboard(name: "Main", bundle: nil)
		}
		
		return storyboard
	}
	
	//Decide la pantalla principal de la app
	func setInitialScreen(storyboard: UIStoryboard) {
		var initViewController: UIViewController
		
		initViewController = storyboard.instantiateViewControllerWithIdentifier("Primero")
		
		self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
		self.window?.rootViewController = initViewController
		self.window?.makeKeyAndVisible()
	}
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        guard let userInfo = notification.userInfo
            else {
                return
        }
        
        let nombreMed = userInfo["nombre"] as! String
        let fechaAlerta = userInfo["fechaAlerta"] as! NSDate
        let fechaOriginal = userInfo["fechaOriginal"] as! NSDate
        
        //let nombreMed = userInfo["nombre"] as! String
        //let fecha = userInfo["fecha"] as! NSDate
        
        //si la aplicacion recibe notificacion mientras se usa, presentar alerta
        if application.applicationState == .Active {
            /**let alerta = UIAlertController(title: "Alerta!", message: "Hora de tomar \(nombreMed))", preferredStyle: UIAlertControllerStyle.Alert)
            
            alerta.addAction(UIAlertAction(title: "Recordar más tarde", style: UIAlertActionStyle.Destructive, handler: nil))
            
            //presionar esto lo lleva a la vista para registrar una medicina como tomada
            alerta.addAction(UIAlertAction(title: "Tomar medicina", style: UIAlertActionStyle.Default, handler: {action in self.tomarMedicinaController(nombreMed, fecha: fecha, notification: notification)}))
            
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alerta, animated: true, completion: nil)**/
        }
        //si abre la notificacion desde fuera, llevarlo directamente a la aplicacion
        else{
            tomarMedicinaController(nombreMed, fechaAlerta: fechaAlerta, fechaOriginal: fechaOriginal, notification: notification)
        }
    }
    
    func tomarMedicinaController(nombreMed : String, fechaAlerta : NSDate, fechaOriginal : NSDate, notification : UILocalNotification){
        let storyboard = UIStoryboard(name: "sbNotificacion", bundle: nil)
        
        let notifViewController = storyboard.instantiateViewControllerWithIdentifier("notificacion") as! NotificacionViewController
        
        notifViewController.sNombre = nombreMed
        notifViewController.fechaAlerta = fechaAlerta
        notifViewController.fechaOriginal = fechaOriginal
        notifViewController.notificacion = notification
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = notifViewController
        self.window?.makeKeyAndVisible()
    }

}

