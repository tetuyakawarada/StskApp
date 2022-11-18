//
//  TaskTableViewCell.swift
//  StskApp
//
//  Created by tetsuya on 2022/11/16.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel! //①
    @IBOutlet weak var subjectNameLabel: UILabel! //②
    @IBOutlet weak var bodyLabel: UILabel! //④
    @IBOutlet weak var progressTimeLabel: UILabel! //⑤
    @IBOutlet weak var totalTimeLabel: UILabel! //⑤
    @IBOutlet weak var degreeTimeLabel: UILabel! //⑤

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
