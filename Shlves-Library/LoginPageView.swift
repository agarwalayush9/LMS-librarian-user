import SwiftUI
import FirebaseAuth

struct LoginPageView: View {
    @Binding var isLoggedIn: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var rememberMe: Bool = false
    @State private var navigateToRegister = false
    
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    // Real-time validation state
    @State private var isEmailValid = true
    @State private var isPasswordValid = true
    @State private var passwordLengthValid = false
    @State private var passwordUppercaseValid = false
    @State private var passwordLowercaseValid = false
    @State private var passwordNumberValid = false
    @State private var passwordSpecialCharValid = false
    
    var body: some View {
        HStack {
            if navigateToRegister {
                RegisterPage(isLoggedIn: $isLoggedIn)
            } else {
                // Left side image
                Image("librarian")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Right side form
                VStack(alignment: .leading, spacing: 20) {
                    // Logo and title
                    HStack {
                        Image("Logo")
                            .resizable()
                            .frame(width: 36.75, height: 37.5)
                        Text("Shelves")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                    }
                    
                    Text("Librarian Log in")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                    
                    Text("Welcome back Librarian! Please enter your details.")
                        .foregroundColor(Color(red: 0.4, green: 0.2, blue: 0.1))
                    
                    // Email field
                    Text("Email")
                        .foregroundColor(Color.gray)
                    TextField("Enter your email", text: $email)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: email) { newValue in
                            validateEmail()
                        }
                        .border(isEmailValid ? Color.clear : Color.red, width: 1)
                    
                    if !isEmailValid {
                        Text("Invalid email format.")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    // Password field
                    Text("Password")
                        .foregroundColor(Color.gray)
                    SecureField("Enter your password", text: $password)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: password) { newValue in
                            validatePassword()
                        }
                        .border(isPasswordValid ? Color.clear : Color.red, width: 1)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Image(systemName: passwordLengthValid ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(passwordLengthValid ? .green : .red)
                            Text("Minimum 8 characters")
                                .foregroundColor(passwordLengthValid ? .green : .red)
                                .font(.caption)
                        }
                        HStack {
                            Image(systemName: passwordUppercaseValid ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(passwordUppercaseValid ? .green : .red)
                            Text("At least 1 uppercase letter")
                                .foregroundColor(passwordUppercaseValid ? .green : .red)
                                .font(.caption)
                        }
                        HStack {
                            Image(systemName: passwordLowercaseValid ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(passwordLowercaseValid ? .green : .red)
                            Text("At least 1 lowercase letter")
                                .foregroundColor(passwordLowercaseValid ? .green : .red)
                                .font(.caption)
                        }
                        HStack {
                            Image(systemName: passwordNumberValid ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(passwordNumberValid ? .green : .red)
                            Text("At least 1 number")
                                .foregroundColor(passwordNumberValid ? .green : .red)
                                .font(.caption)
                        }
                        HStack {
                            Image(systemName: passwordSpecialCharValid ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(passwordSpecialCharValid ? .green : .red)
                            Text("At least 1 special character")
                                .foregroundColor(passwordSpecialCharValid ? .green : .red)
                                .font(.caption)
                        }
                    }
                    
                    if !isPasswordValid {
                        Text("Password must meet all criteria.")
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    // Forgot password
                    HStack {
                        Button(action: {
                            // Forgot password action
                        }) {
                            Text("Forgot password ?")
                                .foregroundColor(Color.blue)
                        }
                    }
                    
                    // Sign in button
                    Button(action: {
                        guard validateFields() else {
                            showAlert = true
                            return
                        }
                        login()
                        print("Sign in with email: \(email), password: \(password)")
                    }) {
                        Text("Sign in")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.4, green: 0.2, blue: 0.1))
                            .cornerRadius(8)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Invalid Credentials"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    // Register button
                    Button(action: {
                        navigateToRegister = true
                    }) {
                        Text("Register")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .cornerRadius(8)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { firebaseResult, error in
            if let e = error {
                errorMessage = e.localizedDescription
                showAlert = true
                print(e)
            } else {
                print("Login successful")
                isLoggedIn = true
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
            }
        }
    }
    
    private func validateFields() -> Bool {
        if email.isEmpty || !isEmailValid {
            errorMessage = "Please enter a valid email."
            return false
        }
        
        if password.isEmpty || !isPasswordValid {
            errorMessage = "Please enter a valid password."
            return false
        }
        
        return true
    }
    
    private func validateEmail() {
        isEmailValid = isValidEmail(email)
    }
    
    private func validatePassword() {
        let passwordRegex = [
            ("^(?=.*[A-Z]).{1,}$", $passwordUppercaseValid), // Uppercase letter
            ("^(?=.*[a-z]).{1,}$", $passwordLowercaseValid), // Lowercase letter
            ("^(?=.*\\d).{1,}$", $passwordNumberValid), // Digit
            ("^(?=.*[#$^+=!*()@%&]).{1,}$", $passwordSpecialCharValid), // Special character
            (".{8,}", $passwordLengthValid) // Length of at least 8
        ]
        
        for (regex, validation) in passwordRegex {
            let pred = NSPredicate(format: "SELF MATCHES %@", regex)
            validation.wrappedValue = pred.evaluate(with: password)
        }
        
        isPasswordValid = passwordLengthValid && passwordUppercaseValid && passwordLowercaseValid && passwordNumberValid && passwordSpecialCharValid
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "^(?=.{1,64}@.{4,64}$)(?=.{6,100}$)[A-Za-z0-9](?:[A-Za-z0-9._%+-]*[A-Za-z0-9])?@[A-Za-z0-9](?:[A-Za-z0-9.-]*[A-Za-z0-9])?\\.[A-Za-z]{2,64}$"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView(isLoggedIn: .constant(false))
    }
}
