//
//  LoginViewController.swift
//  ShiftSync
//
//  Created by Nidhi Khanpara on 2023-12-24.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var btnGoToSignUp: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var lblLogin: UILabel!
    @IBOutlet weak var detailsBackView: UIView!
    var loginData: LoginModel?
    var userName = ""
    var Pass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        emailTxtField.borderStyle = .none
        passwordTxtField.borderStyle = .none
        emailTxtField.addUnderline(color: UIColor.lightGray)
        passwordTxtField.addUnderline(color: UIColor.lightGray)
        
        hideKeyboardWhenTappedAround()
        detailsBackView.roundCorners(corners: [.topLeft, .topRight , .bottomLeft , .bottomRight], radius: 30.0)
        btnLogin.layer.cornerRadius = 10
        btnLogin.addShadow(color: UIColor.black, opacity: 0.5, offset: CGSize(width: 0, height: 4), radius: 4.0)
      

        DispatchQueue.main.async {
            self.btnGoToSignUp.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
            self.btnGoToSignUp.titleLabel?.textAlignment = .center
        }
    }
    
    func GetLoginDetails() {
        
           userName = emailTxtField.text ?? ""
           Pass = passwordTxtField.text ?? ""
            let urlString = "http://127.0.0.1:5000/login?username=\(userName)&password=\(Pass)"
            print(urlString)
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let data = data {
                    do {
                        let jsonString = String(data: data, encoding: .utf8)
                        print("JSON String: \(jsonString ?? "")")
                        
                        let decoder = JSONDecoder()
                        let jsonData = try decoder.decode(LoginModel.self, from: data)
                        print("Decoded Data: \(jsonData)")
                        
                        DispatchQueue.main.async {
                            self.loginData = jsonData
                            self.pushViewController(controllerID: .ViewController, storyBoardID: .Main)
                            self.navigationController?.view.makeToast("Welcome \(self.userName)", duration: 3.0, position: .bottom)
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


    @IBAction func didTapOnLoginBtn(_ sender: UIButton) {
       GetLoginDetails()
    }
    
    @IBAction func didTapOnSignUpButton(_ sender: UIButton) {
        
        self.pushViewController(controllerID: .SignUpViewController, storyBoardID: .Main)
    }
    
}
