//
//  ViewControllerEditar.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 4/18/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class ViewControllerEditar: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pcPicker: UIScrollView!
    @IBOutlet weak var scScrollView: UIScrollView!
    
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfDuracion: UITextField!
    @IBOutlet weak var tfDosis: UITextField!
 
    let pickerData = ["Injeccion","Comestible","Supositorio", "Tomable"]
    var nombres : String!
    var Dosis : String!
    var Duracion : String!
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tfNombre.text = nombres
        tfDosis.text = Dosis
        tfDuracion.text = Duracion
        
       
        
        var viewSize = self.view.frame.size
        viewSize.height = 800
        viewSize.width = 100
        scScrollView.scrollEnabled = true;
        scScrollView.contentSize = viewSize
        scScrollView.showsVerticalScrollIndicator = false
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
