//
//  AddBirthdayViewController.swift
//  BirthdayTracker
//
//  Created by Антон Титов on 09.01.2022.
//

import UIKit


protocol AddBirthdayViewControllerDelegate {
    
    func addBirthdayViewController(_ addBirthdayViewController: AddBirthdayViewController, didAddBirthday birthday: User)
}


class AddBirthdayViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    @IBOutlet weak var userBirthdayDatePicker: UIDatePicker!
    @IBOutlet weak var birthdayTextLabel: UILabel!
    
    var delegate: AddBirthdayViewControllerDelegate?
    
    var usersBirthdayList = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userBirthdayDatePicker.maximumDate = Date()
    }
    
    @IBAction func saveUserDataButton(_ sender: Any) {
        let userName = userNameTextField.text ?? ""
        let userLastName = userLastNameTextField.text ?? ""
        let userBirthday = userBirthdayDatePicker.date
        
        let newUserBirthday = User(name: userName, lastName: userLastName, dateOfBirth: userBirthday)
        delegate?.addBirthdayViewController(self, didAddBirthday: newUserBirthday)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
