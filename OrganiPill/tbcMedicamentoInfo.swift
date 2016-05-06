//
//  tbcMedicamentoInfo.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/14/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class tbcMedicamentoInfo: UITableViewCell {
	//OUTLETS
	@IBOutlet weak var lbHora: UILabel!
	@IBOutlet weak var lbNombreMedicamento: UILabel!
	@IBOutlet weak var imgIcono: UIImageView!
	
	//VARIABLES
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
	
	
	
	
	
	//agregar dibujo
	override func drawRect(rect: CGRect) {
		//Definir contexto
		let contexto = UIGraphicsGetCurrentContext()
		//Definif colores
		let color = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 1).CGColor
		let colorDark = UIColor(red: 188.0/255.0, green: 53.0/255.0, blue: 73.0/255.0, alpha: 1).CGColor
		//definir 'width' de la linea
		CGContextSetLineWidth(contexto, 2.0)
		
		//si ya pasaron mas de 4 horas de un medicamento usar color oscuro
		if (bPasoHora) {
			CGContextSetStrokeColorWithColor(contexto, colorDark)
			CGContextSetFillColorWithColor(contexto, colorDark)
		}
		//si no han pasado 4 horas de un medicamento usar color normal
		else {
			CGContextSetStrokeColorWithColor(contexto, color)
			CGContextSetFillColorWithColor(contexto, color)
		}
		
		//si es la primer celda de la lista
		if (bPrimerCelda) {
			CGContextMoveToPoint(contexto, 20, 14)
			CGContextAddLineToPoint(contexto, 20, self.frame.height)
		}
		//si es la ultima celda de la lista
		else if (bUltimaCelda) {
			CGContextMoveToPoint(contexto, 20, 0)
			CGContextAddLineToPoint(contexto, 20, 14)
		}
		//si es la unica celda en la lista
		else if (bUnicaCelda) {
			//no hace nada, no hay linea
		}
		//si es una celda intermedia
		else {
			CGContextMoveToPoint(contexto, 20, 0)
			CGContextAddLineToPoint(contexto, 20, self.frame.height)
			
		}
		//dibujar
		CGContextStrokePath(contexto)
		
		//hacer circulo
		let theRect: CGRect = CGRectMake(15, 14, 10, 10)
		//dibujar circulo
		CGContextFillEllipseInRect(contexto, theRect)
		CGContextStrokeEllipseInRect(contexto, theRect)
	}

}