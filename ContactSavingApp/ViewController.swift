//
//  ViewController.swift
//  ContactSavingApp
//
//  Created by Frank Aceves on 7/7/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    let contactsManager = ContactsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        contactsManager.delegate = self
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let firstName = firstNameTextField.text, !firstName.isEmpty, let lastName = lastNameTextField.text, !lastName.isEmpty, let email = emailTextField.text, !email.isEmpty else {
            showUpdateAlert(title: "ERROR", message: "Not enough info present to save contact", style: .alert)
            return
        }
        // set up user Struct with three items? needed?
        let tempUser = User(firstName: firstName, lastName: lastName, email: email)
        
        //check authorization status
        contactsManager.handleEventBasedOnStatus(with: tempUser)
    }
}
extension ViewController: AlertDelegate {
    func showUpdateAlert(title: String, message: String, style: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.dismiss(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
