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
    var activeViewCont : UIViewController!


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		//storyboard()
        
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
		//var storyboard: UIStoryboard = self.grabStoryboard()
		//self.setInitialScreen(storyboard)
        
        /**let realm = try! Realm()
        let paciente = realm.objects(Paciente)
        
        //si no existe una instancia de persona hacer setup
        if (paciente.count == 0) {
            let storyboard = UIStoryboard(name: "setupInicial", bundle: nil)
            let setupVC = storyboard.instantiateViewControllerWithIdentifier("Primero")
            self.window?.rootViewController?.presentViewController(setupVC, animated: true, completion: nil)
        }**/

	}
	
	//funcion que decide que storyboard es el inicial
	func grabStoryboard() -> UIStoryboard {
		var storyboard: UIStoryboard
        storyboard = UIStoryboard(name: "Main", bundle: nil)
		
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
        
        //si la aplicacion recibe notificacion mientras se usa, presentar alerta
        //self.storyboard()

        if application.applicationState == .Active {
            //let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //var initViewController = storyboard.instantiateViewControllerWithIdentifier("Primero")
            //self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            //self.window?.rootViewController = initViewController
            //self.window?.makeKeyWindow()
            
            let alert = UIAlertController(title: "¡Alerta!", message: "Hora de tomar \(nombreMed)", preferredStyle: .Alert)
            // Handler for each of the actions
            
            let dismissAndAction = {
                () -> ((UIAlertAction!) -> ()) in
                return {
                    _ in
                    self.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
                    self.tomarMedicinaController(nombreMed, fechaAlerta: fechaAlerta, fechaOriginal: fechaOriginal, notification: notification)
                }
            }
            
            let dismissAndSnooze = {
                () -> ((UIAlertAction!) -> ()) in
                return {
                    _ in
                    self.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
                    let storyboard = UIStoryboard(name: "sbNotificacion", bundle: nil)
                    let notifViewController = storyboard.instantiateViewControllerWithIdentifier("notificacion") as! NotificacionViewController
                    
                    
                    notifViewController.sNombre = nombreMed
                    notifViewController.fechaAlerta = fechaAlerta
                    notifViewController.fechaOriginal = fechaOriginal
                    notifViewController.notificacion = notification
                    //TODO-Snooze
                    notifViewController.snoozeNotif(5)
                }
            }
            
            alert.addAction(UIAlertAction(title: "Ver medicina", style: .Default, handler: dismissAndAction()))
            alert.addAction(UIAlertAction(title: "Posponer 5 minutos", style: .Destructive, handler: dismissAndSnooze()))
            
            let navigationController = application.windows[0].rootViewController as! UINavigationController
            //let activeViewCont = navigationController.visibleViewController
            print(navigationController.viewControllers)
            if(!navigationController.visibleViewController!.isKindOfClass(NotificacionViewController) && !navigationController.visibleViewController!.isKindOfClass(UIAlertController)){
                activeViewCont = navigationController.visibleViewController
            }
            else{
                //let activeViewCont = self.window?.rootViewController
            }
            print(activeViewCont)
            
            //self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            //self.window?.rootViewController = activeViewCont
            //self.window?.makeKeyAndVisible()
            //self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            activeViewCont!.presentViewController(alert, animated: true, completion: nil)
        }
        //si abre la notificacion desde fuera, llevarlo directamente a la aplicacion
        else{
            tomarMedicinaController(nombreMed, fechaAlerta: fechaAlerta, fechaOriginal: fechaOriginal, notification: notification)
        }
    }
    
    func tomarMedicinaController(nombreMed : String, fechaAlerta : NSDate, fechaOriginal : NSDate, notification : UILocalNotification){
        let storyboard = UIStoryboard(name: "sbNotificacion", bundle: nil)
        let notifViewController = storyboard.instantiateViewControllerWithIdentifier("notificacion")
        
        
        (notifViewController as! NotificacionViewController).sNombre = nombreMed
        (notifViewController as! NotificacionViewController).fechaAlerta = fechaAlerta
        (notifViewController as! NotificacionViewController).fechaOriginal = fechaOriginal
        (notifViewController as! NotificacionViewController).notificacion = notification
        
        //self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        //self.window?.rootViewController = notifViewController
        //self.window?.makeKeyAndVisible()
        
        self.window?.rootViewController?.presentViewController(notifViewController, animated: true, completion: nil)

    }

}

