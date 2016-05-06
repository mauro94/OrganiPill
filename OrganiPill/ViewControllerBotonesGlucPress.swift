//
//  ViewControllerBotonesGlucPress.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 5/3/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit
import RealmSwift


class ViewControllerBotonesGlucPress: UIViewController, UITableViewDataSource, UITableViewDelegate, ProtocoloReloadTable {
    
    @IBOutlet weak var tbvTable: UITableView!
    
	@IBOutlet weak var viewNoDatos: UIView!
    
    
    
    
    @IBOutlet weak var sgmControl: UISegmentedControl!
    var opcionSgm:Bool = true
    
    
    
    
    
    var desplegaGlucosa = List<Medidas>()
    
    var desplegaPresSys = List<Medidas>()
    var desplegaPresDiast = List<Medidas>()
    
    
    
    
    
    override func viewDidAppear(animated: Bool) {
        tbvTable.reloadData()
    }
    
	override func viewWillAppear(animated: Bool) {
		switch sgmControl.selectedSegmentIndex
		{
		case 0:
            //si existe datos guardados los muestra
			
			if (desplegaGlucosa.count > 0) {
				tbvTable.hidden = false
				viewNoDatos.hidden = true
			}
			else {
				tbvTable.hidden = true
				viewNoDatos.hidden = false
			}
			
			
		case 1:
			
			if (desplegaPresSys.count > 0) {
				tbvTable.hidden = false
				viewNoDatos.hidden = true
			}
			else {
				tbvTable.hidden = true
				viewNoDatos.hidden = false
			}
		default:
			break;
		}
	}
	
	
	
	
	
	
    override func viewDidLoad() {
		
        self.title = "Datos Paraclínicos"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Atrás", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        
        
        //perPersona.medMedicamentos.append(medMedicamentos)
        
        // Get the default Realm
        let realm = try! Realm()
        // You only need to do this once (per thread)
        
        // Add to the Realm inside a transaction
        
        
        
        
        super.viewDidLoad()
        if(!realm.objects(DatosGlucosa).isEmpty){
            let currentGlucosa = realm.objects(DatosGlucosa)[0]
            desplegaGlucosa = currentGlucosa.historialMedidas
        }
        else{
            
            let medAux2: DatosGlucosa! = DatosGlucosa()
            //let medidad: Medidas! = Medidas()
            
            medAux2.rangoAlto = 100
            medAux2.rangoBajo = 1
            
            
            // medidad.valor = 10;
            //medidad.fecha = NSDate()
            
            
            //  medAux2.historialMedidas.append(medidad)
            
            try! realm.write {
                realm.add(medAux2)
                
            }
            let currentGlucosa = realm.objects(DatosGlucosa)[0]
            desplegaGlucosa = currentGlucosa.historialMedidas
            
        }
        
        if(!realm.objects(DatosPresion).isEmpty){
            let currentPressSys = realm.objects(DatosPresion)[0]
            desplegaPresSys = currentPressSys.historialSystolic
            desplegaPresDiast = currentPressSys.historialDiastolic
        }
        else{
            
            let medAux3: DatosPresion! = DatosPresion()
            //let medidad2: Medidas! = Medidas()
            
            medAux3.sysolicAlto = 100
            medAux3.systolicBajo = 1
            
            medAux3.diastolicAlto = 100
            medAux3.diastolicBajo = 1
            
            
            
            
            try! realm.write {
                realm.add(medAux3)
                
            }
            
            let currentPressSys = realm.objects(DatosPresion)[0]
            desplegaPresSys = currentPressSys.historialSystolic
            desplegaPresDiast = currentPressSys.historialDiastolic
            
        }
        
        
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ViewControllerBotonesGlucPress.nuevoDato(_:)))
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView ( tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        if(opcionSgm){
            return desplegaGlucosa.count
        }
        else{
            return desplegaPresSys.count
        }
        
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(  "cell", forIndexPath: indexPath) as! TableViewCellDatosGluc
        
        let formatoHora = NSDateFormatter()
        formatoHora.locale = NSLocale.init(localeIdentifier: "ES")
        formatoHora.dateFormat = "EEE, dd 'de' MMMM h:mm a"
        
        if(opcionSgm){
            let auxIndex:Int = (desplegaGlucosa.count - indexPath.row - 1)
            cell.lblTituloDato.text = "Nivel de Glucosa:"
            cell.lblDatosG.text = String( desplegaGlucosa[auxIndex].valor)
            
            
            
            
            cell.lblFecha.text = formatoHora.stringFromDate(desplegaGlucosa[auxIndex].fecha)
            
        }
        else if(!opcionSgm){
            let auxIndex2:Int = (desplegaPresDiast.count - indexPath.row - 1)
            
            cell.lblDatosG.text = String( desplegaPresSys[auxIndex2].valor)+"/" + String( desplegaPresDiast[auxIndex2].valor)
            
            
            cell.lblTituloDato.text = "Nivel de Presion:"
            
            //cell.lblDatosG.text = (String( desplegaPresSys[indexPath.row].valor)+"/" + String(desplegaPresDiast[indexPath.row].valor))
            
            cell.lblFecha.text = formatoHora.stringFromDate(desplegaPresSys[auxIndex2].fecha)
        }
		
		let backgroundView = UIView()
		backgroundView.backgroundColor = UIColor(red: 255.0/255.0, green: 70.0/255.0, blue: 89.0/255.0, alpha: 0.2)
		cell.selectedBackgroundView = backgroundView
		
		cell.setNeedsDisplay()
        
        
        return cell
        
    }
    
    func nuevoDato(sender: AnyObject){
        
        //mandar el segue correcto
        if(opcionSgm){
            performSegueWithIdentifier("newDG", sender: sender)
            
        }
        else if(!opcionSgm){
            performSegueWithIdentifier("newDP", sender: sender)
        }
        
        
    }
    
    @IBAction func SegmentedOpcion(sender: AnyObject)  {
        
        switch sgmControl.selectedSegmentIndex
            //esconder la table
        {
        case 0:
            opcionSgm = true
            tbvTable.reloadData()
			
			if (desplegaGlucosa.count > 0) {
				tbvTable.hidden = false
				viewNoDatos.hidden = true
			}
			else {
				tbvTable.hidden = true
				viewNoDatos.hidden = false
			}
            
            
        case 1:
            opcionSgm = false
            tbvTable.reloadData()
			
			if (desplegaPresSys.count > 0) {
				tbvTable.hidden = false
				viewNoDatos.hidden = true
			}
			else {
				tbvTable.hidden = true
				viewNoDatos.hidden = false
			}
        default:
            break;
        }
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let viewAgregar = segue.destinationViewController as! ViewControllerAgregarDatos
        viewAgregar.delegado = self
        
        
        if(segue.identifier == "newDG"){
            viewAgregar.textoArriba = "Glucosa:"
            
            
            
            
        }
            
        else if(segue.identifier == "newDP"){
            
            
            viewAgregar.isGlucosa = false
            
            viewAgregar.textoArriba = "Systolic:"
            viewAgregar.textoAbajo = "Diastolic:"
            
        }
        
        else if(segue.identifier == "borrar"){
            
           let indexPath = tbvTable.indexPathForSelectedRow
        
            viewAgregar.borrar = true
            
            if(opcionSgm){
                let auxIndex:Int = (desplegaGlucosa.count - (indexPath?.row)! - 1)
                viewAgregar.textoArriba = "Glucosa:"
                viewAgregar.textoCajaArriba = String(desplegaGlucosa[auxIndex].valor)
                
                viewAgregar.auxMedidaGlucosa = desplegaGlucosa[auxIndex]
                
                
            }
            else if(!opcionSgm){
                let auxIndex:Int = (desplegaPresSys.count - (indexPath?.row)! - 1)
                viewAgregar.isGlucosa = false
                
                viewAgregar.textoArriba = "Sistólica:"
                viewAgregar.textoAbajo = "Diastólica:"
                
                viewAgregar.textoCajaArriba = String(desplegaPresSys[auxIndex].valor)
                viewAgregar.textoCajaAbajo = String(desplegaPresDiast[auxIndex].valor)
                
                viewAgregar.auxMedidaSys = desplegaPresSys[auxIndex]
                viewAgregar.auxMedidaDiac = desplegaPresDiast[auxIndex]
                
                
                
            }
            
            
        }
        
        
    }
    
    func reloadTable() {
        tbvTable.reloadData()
    }
    
    func quitaVista() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    
}
