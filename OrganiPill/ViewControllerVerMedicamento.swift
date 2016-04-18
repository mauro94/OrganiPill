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

	
	
    @IBOutlet weak var scScrollView: UIScrollView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		self.title = "Title"
		
		//var barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: NSSelectorFromString("editar"))
		//self.navigationItem.rightBarButtonItem = barButton
		
		var viewSize = self.view.frame.size
		viewSize.height = 850
        scScrollView.scrollEnabled = true;
        scScrollView.contentSize = viewSize
        
		
		
		
		
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
