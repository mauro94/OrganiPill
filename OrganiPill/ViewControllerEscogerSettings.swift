//
//  ViewControllerEscogerSettings.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 5/4/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class ViewControllerEscogerSettings: UIViewController {

    @IBOutlet weak var containerContacto: UIView!
    @IBOutlet weak var containerDoctor: UIView!
    @IBOutlet weak var sgmPick: UISegmentedControl!
    @IBOutlet weak var containerPaciente: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func OpcionSgm(sender: AnyObject) {
        
        
        switch sgmPick.selectedSegmentIndex
        {
        case 0:
            containerPaciente.hidden = false
            containerDoctor.hidden = true
            containerContacto.hidden = true
            
            
        case 1:
            containerPaciente.hidden = true
            containerDoctor.hidden = false
            containerContacto.hidden = true
           
            
        case 2:
            containerPaciente.hidden = true
            containerDoctor.hidden = true
            containerContacto.hidden = false
            
        default:
            break;
        }
        
        
        
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: IStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
