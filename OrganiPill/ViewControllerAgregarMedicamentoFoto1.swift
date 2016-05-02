//
//  ViewControllerAgregarMedicamentoFoto1.swift
//  OrganiPill
//
//  Created by David Benitez on 4/13/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class ViewControllerAgregarMedicamentoFoto1: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Outlets
    @IBOutlet weak var bttnGaleria: UIButton!
    @IBOutlet weak var bttnCamara: UIButton!
    @IBOutlet weak var imgFoto: UIImageView!
	@IBOutlet weak var viewNoImagen: UIView!

    
    //MARK: - Global Variables
    var medMedicina : Medicamento = Medicamento()
    var pathImagen : NSURL!
    var tieneImagen : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        decideTitulo()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func emptyImage(){
        //creates popup message
        let alerta = UIAlertController(title: "¡Alerta!", message: "Parece que olvidaste elegir una foto", preferredStyle: UIAlertControllerStyle.Alert)
        
        alerta.addAction(UIAlertAction(title: "Regresar", style: UIAlertActionStyle.Cancel, handler: nil))
        
        presentViewController(alerta, animated: true, completion: nil)
    }

    //decide titulo de la vista
    func decideTitulo(){
        switch(medMedicina.sViaAdministracion){
        //pastillas
        case "Pastilla":
            self.title = "Imágen de la Pastilla"
            break
        //inyeccion
        case "Inyección":
            self.title = "Imágen del Bote"
            break
        //supositorio
        case "Supositorio":
            self.title = "Imágen del Supositorio"
            break
        //liquida
        case "Suspensión":
            self.title = "Imágen del Bote"
            break
        case "Cápsulas":
            self.title = "Imágen de la Cápsula"
            break
        default:
            break
        }
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let foto = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //guarda el path de la imagen seleccionada/tomada
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imagePath =  imageURL.path!
        pathImagen = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(imagePath)
        
        imgFoto.image = foto
        dismissViewControllerAnimated(true, completion: nil)
        
        tieneImagen = true
		
		//esconder vista y demostrar imagen
		imgFoto.hidden = false
		viewNoImagen.hidden = true
    }
    
    //MARK: - Navigation
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

        let viewSiguiente = segue.destinationViewController as! AgregarMedicamentoFoto2ViewController
        
        //guarda los datos del medicamento de esta vista
        medMedicina.sFotoMedicamento = pathImagen.absoluteString
        
        viewSiguiente.medMedicina = medMedicina
    }
}
