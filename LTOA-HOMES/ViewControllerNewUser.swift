//
//  ViewControllerNewUser.swift
//  LTOA-HOMES
//
//  Created by Stephen Harb on 4/20/19.
//  Copyright © 2019 Stephen Harb. All rights reserved.
//

import UIKit

class ViewControllerNewUser: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var memberNameText: UITextField!
    @IBOutlet weak var memberAddressText: UITextField!
    @IBOutlet weak var memberNumberText: UITextField!
    @IBOutlet weak var memberEmailText: UITextField!
    @IBOutlet weak var memberUserNameText: UITextField!
    @IBOutlet weak var memberPasswordText: UITextField!
    @IBOutlet weak var memberConfirmPasswordText: UITextField!
    
    
    @IBOutlet weak var confirmPasswordCheckLabel: UILabel!
    
    var loginName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberNameText.delegate = self
        memberAddressText.delegate = self
        memberEmailText.delegate = self
        memberNumberText.delegate = self
        memberUserNameText.delegate = self
        memberPasswordText.delegate = self
        memberConfirmPasswordText.delegate = self
        
        self.memberPasswordText.isSecureTextEntry = true
        self.memberConfirmPasswordText.isSecureTextEntry = true
        
        confirmPasswordCheckLabel.text = " "
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "trueBG.png")!)
    }
    
    @IBAction func newUserSubmitButton(_ sender: Any) {
        if(memberPasswordText.text != memberConfirmPasswordText.text)
        {
            confirmPasswordCheckLabel.text = "Passwords must match!"
        }
        else
        {
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/login/add"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/text; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let loginData: [String?: Any] = ["Name": self.memberNameText.text, "userLevel": "resident", "userName": self.memberUserNameText, "Password": self.memberPasswordText.text]
        let loginJson: Data
        do {
            loginJson = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.httpBody = loginJson
        } catch {
            print("Error: cannot create JSON from login data")
            return
        }
        execUser(request: request, session: session)
        updateMember()
        sleep(2)
        self.performSegue(withIdentifier: "submitNewUser" , sender: nil)
        }
    }
    
    func updateMember()
    {
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/member/update"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/text; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let loginData: [String?: Any] = ["contactNumber": self.memberNumberText.text, "email": self.memberEmailText.text]
        let loginJson: Data
        do {
            loginJson = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.httpBody = loginJson
        } catch {
            print("Error: cannot create JSON from login data")
            return
        }
        execUser(request: request, session: session)
    }
    
    func execUser(request: URLRequest, session: URLSession)
    {
        let sem = DispatchSemaphore.init(value: 0)
        let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
            sem.signal()
        }
        )
        task.resume()
        sem.wait()
    }
    
    
}
