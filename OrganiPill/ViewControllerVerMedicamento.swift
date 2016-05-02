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
    //variables
    
    @IBOutlet weak var lblpunto3: UILabel!
    @IBOutlet weak var lblpunto2: UILabel!
    @IBOutlet weak var lblpunto1: UILabel!
    @IBOutlet weak var lblNombre: UILabel!
    
    @IBOutlet weak var lblTipoduracion: UILabel!
    @IBOutlet weak var lblDuracion: UILabel!
    
    @IBOutlet weak var txvComentario: UITextView!
    
    @IBOutlet weak var lblDosis: UILabel!
    
    @IBOutlet weak var lblAlimento: UILabel!
    @IBOutlet weak var lblVia: UILabel!
    @IBOutlet weak var scScrollView: UIScrollView!
    
    @IBOutlet weak var lblcajaactual: UILabel!
    @IBOutlet weak var lblcajamiligramo: UILabel!
    @IBOutlet weak var imImage: UIImageView!
    
    
    var inPath : Int!
    
    
    var indexMedicamento : Medicamento!
    
    
    func recargardatos(){
        
        
        imImage.image = UIImage(contentsOfFile: indexMedicamento.sFotoMedicamento)
        
        
        lblpunto1.textColor = UIColor.redColor()
        
        
        
        
        
        lblNombre.text = indexMedicamento.sNombre
        lblDosis.text = String(indexMedicamento.dDosis)
        lblVia.text = indexMedicamento.sViaAdministracion
        
        if(indexMedicamento.sTipoDuracion == "s"){
            
            lblTipoduracion.text = "Semana(s)"
        }
        else if(indexMedicamento.sTipoDuracion == "d"){
            
            lblTipoduracion.text = "Dia(s)"
        }
        else{
            lblTipoduracion.text = "Mes(es)"
        }
        
        
        
        lblDuracion.text = String(indexMedicamento.iDuracion)
        lblcajaactual.text = String(indexMedicamento.dMiligramosCajaActual)
        lblcajamiligramo.text = String(indexMedicamento.dMiligramosCaja)
       
        txvComentario.text = indexMedicamento.sComentario
        if (indexMedicamento.bNecesitaAlimento)  {
            lblAlimento.text = "Si"
        }
        else{
            lblAlimento.text = "No"
        }
        
        
    }
    
    // --------------------------- MAIL --------------------------------------------------

    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
        
        
    }
    
    
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["gonzalogtzs94@gmail.com"])
        mailComposerVC.setSubject("OrganiPill")
        mailComposerVC.setMessageBody("<p>Holaaa<p>", isHTML: true)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //--------------------------- MAIL --------------------------------------------------
    
    
    
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        recargardatos()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        imImage.frame = CGRectMake(0,0, screenSize.height * 100, 350)
        
        
        recargardatos()
        
        
        
        
        
        // Do any additional setup after loading the view.
        self.title = "Medicina"
        
        
        
        
        let editButton : UIBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: Selector(""))
        
        self.navigationItem.rightBarButtonItem = editButton
        
        
        editButton.target = self
        editButton.action = "editbottonpress:"
        
        var viewSize = self.view.frame.size
        viewSize.height = 7000
        viewSize.width = 100
        scScrollView.scrollEnabled = true;
        scScrollView.contentSize = viewSize
        scScrollView.showsVerticalScrollIndicator = false
        
        
        
        
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var cambFoto:Int = 2
    @IBAction func CambiarFoto(sender: AnyObject) {
        if(cambFoto == 1){
            imImage.image = UIImage(contentsOfFile: indexMedicamento.sFotoMedicamento)
            cambFoto = 2
            
            lblpunto1.textColor = UIColor.redColor()
            lblpunto2.textColor = UIColor.blackColor()
            lblpunto3.textColor = UIColor.blackColor()
            
        }
        else if(cambFoto == 2){
            imImage.image = UIImage(contentsOfFile: indexMedicamento.sFotoCaja)
            cambFoto = 3
            lblpunto2.textColor = UIColor.redColor()
            lblpunto1.textColor = UIColor.blackColor()
            lblpunto3.textColor = UIColor.blackColor()
        }
        else{
            imImage.image = UIImage(contentsOfFile: indexMedicamento.sFotoPastillero!)
            cambFoto = 1
            lblpunto3.textColor = UIColor.redColor()
            lblpunto2.textColor = UIColor.blackColor()
            lblpunto1.textColor = UIColor.blackColor()
        }
        
    }
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        if(segue.identifier == "edit"){
            
            let view = segue.destinationViewController as! ViewControllerEditar
            
            view.indMedicamento = indexMedicamento
            
        }
        
        else{
        
            let view = segue.destinationViewController as! AgregarMedicamento4ViewController
            
            view.medMedicina = indexMedicamento
            
            view.listaHorarios = indexMedicamento.horario
        
        }
        
        
        
        
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    
    @IBAction func unwindToMenu(segue: UIStoryboardSegue) {
        
        
        
        
        
    }
    
    
    func editbottonpress(sender:AnyObject){
        
        
        performSegueWithIdentifier("edit", sender: sender)
        
        
        
        
    }
    
    
}
