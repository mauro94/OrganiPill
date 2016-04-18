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
    
    var indice : Int!
	
	var perPersona = Persona()
	
    //variable de almacienamiento en realm
    
    
    var ArrmedMedicamentos = [Medicamento]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		self.title = "Mis Medicamentos"
		
        let medAux: Medicamento! = Medicamento()
        
        medAux.sNombre = "Advil"
        medAux.sViaAdministracion = "Injeccion"
        medAux.iDias = 10;
        
        
        
        let medAux2: Medicamento! = Medicamento()
        
        medAux2.sNombre = "Tempra"
        medAux2.sViaAdministracion = "Comestible"
        medAux2.iDias = 1;
		
        
        
        ArrmedMedicamentos.append(medAux);
        ArrmedMedicamentos.append(medAux2);
		
		perPersona.sNombre = "Gonzalo"
        
        
        
        
        
		
		//perPersona.medMedicamentos.append(medMedicamentos)
		
		// Get the default Realm
		let realm = try! Realm()
		// You only need to do this once (per thread)
		
		// Add to the Realm inside a transaction
		try! realm.write {
			realm.add(perPersona)
		}
	
        
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
        return ArrmedMedicamentos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

      
        
        
        
        // Configure the cell...
		let cell: TableViewCellMedicamento = tableView.dequeueReusableCellWithIdentifier("medicamento", forIndexPath: indexPath) as! TableViewCellMedicamento
		
        cell.lbNombreMedicamento.text =  ArrmedMedicamentos[indexPath.row].sNombre

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
        
        
        view.nombres = ArrmedMedicamentos[indexPath!.row].sNombre
        
        view.Duracion = String( ArrmedMedicamentos[indexPath!.row].iDias)


        view.viaAdmi = ArrmedMedicamentos[indexPath!.row].sViaAdministracion

        
        
        indice = (indexPath?.row)!
        
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
