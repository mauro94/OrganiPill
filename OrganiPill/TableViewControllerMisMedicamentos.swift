//
//  TableViewControllerMisMedicamentos.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/6/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift

class TableViewControllerMisMedicamentos: UITableViewController {
    //variables
    @IBOutlet var tableVV: UITableView!
    
    var indice : Int!
    
    var perPersona = Persona()
    
    //variable de almacienamiento en realm
    
    override func viewDidAppear(animated: Bool) {
        tableVV.reloadData()
    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.title = "Mis Medicamentos"
       
        
        
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
        let realm = try! Realm()
        
        
        
        let current = realm.objects(Medicamento)[indexPath.row]
        // Configure the cell...
        
        
        let cell: TableViewCellMedicamento = tableView.dequeueReusableCellWithIdentifier("medicamento", forIndexPath: indexPath) as! TableViewCellMedicamento
        
        cell.lbNombreMedicamento.text =  current.sNombre
        
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
        
        
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
