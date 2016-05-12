//
//  ViewControllerEscogerSettings.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 5/4/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class ViewControllerEscogerSettings: UIViewController {

	@IBOutlet weak var viewCreditos: UIView!
    @IBOutlet weak var containerContacto: UIView!
    @IBOutlet weak var containerDoctor: UIView!
    @IBOutlet weak var sgmPick: UISegmentedControl!
    @IBOutlet weak var containerPaciente: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ajustes"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OpcionSgm(sender: AnyObject) {
        
        
        switch sgmPick.selectedSegmentIndex
        {
            //esconde los containers que no se utilizaran
        case 0:
            view.endEditing(true)
            containerPaciente.hidden = false
            containerDoctor.hidden = true
            containerContacto.hidden = true
			viewCreditos.hidden = true
            navigationItem.rightBarButtonItem = nil
            break
            
        case 1:
            view.endEditing(true)
            containerPaciente.hidden = true
            containerDoctor.hidden = false
            containerContacto.hidden = true
			viewCreditos.hidden = true
            navigationItem.rightBarButtonItem = nil
           break
            
        case 2:
            view.endEditing(true)
            containerPaciente.hidden = true
            containerDoctor.hidden = true
            containerContacto.hidden = false
			viewCreditos.hidden = true
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ViewControllerEscogerSettings.nuevoDato(_:)))
            break
		case 3:
            view.endEditing(true)
			containerPaciente.hidden = true
			containerDoctor.hidden = true
			containerContacto.hidden = true
			viewCreditos.hidden = false
			
			navigationItem.rightBarButtonItem = nil
			break
        default:
            break;
        }
		
        
        
        
        
    }
    
    func nuevoDato(sender: AnyObject) {
        self.performSegueWithIdentifier("addContact", sender: sender)
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
       
        
        
        
        
        
        
        
    }
    

}
