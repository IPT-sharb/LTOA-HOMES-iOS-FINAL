//
//  ViewControllerPersonal.swift
//  LTOA-HOMES
//
//  Created by Stephen Harb on 4/18/19.
//  Copyright © 2019 Stephen Harb. All rights reserved.
//

import UIKit

class ViewControllerPersonal: UIViewController, UITextFieldDelegate  {
    
    @IBOutlet weak var memberNameText: UILabel!
    @IBOutlet weak var addressText: UILabel!
    @IBOutlet weak var numberText: UILabel!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    var loginName: String?
    var address: String?
    var number: String?
    var email: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberField.delegate = self
        emailField.delegate = self
        
        memberNameText.text = loginName
        addressText.text = address
        numberText.text = number
        emailText.text = email
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "trueBG.png")!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    @IBAction func homeButton(_ sender: Any) {
        self.performSegue(withIdentifier: "personalToMain" , sender: nil)
    }

    @IBAction func changeNuber(_ sender: Any) {
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/member/update"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let loginData: [String?: Any] = ["memberName": loginName, "contactNumber": numberField.text]
        let loginJson: Data
        do {
            loginJson = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.httpBody = loginJson
        } catch {
            print("Error: cannot create JSON from Member data")
            return
        }
        //continue exec function
        exec(request: request, session: session)
        numberText.text = numberField.text
        numberField.text = nil
    }
    @IBAction func changeEmail(_ sender: Any) {
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/member/update"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let loginData: [String?: Any] = ["memberName": loginName, "email": emailField.text]
        let loginJson: Data
        do {
            loginJson = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.httpBody = loginJson
        } catch {
            print("Error: cannot create JSON from Member data")
            return
        }
        
        exec(request: request, session: session)
        emailText.text = emailField.text
        emailField.text = nil
    }
    
    func exec(request: URLRequest, session: URLSession)
    {
        let sem = DispatchSemaphore.init(value: 0)
        let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
            sem.signal()
        }
        )
        task.resume()
        sem.wait()
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ViewControllerMain = segue.destination as? ViewControllerMain {
            ViewControllerMain.Name = loginName
            ViewControllerMain.Address = address
        }}
}
