//
//  ViewControllerAddGuest.swift
//  LTOA-HOMES
//
//  Created by Stephen Harb on 4/20/19.
//  Copyright © 2019 Stephen Harb. All rights reserved.
//

import UIKit

class ViewControllerAddGuest: UIViewController, UITextFieldDelegate {
    
    var loginName: String?
    var address: String?

    @IBOutlet weak var guestNameText: UITextField!
    
    @IBOutlet weak var guestReasonText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func homeAddGuest(_ sender: Any) {
        self.performSegue(withIdentifier: "addGuestToMain" , sender: nil)
    }
    
    @IBAction func submitAddGuest(_ sender: Any) {
        
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/guest/add"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/text; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let loginData: [String?: Any] = ["guestName": self.guestNameText.text, "reason": self.guestReasonText.text, "residentAddress": self.address]
        let loginJson: Data
        do {
            loginJson = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.httpBody = loginJson
        } catch {
            print("Error: cannot create JSON from login data")
            return
        }
        execGuest(request: request, session: session)
        sleep(2)
        self.performSegue(withIdentifier: "addGuestToGuest" , sender: nil)
        
    }
    
    func execGuest(request: URLRequest, session: URLSession)
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
    
    if let ViewControllerGuests = segue.destination as? ViewControllerGuests {
        ViewControllerGuests.loginName = loginName
        ViewControllerGuests.address = address
    }
    }
}
