//
//  BirthdayListTableViewController.swift
//  BirthdayTracker
//
//  Created by Антон Титов on 09.01.2022.
//

import UIKit
import CoreData
import UserNotifications


class BirthdayListTableViewController: UITableViewController {
    
    let birthdayCellIdentifier = "birthdayCellIdentifier"
    
    var birthdayList = [Birthday]()
    
    let formmater = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.delegate = self
        
        formmater.dateStyle = DateFormatter.Style.full
        formmater.timeStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Birthday.fetchRequest() as NSFetchRequest<Birthday>
        
        let sortDescriptorOne = NSSortDescriptor(key: "firstName", ascending: true)
        let sortDescriptorTwo = NSSortDescriptor(key: "lastName", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptorOne, sortDescriptorTwo]
        
        do {
            birthdayList = try context.fetch(fetchRequest)
        } catch let error {
            print("Не удалось сохранить из-за ошибки: \(error)")
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdayList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: birthdayCellIdentifier, for: indexPath)
        
        let birthday = birthdayList[indexPath.row]
        
        let firstName = birthday.firstName ?? ""
        
        let lastName = birthday.lastName ?? ""
        
        cell.textLabel?.text = firstName + " " + lastName
        
        if let date = birthday.dateOfBirth as Date? {
            cell.detailTextLabel?.text = formmater.string(from: date)
        } else {
            cell.detailTextLabel?.text = ""
        }
        
        if indexPath.row.isMultiple(of: 2) {
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.6899557249, blue: 0.9783657575, alpha: 1)
            return cell
        } else {
            cell.backgroundColor = #colorLiteral(red: 0.8015632962, green: 0.9183090496, blue: 1, alpha: 1)
            return cell
        }
    }
    
    // MARK: - Delegate
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if birthdayList.count > indexPath.row {
            let birthday = birthdayList[indexPath.row]
            
            if let identifier = birthday.birthdayID {
                let centre = UNUserNotificationCenter.current()
                centre.removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(birthday)
            birthdayList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .middle)
        
        do {
            try context.save()
        } catch let error {
            print("Не удалось сохранить из-за ошибки: \(error)")
        }
            
        }
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
