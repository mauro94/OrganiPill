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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
		self.title = "Imágen de Pastillero"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func abreGaleria(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func abreCamara(sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .Camera
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    var filename: String!
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let foto = info[UIImagePickerControllerOriginalImage] as? UIImage;
        
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
	
    //actualiza vistas y botones para cuando no hay imagen
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
