//
//  ViewControllerVerMedicamento.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/6/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class ViewControllerVerMedicamento: UIViewController {
	//variables
    @IBOutlet weak var lblNombre: UILabel!

    @IBOutlet weak var lblDuracion: UILabel!
	
    @IBOutlet weak var lblHorario: UILabel!
    @IBOutlet weak var lblDosis: UILabel!
	
    @IBOutlet weak var lblVia: UILabel!
    @IBOutlet weak var scScrollView: UIScrollView!
	
    var nombres:String!
    
    var Dosis:String!
    
    var Duracion:String!
    
    var viaAdmi:String!
    
    var Horario:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lblNombre.text = nombres
        lblDosis.text = Dosis
        lblVia.text = viaAdmi
        lblDuracion.text = Duracion
        lblHorario.text = Horario
        
        
		
        // Do any additional setup after loading the view.
		self.title = "Medicina"
		
	
		
       
        //var editButton : UIBarButtonItem = UIBarButtonItem(title: "RigthButtonTitle", style: UIBarButtonItemStyle.Plain, target: self, action: Selector(""))
        
        //self.navigationItem.rightBarButtonItem = editButton
        
        
        
		var viewSize = self.view.frame.size
		viewSize.height = 700
        viewSize.width = 100
        scScrollView.scrollEnabled = true;
        scScrollView.contentSize = viewSize
        scScrollView.showsVerticalScrollIndicator = false
		
        
        
        
        
		
		
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	
	
	
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
