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
    
    @IBOutlet weak var guestTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.guestTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        guestTableView.reloadData()
        guestTableView.delegate = self
        guestTableView.dataSource = self
        sendRequestGuestList()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.guestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.guestTableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = self.guestList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
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
            if(addresser == self.address )
            {
                self.guestList.append(stringPass!)
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
        }
        if let ViewControllerAddGuest = segue.destination as? ViewControllerAddGuest {
            ViewControllerAddGuest.loginName = loginName
        }
        if let ViewControllerRemoveGuest = segue.destination as? ViewControllerRemoveGuest {
            ViewControllerRemoveGuest.loginName = loginName
        }
        if let ViewControllerAddMultipleGuest = segue.destination as? ViewControllerAddMultipleGuest {
            ViewControllerAddMultipleGuest.loginName = loginName
        }
    }
    
}
