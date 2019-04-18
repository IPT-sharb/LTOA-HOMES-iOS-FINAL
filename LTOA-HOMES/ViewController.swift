//
//  ViewController.swift
//  LTOA-HOMES
//
//  Created by Stephen Harb on 4/17/19.
//  Copyright © 2019 Stephen Harb. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginFailed: UILabel!
    
    var loginReturn: String?
    
    var loginLevel: String?
    
    var loginName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        self.passwordTextField.isSecureTextEntry = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func submitButton(_ sender: Any) {
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/login"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let loginData: [String?: Any] = ["username": self.usernameTextField.text, "password": self.passwordTextField.text]
        let loginJson: Data
        do {
            loginJson = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.httpBody = loginJson
        } catch {
            print("Error: cannot create JSON from login data")
            return
        }
        
        exec(request: request, session: session)
        
        
        if(loginReturn == "Success")
        {
            if(loginLevel != "resident")
            {
                loginFailed.text = "This application only supports Residents."
            }
            else
            {
                self.performSegue(withIdentifier: "loginToMain" , sender: nil)
            }
        }
        else
        {
            loginFailed.text = "LOGIN FAILED: Username or Password is invalid."
        }
        
        
    }
    
    func exec(request: URLRequest, session: URLSession)
    {
        let sem = DispatchSemaphore.init(value: 0)
        let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
            let json = try? JSONSerialization.jsonObject(with: (data ?? nil)!, options: []) as! [String: AnyObject]
            let jsonBodyAuth = json?["Auth"] as? String
            let jsonBodyLevel = json?["userLevel"] as? String
            let jsonBodyMember = json?["memberName"] as? String
            self.loginReturn = jsonBodyAuth
            self.loginLevel = jsonBodyLevel
            self.loginName = jsonBodyMember
            print(self.loginLevel)
            print(self.loginName)
            sem.signal()
        }
        )
        task.resume()
        sem.wait()
        
    }
    @IBAction func newuserButton(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ViewControllerMain = segue.destination as? ViewControllerMain {
            print(loginReturn)
            print(loginName)            //viewControllerTwo.success = loginReturn
            //viewControllerTwo.user = self.userName.tex
            ViewControllerMain.Name = loginName
        }
    }
}

