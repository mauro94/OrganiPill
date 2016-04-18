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
    
    //MARK: - Global Variables
    var medMedicina : Medicamento = Medicamento()
    var pathImagen : NSURL!
    var tieneImagen : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let foto = info[UIImagePickerControllerOriginalImage] as? UIImage;
        
        //guarda el path de la imagen seleccionada/tomada
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imagePath =  imageURL.path!
        pathImagen = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(imagePath)
        
        imgFoto.image = foto
        dismissViewControllerAnimated(true, completion: nil)
        
        bttnSiguiente.setTitle("Siguiente", forState: UIControlState.Normal)
        
        tieneImagen = true
    }
    
     // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let viewSiguiente = segue.destinationViewController as! AgregarMedicamento3ViewController
        
        if(tieneImagen){
            medMedicina.sFotoPastillero = pathImagen.absoluteString
        }
        
        viewSiguiente.medMedicina = medMedicina
     }
    
}
