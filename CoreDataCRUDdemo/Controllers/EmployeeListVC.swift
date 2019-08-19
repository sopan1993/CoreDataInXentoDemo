//
//  ViewController.swift
//  CoreDataCRUDdemo
//
//  Created by Sopan M. Sanap on 13/08/19.
//  Copyright © 2019 Sopan M. Sanap. All rights reserved.
//

import UIKit
import CoreData

class EmployeeListVC: UIViewController {

    @IBOutlet weak var employeeTable: UITableView!
    
    
    var employeeArray = [Employee]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeTable.delegate = self
        employeeTable.dataSource = self
        
        self.getEmployees()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    func getEmployees(){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        self.employeeArray.removeAll()
        do {
            let Employees = try context.fetch(fetchRequest)
            guard let arrEmp = Employees as? [Employee] else {return}
            self.employeeArray = arrEmp
            DispatchQueue.main.async {
                self.employeeTable.reloadData()
            }

        }catch let error as NSError{
            print("Error in retieving employees",error.userInfo)
        }
        
    }
    
    func deleteEmployee(emp:Employee) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(emp)
        do {
            
            try context.save()
            self.getEmployees()
            
        } catch {
            
            print("Failed saving")
        }
        
    }

    
    @IBAction func btnAddEmployeeClicked(_ sender: Any) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: AddEmployeeVC.vcIdentifier) as? AddEmployeeVC else { return }
        vc.employeeArr = self.employeeArray
        vc.callback = { (id) -> Void in
            print("callback to add")
            
            self.getEmployees()
            
        }
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    @IBAction func btnSortByNameClicked(_ sender: Any) {
       
        self.employeeArray.sort(by: { $0.name! < $1.name! })
        employeeTable.reloadData()
    }
    
    @IBAction func btnSortByCityClicked(_ sender: Any) {
        
        self.employeeArray.sort(by: { $0.city! < $1.city! })
        employeeTable.reloadData()
    }
    
    @IBAction func btnSortByPhoneClicked(_ sender: Any) {
        
        self.employeeArray.sort(by: { $0.phone < $1.phone })
        employeeTable.reloadData()
        
    }
    
}

extension EmployeeListVC: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.employeeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.employeeTable.dequeueReusableCell(withIdentifier: EmployeeTableCustomCell.cellIdentifier, for: indexPath) as? EmployeeTableCustomCell {
           cell.emp = self.employeeArray[indexPath.row]
            
           return cell
        }else{
           return UITableViewCell()
        
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
        
            let temp = self.employeeArray[indexPath.row]
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: AddEmployeeVC.vcIdentifier) as? AddEmployeeVC {
                vc.empObj = temp
                
                vc.callback = { (id) -> Void in
                    print("callback to edit")
                    
                    self.getEmployees()
                    
                }
                self.navigationController?.pushViewController(vc, animated: false)
                
            }
        })
        editAction.backgroundColor = UIColor.lightGray
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
           let empObj = self.employeeArray[indexPath.row]
           self.deleteEmployee(emp:empObj)
            
        })
        deleteAction.backgroundColor = UIColor.red
        
        return [editAction, deleteAction]
    }
    
  
}



