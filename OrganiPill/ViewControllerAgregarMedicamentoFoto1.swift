//
//  ViewControllerAgregarMedicamentoFoto1.swift
//  OrganiPill
//
//  Created by David Benitez on 4/13/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class ViewControllerAgregarMedicamentoFoto1: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var bttnGaleria: UIButton!
    @IBOutlet weak var bttnCamara: UIButton!
    @IBOutlet weak var imgFoto: UIImageView!
    
    //MARK: - Global Variables
    var medMedicina : Medicamento = Medicamento()
    var pathImagen : NSURL!

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
        
        let foto = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //guarda el path de la imagen seleccionada/tomada
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let imagePath =  imageURL.path!
        pathImagen = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(imagePath)
        
        imgFoto.image = foto
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let viewSiguiente = segue.destinationViewController as! AgregarMedicamentoFoto2ViewController
        
        medMedicina.sFotoMedicamento = pathImagen.absoluteString
        
        viewSiguiente.medMedicina = medMedicina
        
    }

}
