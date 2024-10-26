//
//  ConstantManager.swift
//  SwiftUIProject
//
//  Created by sina on 15.10.2024.
//

import Foundation

class ConstantManager {
    static let shared = ConstantManager()

    private(set) var users: [User] = []

    private init() {
        loadUsers()
    }

    func addUser(name: String, email: String, password: String) -> Bool {
        if users.contains(where: { $0.email.lowercased() == email.lowercased() }) {
            return false
        }

        let newUser = User(id: UUID().uuidString, name: name, email: email, password: password, joined: Date().timeIntervalSince1970)
        users.append(newUser)
        saveUsers()
        return true
    }

    func authenticate(email: String, password: String) -> Bool {
        return users.contains(where: { $0.email.lowercased() == email.lowercased() && $0.password == password })
    }

    private func saveUsers() {
        if let encoded = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(encoded, forKey: "users")
        }
    }

    private func loadUsers() {
        if let savedData = UserDefaults.standard.data(forKey: "users"),
           let decodedUsers = try? JSONDecoder().decode([User].self, from: savedData) {
            users = decodedUsers
        }
    }
}
