//
//  TableViewCellMedicamento.swift
//  OrganiPill
//
//  Created by Mauro Amarante on 4/6/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class TableViewCellMedicamento: UITableViewCell {
	//variables
	
    @IBOutlet weak var imCaja: UIImageView!
    @IBOutlet weak var imMedicamento: UIImageView!
    @IBOutlet weak var lblDomingo: UILabel!
    @IBOutlet weak var lblSabado: UILabel!
    @IBOutlet weak var lblViernes: UILabel!
    @IBOutlet weak var lblJueves: UILabel!
    @IBOutlet weak var lblMiercoles: UILabel!
    @IBOutlet weak var lblLunes: UILabel!
    @IBOutlet weak var lbNombreMedicamento: UILabel!

    @IBOutlet weak var lblMartes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
