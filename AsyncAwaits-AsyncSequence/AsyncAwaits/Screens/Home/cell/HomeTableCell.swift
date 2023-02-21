//
//  HomeTableCell.swift
//  AsyncAwaits
//
//  Created by ketan jogal on 15/02/23.
//

import UIKit

class HomeTableCell: UITableViewCell {

    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setUpCellForEmployeePayroll(_ employeePayroll: EmployeePayroll){
        titleLbl.text = employeePayroll.name
        subTitleLbl.text = "\(employeePayroll.weeklyRate)"
    }
    
    func setUpCellForUsers(_ user: User){
        titleLbl.text = user.name
        subTitleLbl.text = user.email
    }
    
    func setUpCellForDevices(_ device: Device){
        titleLbl.text = device.name
        subTitleLbl.text = device.color
    }
    
}
