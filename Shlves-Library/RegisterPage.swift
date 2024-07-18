import SwiftUI
import FirebaseAuth
import FirebaseDatabase

struct RegisterPage: View {
    
    @State private var email: String = ""
    @State private var name: String = ""
    @State private var lastName: String = ""
    @State private var phoneNumber: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isRegistrationSuccessful = false
    @State private var showDashboard = false
    
    // Realtime validation state
    @State private var isNameValid = true
    @State private var isLastNameValid = true
    @State private var isEmailValid = true
    @State private var isPhoneNumberValid = true
    @State private var isNameDifferentFromLastName = true
    @State private var nameValidationMessage: String = ""
    @State private var lastNameValidationMessage: String = ""
    @State private var emailValidationMessage: String = ""
    @State private var phoneNumberValidationMessage: String = ""
    @State private var nameDifferentValidationMessage: String = ""
    
    // Constants for character limits
    let minNameLength = 3
    let maxNameLength = 50 // Adjust as needed
    let maxEmailLength = 100 // Maximum email length
    
    // Computed property to check if all fields are valid
    private var isValidForm: Bool {
        return isNameValid && isLastNameValid && isEmailValid && isPhoneNumberValid && isNameDifferentFromLastName
            && !name.isEmpty && !lastName.isEmpty && !email.isEmpty && !phoneNumber.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                HStack {
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
                                .foregroundColor(Color.loginPage)
                        }
                        
                        Text("Librarian Registration")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.loginPage)
                        
                        Text("Please enter your details.")
                            .foregroundColor(Color.loginPage)
                        
                        // First Name field
                        Text("First Name")
                            .foregroundColor(Color.mainFont)
                        TextField("Enter your First Name", text: $name)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .onChange(of: name, perform: { newValue in
                                validateName()
                                validateNamesAreDifferent()
                            })
                            .border(isNameValid ? Color.clear : Color.red, width: 1)
                        
                        Text(nameValidationMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                        
                        // Last Name field
                        Text("Last Name")
                            .foregroundColor(Color.mainFont)
                        TextField("Enter your Last Name", text: $lastName)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .onChange(of: lastName, perform: { newValue in
                                validateLastName()
                                validateNamesAreDifferent()
                            })
                            .border(isLastNameValid ? Color.clear : Color.red, width: 1)
                        
                        Text(lastNameValidationMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                        
                        // Email field
                        Text("Email")
                            .foregroundColor(Color.mainFont)
                        TextField("Enter your email", text: $email)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .keyboardType(.emailAddress)
                            .onChange(of: email, perform: { newValue in
                                validateEmail()
                            })
                            .border(isEmailValid ? Color.clear : Color.red, width: 1)
                        
                        Text(emailValidationMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                        
                        // Phone Number field
                        Text("Phone Number")
                            .foregroundColor(Color.mainFont)
                        TextField("Enter your number", text: $phoneNumber)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(8)
                            .keyboardType(.numberPad)
                            .onChange(of: phoneNumber, perform: { newValue in
                                validatePhoneNumber()
                            })
                            .border(isPhoneNumberValid ? Color.clear : Color.red, width: 1)
                        
                        Text(phoneNumberValidationMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                        
                        NavigationLink(destination: LoginPageView(), isActive: $isRegistrationSuccessful) {
                            EmptyView()
                        }
                        
                        Button(action: {
                            guard validateFields() else {
                                showAlert = true
                                return
                            }
                            
                            // Check if email is already in use
                            DataController.shared.isEmailAlreadyInUse(email: email) { exists in
                                if exists {
                                    // Email is already in use, show appropriate alert
                                    alertMessage = "Email is already in use by another user"
                                    showAlert = true
                                } else {
                                    // Proceed with registration
                                    let user = User(firstName: name, lastName: lastName, email: email, phoneNumber: Int(phoneNumber)!)
                                    
                                    DataController.shared.addUser(user) { result in
                                        switch result {
                                        case .success:
                                            print("Registration successful!")
                                            alertMessage = "Registration successful!"
                                            showAlert = true
                                            isRegistrationSuccessful = true
                                        case .failure(let error):
                                            alertMessage = error.localizedDescription
                                            showAlert = true
                                        }
                                    }
                                    
                                    self.showDashboard = true
                                }
                            }
                        }) {
                            Text("Register")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(isValidForm ? Color(red: 0.4, green: 0.2, blue: 0.1) : Color.gray)
                                .cornerRadius(8)
                        }
                        .disabled(!isValidForm) // Disable button when form is invalid
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                        
                        Text(nameDifferentValidationMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
        }
    }
    
    private func validateFields() -> Bool {
        if name.isEmpty || lastName.isEmpty || email.isEmpty || phoneNumber.isEmpty {
            alertMessage = "Please fill in all fields."
            return false
        }
        
        if !isNameValid || !isLastNameValid || !isEmailValid || !isPhoneNumberValid {
            alertMessage = "Please correct the invalid fields."
            return false
        }
        
        if !isNameDifferentFromLastName {
            alertMessage = "First name and last name cannot be the same."
            return false
        }
        
        return true
    }
    
    private func validateName() {
        isNameValid = isValidName(name)
        nameValidationMessage = isNameValid ? "" : "First name must be between \(minNameLength) and \(maxNameLength) characters and start with a capital letter."
    }
    
    private func validateLastName() {
        isLastNameValid = isValidLastName(lastName)
        lastNameValidationMessage = isLastNameValid ? "" : "Last name must be between \(minNameLength) and \(maxNameLength) characters and start with a capital letter."
    }
    
    private func validateEmail() {
        let isValidFormat = isValidEmail(email)
        let isValidLength = email.count > 0 && email.count <= maxEmailLength
        let isValidComponents = email.components(separatedBy: "@").count == 2
        
        if !isValidFormat {
            emailValidationMessage = "Invalid email format."
        } else if !isValidLength {
            emailValidationMessage = "Email length should be between 1 and \(maxEmailLength) characters."
        } else if !isValidComponents {
            emailValidationMessage = "Email should have exactly one '@' symbol."
        } else {
            emailValidationMessage = ""
        }
        
        isEmailValid = isValidFormat && isValidLength && isValidComponents
    }
    
    private func validatePhoneNumber() {
        isPhoneNumberValid = isValidPhoneNumber(phoneNumber)
        phoneNumberValidationMessage = isPhoneNumberValid ? "" : "Phone number must be 10 digits."
    }
    
    private func validateNamesAreDifferent() {
        isNameDifferentFromLastName = name.lowercased() != lastName.lowercased()
        nameDifferentValidationMessage = isNameDifferentFromLastName ? "" : "First name and last name cannot be the same."
    }
    
    private func isValidName(_ name: String) -> Bool {
        return name.count >= minNameLength && name.count <= maxNameLength && name.rangeOfCharacter(from: CharacterSet.letters) != nil && name.first?.isUppercase ?? false
    }
    
    private func isValidLastName(_ lastName: String) -> Bool {
        return lastName.count >= minNameLength && lastName.count <= maxNameLength && lastName.rangeOfCharacter(from: CharacterSet.letters) != nil && lastName.first?.isUppercase ?? false
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-z0-9!$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!$%&'*+/=?^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9_\\-]*[a-z0-9])?\\.)+[a-z]{2,}|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9_\\-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneNumberRegEx = "^[0-9]{10}$"
        let phoneNumberPred = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegEx)
        return phoneNumberPred.evaluate(with: phoneNumber)
    }
}

struct RegisterPage_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPage()
    }
}
