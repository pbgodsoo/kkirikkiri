//
//  MyTable4ViewCell.swift
//  kkirikkiri
//
//  Created by 박범수 on 12/10/24.
//

import UIKit

class MyTable4ViewCell: UITableViewCell {

    static let idetifier = "MyTable4ViewCell"
    
    @IBOutlet var tableTitleLabel: UILabel!
    @IBOutlet var texttLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTable4ViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
