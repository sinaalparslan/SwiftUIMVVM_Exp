
//
//  Created by sina on 13.10.2024.
//

// LoginViewModel.swift

import SwiftUI
import Combine

class LoginVM: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""

    @Published var emailError: String = ""
    @Published var passwordError: String = ""

    @Published var isLoggingIn: Bool = false
    @Published var loginSuccess: Bool = false
    @Published var loginError: String = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        $email
            .sink { [weak self] _ in
                self?.validateEmail()
            }
            .store(in: &cancellables)

        $password
            .sink { [weak self] _ in
                self?.validatePassword()
            }
            .store(in: &cancellables)
    }

    func validateEmail() {
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            emailError = "Email alanı boş olamaz."
        } else if !isValidEmail(email) {
            emailError = "Geçerli bir email adresi girin."
        } else {
            emailError = ""
        }
    }

    func validatePassword() {
        if password.isEmpty {
            passwordError = "Şifre alanı boş olamaz."
        } else {
            passwordError = ""
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }

    func login() {
        validateEmail()
        validatePassword()

        guard emailError.isEmpty,
              passwordError.isEmpty else {
            return
        }

        isLoggingIn = true
        loginError = ""

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let authenticated = ConstantManager.shared.authenticate(email: self.email, password: self.password)
            DispatchQueue.main.async {
                self.isLoggingIn = false
                if authenticated {
                    self.loginSuccess = true
                } else {
                    self.loginError = "Email veya şifre yanlış."
                }
            }
        }
    }
}

