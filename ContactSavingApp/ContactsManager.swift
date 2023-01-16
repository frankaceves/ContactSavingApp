//
//  ContactsManager.swift
//  ContactSavingApp
//
//  Created by Frank Aceves on 7/7/22.
//

import Contacts

enum ContactSaveError: Error {
    case contactAlreadyExists
    case unableToSave
    case notAuthorized
    case accessError
}

class ContactsManager {
    var delegate: AlertDelegate?
    //used to check auth status
    func checkStatus() -> CNAuthorizationStatus {
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        return status
    }
    //determine which action to take
    func handleEventBasedOnStatus(with user: User) {
        switch checkStatus() {
        case .notDetermined:
            CNContactStore().requestAccess(for: CNEntityType.contacts) { success, error in
                guard error == nil else {
                    self.delegate?.showUpdateAlert(title: "ERROR", message: error!.localizedDescription, style: .alert)
                    return
                }
                guard success else {
                    self.delegate?.showUpdateAlert(title: "No Access", message: "request for access did not return success", style: .alert)
                    return
                }
                //this gets called only when authorized
                self.save(user: user)
            }
        case .authorized:
            self.save(user: user)
        default:
            delegate?.showUpdateAlert(title: "Not Authorized", message: "You have not allowed permissions for adding contacts.  Please go to your settings and allow.", style: .alert)
        }
    }
    func save(user: User) {
        //create a contact, then check if it exists
        let contact = CNMutableContact()
        contact.givenName = user.firstName
        contact.familyName = user.lastName
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: user.email as NSString)
        contact.emailAddresses = [homeEmail]
        
        //check if contact exists via fetch contacts
        //TODO: CHECK FOR EXISTING CONTACT - show error alert if existing
        //scenarios where contact exists - same firstName, same lastName, same email, same anything really
        let store = CNContactStore()
        
        
        // save to contacts and show alert when complete
        let request = CNSaveRequest()
        request.add(contact, toContainerWithIdentifier: nil)
        
        do {
            try store.execute(request)
            self.delegate?.showUpdateAlert(title: "SUCCESS!", message: "You have added a new contact for \(user.firstName) \(user.lastName)", style: .alert)
        } catch {
            print(error.localizedDescription)
            self.delegate?.showUpdateAlert(title: "ERROR", message: "There was an error trying to save contact for \(user.firstName) \(user.lastName)", style: .alert)
        }
    }
    
    
}
