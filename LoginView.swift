
//
//  Created by sina on 13.10.2024.


import SwiftUI


struct LoginView: View {

    @StateObject var userModel = LoginVM()
    @State private var isSecured: Bool = true

    var body: some View {
        NavigationStack {
            VStack {
                HeaderView()
                    .padding(.top, 100)

                Form {

                    TextField("Email:", text: $userModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)


                    HStack {
                        Group {
                            if isSecured {
                                SecureField("Password", text: $userModel.password)
                            } else {
                                TextField("Password", text: $userModel.password)
                            }
                        }

                        Button(action: {
                            isSecured.toggle()
                        }) {
                            Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                .accentColor(.gray)
                        }
                    }
                    Button(action: {
                        userModel.login()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color.blue)
                                .frame(height: 50)
                            Text("Login")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        if let combinedErrors = combinedErrors, !combinedErrors.isEmpty {
                            Text(combinedErrors)
                                .foregroundColor(.red)
                                .font(.caption)
                                .multilineTextAlignment(.leading)

                                .listRowSeparator(.hidden)

                        }
                    }

                    .padding(.top, 20)
                }

                .frame(height: 300)
                .cornerRadius(10)

                Spacer()

                VStack {
                    Text("Are you NEW?")
                        .font(.subheadline)
                    NavigationLink("Create new Account", destination: RegisterView())
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 50)
        }
    }

    private var combinedErrors: String? {
        var errors = [String]()

        if !userModel.emailError.isEmpty {
            errors.append(userModel.emailError)
        }

        if !userModel.passwordError.isEmpty {
            errors.append(userModel.passwordError)
        }

        if !userModel.loginError.isEmpty {
            errors.append(userModel.loginError)
        }

        return errors.isEmpty ? nil : errors.joined(separator: "\n")
    }

}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

