//
//  Created by sina on 14.10.2024.

import SwiftUI

struct RegisterView: View {

    @StateObject private var viewModel = RegisterVM()
    @State private var isSecured: Bool = true
    @State private var isCheckSecured: Bool = true

    var body: some View {
        NavigationStack {
            VStack {
                HeaderView()

                Form {
                    Section(header: Text("Register :")) {
                        VStack(alignment: .leading) {
                            TextField("Name:", text: $viewModel.name)
                                .autocorrectionDisabled()
                                .autocapitalization(.words)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(5)

                            if !viewModel.nameError.isEmpty {
                                Text(viewModel.nameError)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }

                        VStack(alignment: .leading) {
                            TextField("Email:", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding()
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(5)

                            if !viewModel.emailError.isEmpty {
                                Text(viewModel.emailError)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }

                        VStack(alignment: .leading) {
                            HStack {
                                if isSecured {
                                    SecureField("Password", text: $viewModel.password)
                                } else {
                                    TextField("Password", text: $viewModel.password)
                                }

                                Button(action: {
                                    isSecured.toggle()
                                }) {
                                    Image(systemName: self.isSecured ? "eye.slash" : "eye")
                                        .accentColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(5)

                            if !viewModel.passwordError.isEmpty {
                                Text(viewModel.passwordError)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }

                        VStack(alignment: .leading) {
                            HStack {
                                if isCheckSecured {
                                    SecureField("Confirm Password", text: $viewModel.checkPassword)
                                } else {
                                    TextField("Confirm Password", text: $viewModel.checkPassword)
                                }

                                Button(action: {
                                    isCheckSecured.toggle()
                                }) {
                                    Image(systemName: self.isCheckSecured ? "eye.slash" : "eye")
                                        .accentColor(.gray)
                                }
                            }
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(5)

                            if !viewModel.checkPasswordError.isEmpty {
                                Text(viewModel.checkPasswordError)
                                    .foregroundColor(.red)
                                    .font(.caption)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .frame(height: 430)

                Button(action: {
                    viewModel.register()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.blue)
                            .frame(height: 50)
                        if viewModel.isRegistering {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Register")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    }
                }
                .disabled(viewModel.isRegistering)
                .padding(.top, 20)

                if viewModel.registrationSuccess {
                    Text("Kayıt başarılı! Giriş yapabilirsiniz.")
                        .foregroundColor(.green)
                        .padding(.top, 10)
                }

                if !viewModel.registrationError.isEmpty {
                    Text(viewModel.registrationError)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()

                VStack {
                    Text("")
                    NavigationLink("Log In", destination: LoginView())
                }
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
            .background(Color.white) 
        }
    }

    struct RegisterView_Previews: PreviewProvider {
        static var previews: some View {
            RegisterView()
        }
    }
}
