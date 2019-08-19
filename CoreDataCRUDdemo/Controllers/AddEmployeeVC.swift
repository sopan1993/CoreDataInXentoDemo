//
//  AddEmployeeVC.swift
//  CoreDataCRUDdemo
//
//  Created by Sopan M. Sanap on 13/08/19.
//  Copyright © 2019 Sopan M. Sanap. All rights reserved.
//

import UIKit
import CoreData

class AddEmployeeVC: UIViewController {

    
    @IBOutlet weak var txtfEmpName: UITextField!
    
    @IBOutlet weak var txtfEmpPhone: UITextField!
    
    @IBOutlet weak var txtfEmpCity: UITextField!
    
    @IBOutlet weak var addOrEditEmployeeButton: UIButton!
    
    
    var empObj: Employee?
    var employeeArr = [Employee]()

    var callback: ((_ id: Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtfEmpName.delegate = self
        txtfEmpPhone.delegate = self
        txtfEmpCity.delegate = self
        if let empObj = empObj{
            txtfEmpName.text = empObj.name
            txtfEmpPhone.text = String(describing: empObj.phone)
            txtfEmpCity.text = empObj.city
           
           addOrEditEmployeeButton.setTitle("Edit Employee", for: .normal)
           self.navigationItem.title = "Edit Employee"
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    func addEditEmployee(name:String,phone:Int64,city:String,empObj:Employee?){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let emp = empObj{
            emp.setValue(name, forKey: "name")
            emp.setValue(phone, forKey: "phone")
            emp.setValue(emp.id, forKey: "id")
            emp.setValue(city, forKey: "city")
            
        }else{
            
            guard let empEntity = NSEntityDescription.entity(forEntityName: "Employee", in: managedContext) else {return}
            guard let emp = NSManagedObject(entity: empEntity, insertInto: managedContext) as? Employee else{return}
            emp.name = name
            emp.phone = phone
            emp.city = city
            
            if employeeArr.isEmpty{
                emp.id = 1
               
            }else{
                let maxId = self.employeeArr.map{ $0.id }.max()
                emp.id = maxId! + 1
            }
        }
        
        do
        {
            try managedContext.save()
            guard let call = callback else{return}
            call(1)
            self.navigationController?.popViewController(animated: false)
            
        }catch let error as NSError {
            
            print("Error in saving:\(error.userInfo)")
        }
        
    }
    
    
    
    @IBAction func btnAddEmployeeClicked(_ sender: Any) {
        
        if validateTextfieldText() && validatePhoneNumber() {
            
            self.addEditEmployee(name: self.txtfEmpName.text!,phone: Int64(self.txtfEmpPhone.text!)!,city: self.txtfEmpCity.text!, empObj: empObj)
        }

    }
    
    func validatePhoneNumber() -> Bool {
        
        let arr = self.employeeArr.filter {String($0.phone) == self.txtfEmpPhone.text}
        if arr.isEmpty{
            return true
        }else{
            self.showAlert(msg:Constant.phoneAlreadyExist)
            return false
        }
        
    }
    
    
    func validateTextfieldText() -> Bool{
        
        if self.txtfEmpName.text == ""{
            self.showAlert(msg:Constant.missingName)
            return false
        }else if self.txtfEmpPhone.text == ""{
            self.showAlert(msg:Constant.missingPhoneNumber)
            return false
        }else if self.txtfEmpPhone.text?.count != 10{
            self.showAlert(msg:Constant.invalidPhoneNumber)
            return false
        }else if self.txtfEmpCity.text == ""{
            self.showAlert(msg:Constant.missingCity)
            return false
        }else{
            return true
        }
        
    }
    
  
}
extension AddEmployeeVC: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtfEmpPhone{
            guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
                return false
            }
            return true
        }else{
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
