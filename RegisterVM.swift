// RegisterViewModel.swift



import SwiftUI
import Combine

class RegisterVM: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var checkPassword: String = ""

    @Published var nameError: String = ""
    @Published var emailError: String = ""
    @Published var passwordError: String = ""
    @Published var checkPasswordError: String = ""

    @Published var isRegistering: Bool = false
    @Published var registrationSuccess: Bool = false
    @Published var registrationError: String = ""

    private var cancellables = Set<AnyCancellable>()

    init() {
        $name
            .sink { [weak self] _ in
                self?.validateName()
            }
            .store(in: &cancellables)

        $email
            .sink { [weak self] _ in
                self?.validateEmail()
            }
            .store(in: &cancellables)

        $password
            .sink { [weak self] _ in
                self?.validatePassword()
                self?.validateCheckPassword()
            }
            .store(in: &cancellables)

        $checkPassword
            .sink { [weak self] _ in
                self?.validateCheckPassword()
            }
            .store(in: &cancellables)
    }

    func validateName() {
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            nameError = "İsim alanı boş olamaz."
        } else {
            nameError = ""
        }
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
        } else if password.count < 6 {
            passwordError = "Şifre en az 6 karakter olmalıdır."
        } else {
            passwordError = ""
        }
    }

    func validateCheckPassword() {
        if checkPassword.isEmpty {
            checkPasswordError = "Şifreyi tekrar girin."
        } else if checkPassword != password {
            checkPasswordError = "Şifreler eşleşmiyor."
        } else {
            checkPasswordError = ""
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.com"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return predicate.evaluate(with: email)
    }

    func register() {
        validateName()
        validateEmail()
        validatePassword()
        validateCheckPassword()

        guard nameError.isEmpty,
              emailError.isEmpty,
              passwordError.isEmpty,
              checkPasswordError.isEmpty else {
            return
        }

        isRegistering = true
        registrationError = ""

        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let success = ConstantManager.shared.addUser(name: self.name, email: self.email, password: self.password)
            DispatchQueue.main.async {
                self.isRegistering = false
                if success {
                    self.registrationSuccess = true
                } else {
                    self.registrationError = "Bu email zaten kayıtlı."
                }
            }
        }
    }
}

//        // Firebase Authentication ile kullanıcı oluşturma
//        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.isRegistering = false
//                if let error = error {
//                    self.registrationError = error.localizedDescription
//                    return
//                }
//
//                guard let userId = result?.user.uid else {
//                    self.registrationError = "Kullanıcı kimliği alınamadı."
//                    return
//                }
//
//                // Firestore'a kullanıcı kaydı ekleme
//                self.insertUserRecord(id: userId)
//            }
//        }


//    // Firestore'a Kullanıcı Kaydı Ekleme
//    private func insertUserRecord(id: String) {
//        let db = Firestore.firestore()
//        let newUser = User(id: id, name: name, email: email, joined: Date().timeIntervalSince1970)
//
//        do {
//            try db.collection("users").document(id).setData(from: newUser)
//            self.registrationSuccess = true
//        } catch {
//            self.registrationError = "Kullanıcı kaydı eklenirken bir hata oluştu: \(error.localizedDescription)"
//        }
//    }

