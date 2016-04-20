//
//  CustomTableViewCell.swift
//  OrganiPill
//
//  Created by David Benitez on 4/19/16.
//  Copyright © 2016 Mauro Amarante. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var lblHora: UILabel!
    @IBOutlet weak var bttnD: UIButton!
    @IBOutlet weak var bttnL: UIButton!
    @IBOutlet weak var bttnMa: UIButton!
    @IBOutlet weak var bttnMi: UIButton!
    @IBOutlet weak var bttnJ: UIButton!
    @IBOutlet weak var bttnV: UIButton!
    @IBOutlet weak var bttnS: UIButton!
    
    var bttnDias = [UIButton]!(nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bttnDias = [bttnD, bttnL, bttnMa, bttnMi, bttnJ, bttnV, bttnS]
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
