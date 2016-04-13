//
//  ViewControllerMenu.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/6/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class ViewControllerMenu: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		
		navigationController!.navigationBar.barTintColor = UIColor(red: 255.0/255.0, green: 50.0/255.0, blue: 57.0/255.0, alpha: 1.0)
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
	
	override func viewWillDisappear(animated: Bool) {
		self.navigationController?.navigationBarHidden = false
	}
	
	override func viewWillAppear(animated: Bool) {
		self.navigationController?.navigationBarHidden = true
	}

	
	

}
