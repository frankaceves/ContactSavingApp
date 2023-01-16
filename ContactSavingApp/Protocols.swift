//
//  Protocols.swift
//  ContactSavingApp
//
//  Created by Frank Aceves on 7/8/22.
//

import UIKit

protocol AlertDelegate {
    func showUpdateAlert(title: String, message: String, style: UIAlertController.Style)
}
