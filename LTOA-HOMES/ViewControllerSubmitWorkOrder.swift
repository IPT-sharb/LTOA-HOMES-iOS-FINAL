//
//  ViewControllerSubmitWorkOrder.swift
//  LTOA-HOMES
//
//  Created by Stephen Harb on 4/21/19.
//  Copyright © 2019 Stephen Harb. All rights reserved.
//

import UIKit

class ViewControllerSubmitWorkOrder: UIViewController, UITextFieldDelegate,UIPickerViewDataSource, UIPickerViewDelegate {
   
    var loginName: String?
    var address: String?
    var pickedValue: String?
    
    var typeList = ["Light Fixture", "Drainage", "Street Cleanup"]
    
    @IBOutlet weak var notesText: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    @IBAction func homeButton(_ sender: Any) {
        self.performSegue(withIdentifier: "submitWorkOrderToHome" , sender: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        self.view.endEditing(true)
        pickedValue = typeList[row]
        return typeList[row]
        
    }
    
    
    
    
    @IBAction func submitWorkOrderButton(_ sender: Any) {
        
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/work/add"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/text; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let loginData: [String?: Any] = ["workType": pickedValue, "ResponsibleManager": "Paul/Leslie", "Status": "pending", "Notes": notesText.text, "Address": self.address]
        let loginJson: Data
        do {
            loginJson = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.httpBody = loginJson
        } catch {
            print("Error: cannot create JSON from login data")
            return
        }
        execWork(request: request, session: session)
        
        sleep(2)
        
        self.performSegue(withIdentifier: "submitWorkOrderToWorkOrder" , sender: nil)
    }
    
    func execWork(request: URLRequest, session: URLSession)
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
        if let ViewControllerWorkOrders = segue.destination as? ViewControllerWorkOrders {
            ViewControllerWorkOrders.loginName = loginName
            ViewControllerWorkOrders.address = address
        }
    }}
