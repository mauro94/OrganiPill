//
//  tbcMedicamentoInfo.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/14/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class tbcMedicamentoInfo: UITableViewCell {
	//outlets
	@IBOutlet weak var lbHora: UILabel!
	@IBOutlet weak var lbNombreMedicamento: UILabel!
	@IBOutlet weak var imgIcono: UIImageView!
	
	var bPrimerCelda: Bool = false
	var bUltimaCelda: Bool = false
	var bUnicaCelda: Bool = false
	var bPasoHora: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	override func drawRect(rect: CGRect) {
		let contexto = UIGraphicsGetCurrentContext()
		let color = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 1).CGColor
		let colorDark = UIColor(red: 188.0/255.0, green: 53.0/255.0, blue: 73.0/255.0, alpha: 1).CGColor
		
		CGContextSetLineWidth(contexto, 2.0)
		if (bPasoHora) {
			CGContextSetStrokeColorWithColor(contexto, colorDark)
			CGContextSetFillColorWithColor(contexto, colorDark)
		}
		else {
			CGContextSetStrokeColorWithColor(contexto, color)
			CGContextSetFillColorWithColor(contexto, color)
		}
		
		if (bPrimerCelda) {
			CGContextMoveToPoint(contexto, 20, 14)
			CGContextAddLineToPoint(contexto, 20, self.frame.height)
		}
			
		else if (bUltimaCelda) {
			CGContextMoveToPoint(contexto, 20, 0)
			CGContextAddLineToPoint(contexto, 20, 14)
		}
			
		else if (bUnicaCelda) {
			//no hace nada, no hay linea
		}
		
		//no es primer celda
		else {
			CGContextMoveToPoint(contexto, 20, 0)
			CGContextAddLineToPoint(contexto, 20, self.frame.height)
			
		}
		CGContextStrokePath(contexto)
		
		let theRect: CGRect = CGRectMake(15, 14, 10, 10)
		
		CGContextFillEllipseInRect(contexto, theRect)
		CGContextStrokeEllipseInRect(contexto, theRect)
	}

}