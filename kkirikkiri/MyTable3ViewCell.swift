//
//  MyTable3ViewCell.swift
//  kkirikkiri
//
//  Created by 박범수 on 12/6/24.
//

import UIKit

class MyTable3ViewCell: UITableViewCell {

    static let idetifier = "MyTable3ViewCell"
    
    @IBOutlet var tableTitleLabel: UILabel!
    @IBOutlet var classificationLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTable3ViewCell", bundle: nil)
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
