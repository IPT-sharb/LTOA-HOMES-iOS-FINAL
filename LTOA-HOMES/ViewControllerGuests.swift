//
//  ViewControllerGuests.swift
//  LTOA-HOMES
//
//  Created by Stephen Harb on 4/19/19.
//  Copyright © 2019 Stephen Harb. All rights reserved.
//

import UIKit

class ViewControllerGuests: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var loginName: String?
    var address: String?
    
    var guestList: [String] = []
    var guestReasons: [String] = []
    var guestDates: [String] = []
    var guestAddress: [String] = []
    
    var tempAllowTimeString: String?
    var tempAllowEndString: String?
    
    var tempAddress: String?
    var tempReason: String?
    var tempGuestName: String?
    
    @IBOutlet weak var guestTableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "trueBG.png")!)
        guestTableView.delegate = self
        
        sendRequestGuestList()
        self.guestTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        guestTableView.dataSource = self
        self.loadData()
        
        var counter = 0
    }
    
    func loadData()
    {
        self.guestTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.guestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.guestTableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = self.guestList[indexPath.row]
        
        if(checkIfAllowed(dateEntry: guestDates[(indexPath.row)]))
        {
            cell.textLabel?.backgroundColor = UIColor.gray
        }
        else{
            cell.textLabel?.backgroundColor = UIColor.red
        }
        
        
        return cell
    }
    
    func checkIfAllowed(dateEntry: String) -> Bool
    {
        let calendar = Calendar.current
        let year_month_day = calendar.dateComponents([.year,.month,.day], from: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        var date = calendar.date(from: year_month_day)
        var oldDate = Date()
        
        if(dateEntry == "null")
        {
            return false;
        }
            
        oldDate = formatter.date(from: dateEntry)!
        
        let testInt = date?.compare(oldDate).rawValue
        
        if( testInt != -1)
        {
            print(testInt)
            return false;
        }
        
       print("test")
        return true;
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //   guestTableView.delegate = self
        
        if(checkIfAllowed(dateEntry: guestDates[(indexPath.row)]))
        {
            cell.textLabel?.backgroundColor = UIColor.gray
        }
        else{
            cell.textLabel?.backgroundColor = UIColor.red
        }
        
    //    self.guestTableView.reloadRows(at: [indexPath], with: .top)
        
    }
    
    func updateGuest(alert: UIAlertAction)
    {
        deleteGuest(guestNameDelete: tempGuestName)
        let formatter = DateFormatter()
        let calendar = Calendar.current
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        var date = Date()
        var oldDate = Date()
        var dateComponents = DateComponents()
        dateComponents.year = Calendar.current.component(.year, from: date)+1
        dateComponents.month = Calendar.current.component(.month, from: date)
        dateComponents.day = Calendar.current.component(.day, from: date)
        dateComponents.timeZone = NSTimeZone.local
        date = calendar.date(from: dateComponents)!
        tempAllowTimeString = formatter.string(from: oldDate)
        tempAllowEndString = formatter.string(from: date)
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/guest/add"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/text; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let loginData: [String?: Any] = ["guestName": tempGuestName, "reason": tempReason, "residentAddress": tempAddress, "allowedStartTime": tempAllowTimeString, "allowedEndTime": tempAllowEndString]
        let loginJson: Data
        do {
            loginJson = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.httpBody = loginJson
        } catch {
            print("Error: cannot create JSON from login data")
            return
        }
        execUpdateGuest(request: request, session: session)
    }
    
    func deleteGuest(guestNameDelete: String?)
    {
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/guest/delete"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/text; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let loginData: [String?: Any] = ["guestName": guestNameDelete]
        let loginJson: Data
        do {
            loginJson = try JSONSerialization.data(withJSONObject: loginData, options: [])
            request.httpBody = loginJson
        } catch {
            print("Error: cannot create JSON from login data")
            return
        }
        
        execUpdateGuest(request: request, session: session)
    }
    
    func execUpdateGuest(request: URLRequest, session: URLSession)
    {
        let sem = DispatchSemaphore.init(value: 0)
        let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
            sem.signal()
        }
        )
        task.resume()
        sem.wait()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.guestTableView.reloadData()
        print("You tapped cell number \(indexPath.row).")
        
        let alertController = UIAlertController(title: "Guest Allowed Entry End Date: ", message:
            guestDates[(indexPath.row)], preferredStyle: .alert)
        
        tempAddress = guestAddress[(indexPath.row)]
        tempReason = guestReasons[(indexPath.row)]
        tempGuestName = guestList[(indexPath.row)]
        
        alertController.addAction(UIAlertAction(title: "Reapprove", style: .default, handler: updateGuest ) )
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default) )
                                  
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func homeButton(_ sender: Any) {
        self.performSegue(withIdentifier: "guestToMain" , sender: nil)
    }
    @IBAction func addGuest(_ sender: Any) {
        self.performSegue(withIdentifier: "guestToAddGuest" , sender: nil)
    }
    @IBAction func addMultipleGuests(_ sender: Any) {
        self.performSegue(withIdentifier: "guestToMultipleGuest" , sender: nil)
    }
    @IBAction func removeGuest(_ sender: Any) {
        self.performSegue(withIdentifier: "guestToRemoveGuest" , sender: nil)
    }
    
    func sendRequestGuestList()
    {
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/guest/all"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        execGuest(request: request, session: session)
    }

func execGuest(request: URLRequest, session: URLSession)
{
    let sem = DispatchSemaphore.init(value: 0)
    let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
        let json = try? JSONSerialization.jsonObject(with: (data ?? nil)!, options: []) as! [[String: AnyObject]]
        for(index, element) in (json?.enumerated())!
        {
            let stringPass = element["guestName"] as? String
            let addresser = element["residentAddress"] as? String
            let stringReason = element["reason"] as? String
            let stringDate = element["allowedEndTime"] as? String
            let stringAddress = element["residentAddress"] as? String
            if(addresser == self.address )
            {
                self.guestList.append(stringPass!)
                self.guestReasons.append(stringReason!)
                self.guestDates.append(stringDate!)
                self.guestAddress.append(stringAddress!)
            }
        }
        
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
        }
        if let ViewControllerAddGuest = segue.destination as? ViewControllerAddGuest {
            ViewControllerAddGuest.loginName = loginName
            ViewControllerAddGuest.address = address
        }
        if let ViewControllerRemoveGuest = segue.destination as? ViewControllerRemoveGuest {
            ViewControllerRemoveGuest.loginName = loginName
            ViewControllerRemoveGuest.address = address
        }
        if let ViewControllerAddMultipleGuest = segue.destination as? ViewControllerAddMultipleGuest {
            ViewControllerAddMultipleGuest.loginName = loginName
            ViewControllerAddMultipleGuest.address = address
        }
    }
    
}
