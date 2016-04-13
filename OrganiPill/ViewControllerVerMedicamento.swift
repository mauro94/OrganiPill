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
	@IBOutlet weak var scScroller: UIScrollView!
	@IBOutlet weak var pgPageController: UIPageControl!
	@IBOutlet weak var imgImagen: UIImageView!
	
	var sTitle: String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		self.title = sTitle
		
		var barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: NSSelectorFromString("editar"))
		self.navigationItem.rightBarButtonItem = barButton
		
		var viewSize = self.view.frame.size
		viewSize.height = 850
		
		scScroller.scrollEnabled = true
		scScroller.contentSize = viewSize
		
		pgPageController.numberOfPages = 3
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func swipeImagen(sender: UISwipeGestureRecognizer) {
		if (sender.direction == UISwipeGestureRecognizerDirection.Right) {
			imgImagen.image = UIImage(named: "Image-1")
			print("jala")
		}
	}
	
	@IBAction func editar(sender: UIButton) {
		
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
