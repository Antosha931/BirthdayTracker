//
//  AddBirthdayViewController.swift
//  BirthdayTracker
//
//  Created by Антон Титов on 09.01.2022.
//

import UIKit
import CoreData
import UserNotifications


class AddBirthdayViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    @IBOutlet weak var userBirthdayDatePicker: UIDatePicker!
    @IBOutlet weak var birthdayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userBirthdayDatePicker.maximumDate = Date()
    }
    
    func showAlert(message: String, completion: @escaping (UIAlertAction) -> Void) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: completion)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveUserDataButton(_ sender: Any) {
        let firstName = userNameTextField.text
        let lastName = userLastNameTextField.text
        let birthday = userBirthdayDatePicker.date
        
        if !firstName!.isEmpty || !lastName!.isEmpty {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let newBirthday = Birthday(context: context)
            newBirthday.firstName = firstName
            newBirthday.lastName = lastName
            newBirthday.dateOfBirth = birthday
            newBirthday.birthdayID = UUID().uuidString
            
            do {
                try context.save()
                let messageForUser = "Сегодня \(String(describing: firstName)) \(String(describing: lastName)) празднует свой День рождения!!! Не забудь поздравить 🎂"
                let content = UNMutableNotificationContent()
                content.body = messageForUser
                content.sound = UNNotificationSound.default
                
                var dateComponents = Calendar.current.dateComponents([.month, .day], from: birthday)
                dateComponents.hour = 8
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                if let identifier = newBirthday.birthdayID {
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    let center = UNUserNotificationCenter.current()
                    center.add(request, withCompletionHandler: nil)
                }
            } catch let error {
                print("Не удалось сохранить из-за ошибки: \(error)")
            }
            
            dismiss(animated: true, completion: nil)
        } else {
            showAlert(message: "Заполните одно из полей ввода имени Именниника!") {_ in
                    return
                }
            }
        }
    
    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "ru_RU")
        
        let textDate = formatter.string(from: sender.date)
        birthdayLabel.text = "Дата рождения: \(textDate)"
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
