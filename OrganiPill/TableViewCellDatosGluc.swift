//
//  TableViewCellDatosGluc.swift
//  OrganiPill
//
//  Created by Gonzalo Gutierrez on 5/3/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class TableViewCellDatosGluc: UITableViewCell {

    @IBOutlet weak var lblTituloDato: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblDatosG: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
