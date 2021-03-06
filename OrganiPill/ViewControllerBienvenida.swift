//
//  ViewControllerBienvenida.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/19/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class ViewControllerBienvenida: UIViewController {
	//outlets
	@IBOutlet weak var viewBorrar: UIView!
	@IBOutlet weak var constraintViewBorrartop: NSLayoutConstraint!
	@IBOutlet weak var btBoton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		makeAnimation()
		agregaBorderButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//animacion inicial
	func makeAnimation() {
		let altura = self.view.bounds.height
		UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
			self.constraintViewBorrartop.constant = altura
			self.viewBorrar.layoutIfNeeded()
			}, completion: nil)
		
	}
	
	//barra color blanco
	override func preferredStatusBarStyle() -> UIStatusBarStyle {
		return .LightContent
	}
	
	//funcion que agregar bordes a los botones
	func agregaBorderButton() {
		btBoton.layer.borderWidth = 0.5
		btBoton.layer.borderColor = UIColor.whiteColor().CGColor
	}
}
