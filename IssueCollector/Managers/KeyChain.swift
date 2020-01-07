//
//  KeyChain.swift
//  IssueCollector
//
//  Created by Suhaib on 07/01/2020.
//  Copyright © 2020 Suhaib Al Saghir. All rights reserved.
//

import Foundation

class KeyChain {
    
    enum Key: String {
        case accessToken
        case refreshToken
    }

    func save(key: String, data: Data) -> OSStatus {
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data ] as [String : Any]

        SecItemDelete(query as CFDictionary)

        return SecItemAdd(query as CFDictionary, nil)
    }

    func load(key: String) -> Data? {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue!,
            kSecMatchLimit as String  : kSecMatchLimitOne ] as [String : Any]

        var dataTypeRef: AnyObject? = nil

        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            return dataTypeRef as! Data?
        } else {
            return nil
        }
    }

    class func createUniqueID() -> String {
        let uuid: CFUUID = CFUUIDCreate(nil)
        let cfStr: CFString = CFUUIDCreateString(nil, uuid)

        let swiftString: String = cfStr as String
        return swiftString
    }
    
    func getRefreshToken() -> String? {
        if let refreshTokenData = self.load(key: Key.refreshToken.rawValue) {
            return String.init(data: refreshTokenData, encoding: .utf8)
        } else {
            return nil
        }
    }

    func save(accessToken: String, refreshToken: String?) {
        guard let accessTokenData = accessToken.data(using: .utf8) else { return }
        let _ = save(key: KeyChain.Key.accessToken.rawValue,
                     data: accessTokenData)

        if let refreshToken = refreshToken,
            let refreshTokenData = refreshToken.data(using: .utf8) {
            let _ = save(key: KeyChain.Key.refreshToken.rawValue,
                         data: refreshTokenData)
        }
    }
}

extension Data {

    init<T>(from value: T) {
        var value = value
        self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}
