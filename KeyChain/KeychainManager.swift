//
//  KeychainManager.swift
//  KeyChain
//
//  Created by M3ts LLC on 3/7/22.
//

import Foundation
import Security

class KeychainManager {
    // MARK: - Properties
    static let shared = KeychainManager()
    var username: String?
    var passwordData: Data?
    var passwordString: String?
    var attributes: [String: Any] = [:]
    
    // MARK: - Helper Functions
    private func setAttribues()  -> [String: Any] {
        guard let username = username,
              let passwordData = passwordData else {
                  return [:]
              }
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecValueData as String: passwordData,
        ]
        return attributes
    }
    
    func initData() {
        self.username = UserDefaults.standard.object(forKey: "keyUserName") as? String
    }
    
    func getUsernameAndPassword(strUserName: String, password: String) {
        username = strUserName
        passwordString = password
        passwordData = password.data(using: .utf8)!
    }
    
    // MARK: - CREATE FUNCTION
    func addUser() {
        attributes = setAttribues()
        if let defaultsUsername = UserDefaults.standard.object(forKey: "keyUserName") as? String {
            if username != defaultsUsername {
                deleteItem(userName: defaultsUsername)
            }
        }
        
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            print("User saved successfully in the keychain - AT \(#line) \(#function)")
            self.username = attributes[kSecAttrAccount as String] as? String
            self.passwordData = attributes[kSecAttrAccount as String] as? Data
            if let data = self.passwordData {
                self.passwordString  = String(decoding: data, as: UTF8.self)
            }
            UserDefaults.standard.set(username, forKey: "keyUserName")
        } else {
            self.username = nil
            self.passwordData = nil
            self.passwordString = nil
            print("Something went wrong trying to save the user in the keychain - AT \(#line) \(#function)")
        }
    }
    
    // MARK: - READ FUCNTION
    func retrievingItem() {
        if let username = UserDefaults.standard.object(forKey: "keyUserName") as? String {
            self.username = username
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: username,
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecReturnAttributes as String: true,
                kSecReturnData as String: true,
            ]
            var item: CFTypeRef?
            // Check if user exists in the keychain
            if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
                // Extract result
                if let existingItem = item as? [String: Any],
                   let username = existingItem[kSecAttrAccount as String] as? String,
                   let passwordData = existingItem[kSecValueData as String] as? Data,
                   let password = String(data: passwordData, encoding: .utf8) {
                    print("username : \(username) - AT \(#line) \(#function)")
                    print("password : \(password) - AT \(#line) \(#function)")
                    self.username = username
                    self.passwordData = passwordData
                    self.passwordString = password
                }
            } else {
                print("Something went wrong trying to find the user in the keychain - AT \(#line) \(#function)")
                self.username = nil
                self.passwordData = nil
                self.passwordString = nil
            }
        }
    }
    
    // MARK: - UPDATE FUNCTION
    func updatingItem(newPassword: String) {
        if let defaultsUsername = UserDefaults.standard.object(forKey: "keyUserName") as? String {
            if username == defaultsUsername {
                guard let username = username,
                      let newPasswordData = newPassword.data(using: .utf8) else {return}
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: username,
                ]
                print("query : \(query) - AT \(#line) \(#function)")
                print("query count: \(query.count) - AT \(#line) \(#function)")
                // Set attributes for the new password
                let attributes: [String: Any] = [kSecValueData as String: newPasswordData]
                // Find user and update
                if SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == noErr {
                    self.username = username
                    self.passwordData = newPasswordData
                    if let data = self.passwordData {
                        self.passwordString = String(decoding: data, as: UTF8.self)
                    }
                    print("Password has changed - AT \(#line) \(#function)")
                } else {
                    self.username = username
                    self.passwordData = nil
                    self.passwordString = nil
                    print("Something went wrong trying to update the password - AT \(#line) \(#function)")
                }
            } else {
                print("User changed user name, add new password - AT \(#line) \(#function)")
                addUser()
            }
        }
    }
    
    // MARK: - DELETE FUCTION
    func deleteItem(userName: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: userName,
        ]
        print("query : \(query)")
        print("query count: \(query.count)")
        // Find user and delete
        if SecItemDelete(query as CFDictionary) == noErr {
            print("User removed successfully from the keychain - AT \(#line) \(#function)")
            UserDefaults.standard.set(nil, forKey: "keyUserName")
            self.username = nil
            self.passwordData = nil
            self.passwordString = nil
        } else {
            print("Something went wrong trying to remove the user from the keychain - AT \(#line) \(#function)")
            self.username = userName
        }
    }
}
