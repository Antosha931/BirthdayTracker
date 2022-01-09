//
//  BirthdayListTableViewController.swift
//  BirthdayTracker
//
//  Created by Антон Титов on 09.01.2022.
//

import UIKit

class BirthdayListTableViewController: UITableViewController, AddBirthdayViewControllerDelegate {
    
    let reuseIdentifier = "reuseIdentifier"
    
    var birthdayList = [User]()
    
    let formmater = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        formmater.dateStyle = DateFormatter.Style.full
        formmater.timeStyle = .none
        
        self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdayList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let birthday = birthdayList[indexPath.row]
        
        cell.textLabel?.text = birthday.name + " " + birthday.lastName
        
        cell.detailTextLabel?.text = formmater.string(from: birthday.dateOfBirth)

        return cell
    }
    
    // MARK: - Delegate
    
    func addBirthdayViewController(_ addBirthdayViewController: AddBirthdayViewController, didAddBirthday birthday: User) {
        birthdayList.append(birthday)
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as? UINavigationController
        let addBirthdayViewController = navigationController?.topViewController as? AddBirthdayViewController
        addBirthdayViewController?.delegate = self
    }
}
