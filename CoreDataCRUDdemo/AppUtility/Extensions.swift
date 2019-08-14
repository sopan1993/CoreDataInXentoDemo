//
//  Extensions.swift
//  CoreDataCRUDdemo
//
//  Created by Sopan M. Sanap on 13/08/19.
//  Copyright © 2019 Sopan M. Sanap. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    static var vcIdentifier : String {
        return String(describing: self)
    }
    
    func showAlert(msg:String){
        let alert = UIAlertController(title: "Alert", message: msg, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
extension UITableViewCell{
    static var cellIdentifier: String{
        
        return String(describing:self)
    }
}
