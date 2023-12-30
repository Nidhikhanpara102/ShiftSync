//
//  SignUpViewController.swift
//  ShiftSync
//
//  Created by Nidhi Khanpara on 2023-12-21.
//

import UIKit

class SignUpViewController: UIViewController {
    var signUpData: SignUpDataModel?

    @IBOutlet weak var FirstNameTxtField: UITextField!
    @IBOutlet weak var lastNameTxtField: UITextField!
    @IBOutlet weak var userIdTxtField: UITextField!
    @IBOutlet weak var addressTxtField: UITextView!
    @IBOutlet weak var emailIdTxtField: UITextField!
    @IBOutlet weak var ageTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var confirmPassTxtField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        FirstNameTxtField.borderStyle = .none
        lastNameTxtField.borderStyle = .none
        userIdTxtField.borderStyle = .none
        emailIdTxtField.borderStyle = .none
        ageTxtField.borderStyle = .none
        passwordTxtField.borderStyle = .none
        confirmPassTxtField.borderStyle = .none
       
        
        FirstNameTxtField.addUnderline(color: .lightGray)
        lastNameTxtField.addUnderline(color: .lightGray)
        userIdTxtField.addUnderline(color: .lightGray)
        emailIdTxtField.addUnderline(color: .lightGray)
        ageTxtField.addUnderline(color: .lightGray)
        passwordTxtField.addUnderline(color: .lightGray)
        confirmPassTxtField.addUnderline(color: .lightGray)
     
        addressTxtField.layer.borderWidth = 1.5
        addressTxtField.layer.cornerRadius = 5
        addressTxtField.layer.borderColor = CGColor.init(red: 211/255, green: 219/255, blue: 222/255, alpha: 1.0)
        
        
        signUpButton.addShadow(color: UIColor.black, opacity: 0.5, offset: CGSize(width: 0, height: 4), radius: 4.0)

        signUpButton.layer.borderWidth = 2
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderColor = CGColor(red: 0/255, green: 31/255, blue: 63/255, alpha: 1.0)
    
//        APICalls(firstName: "Nidhi", lastName: "Khanpara", email: "Nidhikhanpara102@gmail.com", age: String(24), address: "Canada", username: "Nk102", password: "nk102")
        
       
    }
    
    func APICalls(firstName: String, lastName: String, email: String, age: String, address: String, username: String, password: String) {
        let urlString = "http://127.0.0.1:5000/signup"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "age": age,
            "address": address,
            "username": username,
            "password": password
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error encoding JSON: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            if let data = data {
                do {
                    let jsonString = String(data: data, encoding: .utf8)
                    print("JSON String: \(jsonString ?? "")")

                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(SignUpDataModel.self, from: data)

                    // Handle the decoded data as needed
                    print("Received data: \(jsonData)")
                    DispatchQueue.main.async {
                        self.pushViewController(controllerID: .ViewController, storyBoardID: .Main)
                        self.navigationController?.view.makeToast("Welcome \(self.FirstNameTxtField.text ?? "")", duration: 3.0, position: .bottom)
                    }
                    
                } catch {
                    print("Decoding Error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.navigationController?.view.makeToast("Something went wrong", duration: 3.0, position: .bottom)
                    }
                }
            }
        }

        task.resume()
    }
    
    
    @IBAction func didTapOnSignUpButton(_ sender: UIButton) {
        APICalls(firstName: FirstNameTxtField.text ?? "", lastName: lastNameTxtField.text ?? "", email: emailIdTxtField.text ?? "" , age: ageTxtField.text ?? "" , address: addressTxtField.text ?? "", username: userIdTxtField.text ?? "" , password: passwordTxtField.text ?? "")
    }
    

}



