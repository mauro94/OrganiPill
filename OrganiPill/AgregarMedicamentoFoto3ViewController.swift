//
//  AgregarMedicamentoFoto3ViewController.swift
//  OrganiPill
//
//  Created by David Benitez on 4/13/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class AgregarMedicamentoFoto3ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var imgFoto: UIImageView!
    @IBOutlet weak var bttnSiguiente: UIButton!
    @IBOutlet weak var viewNoImagen: UIView!
    
    //MARK: - Global Variables
    var medMedicina : Medicamento = Medicamento()
    var pathImagen : String!
    var tieneImagen : Bool = false
    var filename: String!

    
    override func viewDidLoad() {
        super.viewDidLoad()
		
		self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        // Do any additional setup after loading the view.
		self.title = "Pastillero"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //deja seleccionar una foto de la galeria
    @IBAction func abreGaleria(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    //deja seleccionar una foto con la camara
    @IBAction func abreCamara(sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .Camera
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    //genera el path de la foto
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //accion hecha al seleccionar/tomar una foto
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let foto = info[UIImagePickerControllerOriginalImage] as? UIImage;
        
        //guarda la foto
        if let image = foto {
            if let data = UIImagePNGRepresentation(image) {
                filename = getDocumentsDirectory().stringByAppendingPathComponent("\(medMedicina.sNombre)3.png")
                data.writeToFile(filename, atomically: true)
                
            }
        }
        
        pathImagen = filename
        
        //esconder vista y demostrar imagen
        imgFoto.image = foto
        dismissViewControllerAnimated(true, completion: nil)
        tieneImagen = true
        imgFoto.hidden = false
        viewNoImagen.hidden = true
        
        //actualizar botones
        bttnSiguiente.setTitle("Siguiente", forState: UIControlState.Normal)
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Borrar", style: UIBarButtonItemStyle.Done, target: self, action: #selector(AgregarMedicamentoFoto3ViewController.cancelarButtonPressed(_:)))
    }
	
    //maneja como borrar una foto
	func cancelarButtonPressed(sender: AnyObject){
		tieneImagen = false
		imgFoto.image = nil
        imgFoto.hidden = true
        viewNoImagen.hidden = false
		bttnSiguiente.setTitle("Saltar", forState: UIControlState.Normal)
		navigationItem.rightBarButtonItem = nil
	}
	
     // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let viewSiguiente = segue.destinationViewController as! AgregarMedicamento3ViewController
        
        //guarda los datos del medicamento de esta vista
        if(tieneImagen){
            medMedicina.sFotoPastillero = pathImagen
        }
        
        viewSiguiente.medMedicina = medMedicina
     }
    
}
