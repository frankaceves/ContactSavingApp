//
//  ContactFetchingTests.swift
//  ContactSavingAppTests
//
//  Created by Frank Aceves on 7/8/22.
//

import XCTest
import Contacts
@testable import ContactSavingApp

class ContactFetchingTests: XCTestCase {
    var sut: CNMutableContact!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    func makeSut() -> CNMutableContact {
        let tempUser = User(firstName: "Anna", lastName: "Haro", email: "anna-haro@mac.com")
        let tempContact = CNMutableContact()
        tempContact.givenName = tempUser.firstName
        tempContact.familyName = tempUser.lastName
        let homeEmail = CNLabeledValue(label: CNLabelHome, value: tempUser.email as NSString)
        tempContact.emailAddresses = [homeEmail]
        
        return tempContact
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func testSearchForExistingContactFamilyNameResultsInNonEmptyResult() throws {
        sut = makeSut()
        let store = CNContactStore()
        do {
            let predicate = CNContact.predicateForContacts(matchingName: sut.familyName)
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
            print(contacts)
            
            XCTAssertTrue(!contacts.isEmpty)
        } catch {
            print(error.localizedDescription)
        }
    }
    func testEnteringDuplicateFirstNameOrLastNameYieldsError() throws {
        sut = makeSut()
        XCTAssertEqual(sut.isDuplicateContact(), true)
    }
}

extension ContactFetchingTests {
}
extension CNMutableContact {
    func isDuplicateContact() -> Bool {
        let store = CNContactStore()
        do {
            let predicate = CNContact.predicateForContacts(matchingName: self.familyName)
            let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey] as [CNKeyDescriptor]
            let expectedContact = try store.unifiedContacts(matching: predicate, keysToFetch: keys).filter({ contact in
                contact.givenName == self.givenName && self.familyName == contact.familyName
            })
            
            return expectedContact.count > 1
        } catch {
            print(error.localizedDescription)
            //did not show up, return false = not duplicateContact
            return false
        }
    }
}
