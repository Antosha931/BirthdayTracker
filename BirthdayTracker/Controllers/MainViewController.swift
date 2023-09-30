//
//  MainViewController.swift
//  BirthdayTracker
//
//  Created by Антон Титов on 24.09.2023.
//

import UIKit
import SnapKit
import CoreData

final class MainViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var birthdayList = [Birthday]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        return tableView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupConstraints()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        receivingData()
    }
    
    // MARK: - Private methods
    
    private func setupConstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            
        }
    }
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BirthdayTableViewCell.self, forCellReuseIdentifier: Cell.birthdayTableViewCell.description)
    }
    
    private func receivingData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
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
    
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableView data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return birthdayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.customDequeueReusableCell(withNameCell: .birthdayTableViewCell, for: indexPath)
                as? BirthdayTableViewCell else { return UITableViewCell() }
        
        cell.configureCell(birthday: birthdayList[indexPath.row])
        
        if indexPath.row.isMultiple(of: 2) {
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.6899557249, blue: 0.9783657575, alpha: 1)
            return cell
        } else {
            cell.backgroundColor = #colorLiteral(red: 0.8015632962, green: 0.9183090496, blue: 1, alpha: 1)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
     }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if birthdayList.count > indexPath.row {
            let birthday = birthdayList[indexPath.row]
            
            if let identifier = birthday.birthdayID {
                let centre = UNUserNotificationCenter.current()
                centre.removePendingNotificationRequests(withIdentifiers: [identifier])
            }
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
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
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
