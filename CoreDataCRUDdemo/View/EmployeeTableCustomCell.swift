//
//  EmployeeTableCustomCell.swift
//  CoreDataCRUDdemo
//
//  Created by Sopan M. Sanap on 13/08/19.
//  Copyright © 2019 Sopan M. Sanap. All rights reserved.
//

import UIKit

class EmployeeTableCustomCell: UITableViewCell {

    
     @IBOutlet weak var lblEmpName: UILabel!
     @IBOutlet weak var lblEmpPhone: UILabel!
     @IBOutlet weak var lblEmpCity: UILabel!
    
    var emp: Employee?{
            didSet {
                lblEmpName.text = "Name: " + (emp?.name)!
                if let phone = emp?.phone {
                    lblEmpPhone.text = "Phone Number: " + String(phone)
                }
                lblEmpCity.text = "City: " + (emp?.city)!
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
