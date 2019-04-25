//
//  ViewControllerSpecialInstructions.swift
//  LTOA-HOMES
//
//  Created by Stephen Harb on 4/22/19.
//  Copyright © 2019 Stephen Harb. All rights reserved.
//

import UIKit

class ViewControllerSpecialInstructions: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var loginName: String?
    var address: String?
    var special: String?
    
    @IBOutlet weak var specialInstructionsStaticText: UITextView!
    
    @IBOutlet weak var editSpecialInstructions: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        specialInstructionsStaticText.isEditable = false
        editSpecialInstructions.text = nil
        specialInstructionsStaticText.delegate = self
        searchSpecialInstructions()
        specialInstructionsStaticText.text = special
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "trueBG.png")!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func homeFromSpecialInstructions(_ sender: Any) {
        self.performSegue(withIdentifier: "specialInstructionsHome" , sender: nil)
    }
    
    func execSearch(request: URLRequest, session: URLSession)
    {
        let sem = DispatchSemaphore.init(value: 0)
        let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
            let json = try? JSONSerialization.jsonObject(with: (data ?? nil)!, options: []) as! [String: AnyObject]
            let stringPass = json?["specialInstructions"] as? String
            self.special = stringPass
            sem.signal()
        }
        )
        task.resume()
        sem.wait()
    }
    
    func searchSpecialInstructions()
    {
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/member/instructions/search"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/text; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let loginData: [String?: Any] = ["Address": self.address]
        let loginJson: Data
        do {
            loginJson = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.httpBody = loginJson
        } catch {
            print("Error: cannot create JSON from login data")
            return
        }
        
        execSearch(request: request, session: session)
    }
    
    @IBAction func submitSpecialButton(_ sender: Any) {
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/member/special-instructions/add"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/text; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let loginData: [String?: Any] = ["memberAddress": self.address, "specialInstructions": self.editSpecialInstructions.text]
        let loginJson: Data
        do {
            loginJson = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.httpBody = loginJson
        } catch {
            print("Error: cannot create JSON from login data")
            return
        }
        
        execAdd(request: request, session: session)
        self.performSegue(withIdentifier: "submitSpecialInstructions" , sender: nil)
    }
    
    func execAdd(request: URLRequest, session: URLSession)
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
        }

    }
    
}
