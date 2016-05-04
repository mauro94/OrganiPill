//
//  TableViewControllerMisMedicamentos.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/6/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewControllerMisMedicamentos: UITableViewController, ProtocoloReloadTable {
    //variables
    @IBOutlet var tableVV: UITableView!
    
    var indice : Int!
    
    var perPersona = Persona()
        
    override func viewDidAppear(animated: Bool) {
        tableVV.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Mis Medicamentos"
       
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        //--------------------------- PDF --------------------------------------------------
    
        let html = "<b>Hello <i>World!</i></b> <p>PENE FOREVER</p>"
        let fmt = UIMarkupTextPrintFormatter(markupText: html)
        
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAtIndex: 0)
        
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) 
        let printable = CGRectInset(page, 0, 0)
        
        render.setValue(NSValue(CGRect: page), forKey: "paperRect")
        render.setValue(NSValue(CGRect: printable), forKey: "printableRect")

        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRectZero, nil)
        
        for i in 1...render.numberOfPages() {
            
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPageAtIndex(i - 1, inRect: bounds)
        }
        
        UIGraphicsEndPDFContext();

        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        
        pdfData.writeToFile("\(documentsPath)/file.pdf", atomically: true)
        
        
        print(documentsPath);
        
        //--------------------------- PDF --------------------------------------------------
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let realm = try! Realm()
        
        return realm.objects(Medicamento).count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  
        
        let cell: TableViewCellMedicamento = tableView.dequeueReusableCellWithIdentifier("medicamento", forIndexPath: indexPath) as! TableViewCellMedicamento
        
        let realm = try! Realm()
        
        
        
        let current = realm.objects(Medicamento)[indexPath.row]
        // Configure the cell...
        
        //var num : Int = current.horario[0].listaDias[3]
        
        for h in 0...(current.horario.count - 1) {
            
            for d in 0...(current.horario[h].listaDias.count - 1 ){
                
                let valor = current.horario[h].listaDias[d]
                let aux1: Int = valor.dia
                
                if(aux1 == 2){
                    cell.lblLunes.textColor = UIColor.redColor()
                }
                else if(aux1 == 3){
                    cell.lblMartes.textColor = UIColor.redColor()
                }
                else if(aux1 == 4){
                    cell.lblMiercoles.textColor = UIColor.redColor()
                }
                else if(aux1 == 5){
                    cell.lblJueves.textColor = UIColor.redColor()
                }
                else if(aux1 == 6){
                    cell.lblViernes.textColor = UIColor.redColor()
                }
                else if(aux1 == 7){
                    cell.lblSabado.textColor = UIColor.redColor()
                }
                else if(aux1 == 1){
                    cell.lblDomingo.textColor = UIColor.redColor()
                }
            }
            
        }
        
        
        
        cell.lbNombreMedicamento.text =  current.sNombre
        
        cell.imMedicamento.image = UIImage(contentsOfFile: current.sFotoMedicamento)
        
        cell.imCaja.image = UIImage(contentsOfFile: current.sFotoCaja)
        
        
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 0.2)
		cell.selectedBackgroundView = backgroundView
		
        cell.setNeedsDisplay()
        
        return cell
    }

    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let view = segue.destinationViewController as! ViewControllerVerMedicamento
        
        let indexPath = tableView.indexPathForSelectedRow
        
        let realm = try! Realm()
        
        let current = realm.objects(Medicamento)[indexPath!.row]
        
        view.indexMedicamento = current
        
        view.delegado = self
        
    }
    
    func reloadTable() {
        tableVV.reloadData()
    }
    
    func quitaVista() {
        
    }
    
    
}
