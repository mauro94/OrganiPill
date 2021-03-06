//
//  ViewControllerVerMedicamento.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/6/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI


class ViewControllerVerMedicamento: UIViewController, MFMailComposeViewControllerDelegate {
    //OUTLETS
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblTipoduracion: UILabel!
    @IBOutlet weak var lblDuracion: UILabel!
    @IBOutlet weak var txvComentario: UITextView!
    @IBOutlet weak var lblDosis: UILabel!
    @IBOutlet weak var lblVia: UILabel!
	@IBOutlet weak var lbTipoMed: UILabel!
    @IBOutlet weak var scScrollView: UIScrollView!
    @IBOutlet weak var lblcajaactual: UILabel!
    @IBOutlet weak var lblcajamiligramo: UILabel!
	@IBOutlet weak var imgAlimento: UIImageView!
	@IBOutlet weak var lbTipoUnidades: UILabel!
	@IBOutlet weak var lbTipoMedicamento: UILabel!
	
	@IBOutlet weak var imImage: UIImageView!
	@IBOutlet weak var viewImagenes: UIView!
	@IBOutlet weak var pager: UIPageControl!
	
	@IBOutlet weak var container: UIView!
	
	@IBOutlet weak var segSegments: UISegmentedControl!
    
    //VARIABLES
    var inPath : Int!
    
    var delegado = ProtocoloReloadTable!(nil)
    var indexMedicamento : Medicamento = Medicamento()
	var imgCounter: Int = -1
	var swipeRight = UISwipeGestureRecognizer()
	var swipeLeft = UISwipeGestureRecognizer()
	
	var botonSuperiorDerecho : UIBarButtonItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//crea botones enla esquina derecha
		botonSuperiorDerecho = UIBarButtonItem(title: "Editar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(editbottonpress))
		
		self.navigationItem.rightBarButtonItem = botonSuperiorDerecho

		scScrollView.contentSize = self.view.frame.size
		
		//agregar gesture para cambiar imagenes
		swipeRight.addTarget(self, action: #selector(cambiarFoto))
		swipeRight.direction = UISwipeGestureRecognizerDirection.Right
		
		swipeLeft.addTarget(self, action: #selector(cambiarFoto))
		swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
		
		viewImagenes.addGestureRecognizer(swipeRight)
		viewImagenes.addGestureRecognizer(swipeLeft)
		cambiarFoto(UISwipeGestureRecognizer())
		
		//definir imagenes
		imImage.image = UIImage(contentsOfFile: indexMedicamento.sFotoMedicamento)
		if (indexMedicamento.sFotoPastillero == nil) {
			pager.numberOfPages = 2
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	override func viewWillAppear(animated: Bool) {
		recargardatos()
		self.title = indexMedicamento.sNombre
	}
	
    func recargardatos() {
        //Escribe todos los datos en las labels
        
        lblNombre.text = indexMedicamento.sNombre
        lblDosis.text = String(Int(indexMedicamento.dDosisRecetada))
        lblVia.text = indexMedicamento.sTipoMedicina
		lbTipoMedicamento.text = indexMedicamento.sTipoMedicina
		lbTipoMed.text = indexMedicamento.sTipoMedicina + "(s)"
        
        if(indexMedicamento.sTipoDuracion == "s") {
            lblTipoduracion.text = "Semana(s)"
        }
			
        else if (indexMedicamento.sTipoDuracion == "d") {
            
            lblTipoduracion.text = "Dia(s)"
        }
			
        else {
            lblTipoduracion.text = "Mes(es)"
        }
        
		lbTipoUnidades.text = indexMedicamento.sUnidadesDosis
        lblDuracion.text = String(indexMedicamento.iDuracion)
        lblcajaactual.text = String(Int(indexMedicamento.dCantidadPorCajaActual))
        lblcajamiligramo.text = String(Int(indexMedicamento.dDosisPorTipo))
		
        
        //checa si necestia alimentos
        if (indexMedicamento.bNecesitaAlimento)  {
            imgAlimento.image = UIImage(named: "checkIcon")
        }
        else{
            imgAlimento.image = UIImage(named: "crossIcon")
        }
		
		if (indexMedicamento.sComentario == "" ) {
			txvComentario.text = "No hay comentarios"
		}
		else {
			txvComentario.text = indexMedicamento.sComentario
		}
		
        
    }
    
 
	
	
	func cambiarFoto(swipe: UISwipeGestureRecognizer) {
		let swipeGesture = swipe as? UISwipeGestureRecognizer
        //cambia de imagen al darle swipe
		
		if (swipeGesture!.direction == UISwipeGestureRecognizerDirection.Right) {
			imgCounter += 1
		}
		if (swipeGesture!.direction == UISwipeGestureRecognizerDirection.Left)  {
			imgCounter -= 1
		}
		
		if (indexMedicamento.sFotoPastillero != nil) {
			imgCounter %= 3
		}
		else {
			imgCounter %= 2
		}
		
		pager.currentPage = abs(imgCounter)
		
		switch abs(imgCounter) {
		case 0:
			imImage.image = UIImage(contentsOfFile: indexMedicamento.sFotoMedicamento)
		case 1:
			imImage.image = UIImage(contentsOfFile: indexMedicamento.sFotoCaja)
		case 2:
			imImage.image = UIImage(contentsOfFile: indexMedicamento.sFotoPastillero!)
		default:
			print("ERROR")
		}
	}
    
    
	@IBAction func cambioSegmento(sender: UISegmentedControl) {
		switch sender.selectedSegmentIndex {
            //al cambiar de opcion en el segmented control crea botones nuevos
		case 0:
			scScrollView.hidden = false
			container.hidden = true
			viewImagenes.hidden = true
			
			botonSuperiorDerecho = UIBarButtonItem(title: "Editar", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(editbottonpress))
		case 1:
			scScrollView.hidden = true
			container.hidden = false
			viewImagenes.hidden = true
			
			botonSuperiorDerecho = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
		case 2:
			scScrollView.hidden = true
			container.hidden = true
			viewImagenes.hidden = false
			
			botonSuperiorDerecho = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
		default:
			print("ERROR")
		}
		self.navigationItem.rightBarButtonItem = botonSuperiorDerecho
	}
	
	
	
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == "edit") {
            
            let view = segue.destinationViewController as! ViewControllerEditar
            //manda el medicamento a la otra view
            view.indMedicamento = indexMedicamento
            //view.delegado = self
            view.delegado = delegado
        }
        
        else {
            let view = segue.destinationViewController as! MisMedicamentosVerHorario
            
            view.medMedicina = indexMedicamento
			
            view.listaHorarios = indexMedicamento.horario
        }

        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
	
	
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        //no hace nada
    }
    
    
    func editbottonpress(sender:AnyObject){
        performSegueWithIdentifier("edit", sender: sender)
        
    }
    
    func reloadTable() {
        recargardatos()
    }
    
    func quitaVista() {
        
    }
}
