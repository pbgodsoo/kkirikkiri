//
//  MyTableViewCell.swift
//  kkirikkiri
//
//  Created by 박범수 on 12/4/24.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    static let idetifier = "MyTableViewCell"
    
    @IBOutlet var tableTitleLabel: UILabel!
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet var periodLabel2: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "MyTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none // 클릭시 색 변경X
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
