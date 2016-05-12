//
//  AgregarMedicamentoFoto2ViewController.swift
//  OrganiPill
//
//  Created by David Benitez on 4/13/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class AgregarMedicamentoFoto2ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var imgFoto: UIImageView!
	@IBOutlet weak var viewNoImagen: UIView!
    
    //MARK: - Global Variables
    var medMedicina : Medicamento = Medicamento()
    var pathImagen : String!
    var tieneImagen : Bool = false
    var filename:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        // Do any additional setup after loading the view.
		self.title = "Caja del Medicamento"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //alerta si no hay imagen
    func emptyImage(){
        //creates popup message
        let alerta = UIAlertController(title: "¡Alerta!", message: "Parece que olvidaste elegir una foto", preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Regresar", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
    }
    
    //abre la galeria para elegir una foto
    @IBAction func abreGaleria(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    //abre la camara para tomar una foto
    @IBAction func abreCamara(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .Camera
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    //agarra el path donde se gurada la foto
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //maneja las acciones al elegir una foto
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let foto = info[UIImagePickerControllerOriginalImage] as? UIImage;
        
        //guarda la foto
        if let image = foto {
            if let data = UIImagePNGRepresentation(image) {
                filename = getDocumentsDirectory().stringByAppendingPathComponent("\(medMedicina.sNombre)2.png")
                data.writeToFile(filename, atomically: true)
                
            }
        }

        pathImagen = filename
        
        imgFoto.image = foto
        dismissViewControllerAnimated(true, completion: nil)
        
        tieneImagen = true
		
		//esconder vista y demostrar imagen
		imgFoto.hidden = false
		viewNoImagen.hidden = true
    }
	
	@IBAction func btSiguiente(sender: AnyObject) {
		if(tieneImagen){
			if (medMedicina.sTipoMedicina == "Inyección" || medMedicina.sTipoMedicina == "Suspensión") {
				performSegueWithIdentifier("noPastillero", sender: sender)
			}
			else {
				performSegueWithIdentifier("pastillero", sender: sender)
			}
		}
		else {
			emptyImage()
		}
	}
	
	
    
     // MARK: - Navigation
	override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if(tieneImagen){
            return true
        }
        else{
            emptyImage()
            return false
        }
    }
    
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (segue.identifier == "pastillero") {
			let viewSiguiente = segue.destinationViewController as! AgregarMedicamentoFoto3ViewController
			
			//guarda los datos del medicamento de esta vista
			medMedicina.sFotoCaja = pathImagen
			
			viewSiguiente.medMedicina = medMedicina
		}
		else {
			let viewSiguiente = segue.destinationViewController as! AgregarMedicamento3ViewController
			
			//guarda los datos del medicamento de esta vista
			medMedicina.sFotoCaja = pathImagen
			medMedicina.sFotoPastillero = nil
			
			viewSiguiente.medMedicina = medMedicina
		}
		
     }
	
}