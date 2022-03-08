//
//  ViewController.swift
//  KeyChain
//
//  Created by M3ts LLC on 3/7/22.
//

import UIKit
import Security

class LoginViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var lblPassword: UITextField!
    @IBOutlet weak var lblUsername: UITextField!
    
    // MARK: - Properties
    let keychain = KeychainManager.shared
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        keychain.initData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keychain.retrievingItem()
        lblPassword.text = keychain.passwordString
        lblUsername.text = keychain.username
    }
    
    // MARK: - Actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        keychain.getUsernameAndPassword(strUserName: lblUsername.text ?? "", password: lblPassword.text ?? "")
        keychain.addUser()
        lblPassword.text = ""
        lblUsername.text = ""
    }
    
    @IBAction func getData(_ sender: Any) {
        print("getData")
        keychain.getUsernameAndPassword(strUserName: lblUsername.text ?? "", password: lblPassword.text ?? "")
        keychain.retrievingItem()
        lblPassword.text = keychain.passwordString
        lblUsername.text = keychain.username
    }
    
    @IBAction func updateData(_ sender: Any) {
        keychain.getUsernameAndPassword(strUserName: lblUsername.text ?? "", password: lblPassword.text ?? "")
        if let newPassword = keychain.passwordString  {
            keychain.updatingItem(newPassword: newPassword)
            lblPassword.text = keychain.passwordString
            lblUsername.text = keychain.username
        }
    }
    
    @IBAction func deleteData(_ sender: Any) {
        keychain.getUsernameAndPassword(strUserName: lblUsername.text ?? "", password: lblPassword.text ?? "")
        keychain.deleteItem(userName: keychain.username ?? "")
        lblPassword.text = keychain.passwordString
        lblUsername.text = keychain.username
    }
}

