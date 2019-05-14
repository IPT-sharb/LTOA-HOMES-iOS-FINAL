//
//  ViewControllerViolations.swift
//  LTOA-HOMES
//
//  Created by Stephen Harb on 4/20/19.
//  Copyright © 2019 Stephen Harb. All rights reserved.
//

import UIKit

class ViewControllerViolations: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    var loginName: String?
    var address: String?
    var violationList: [String] = []
    var violationType: [String] = []
    var violationManager: [String] = []
    var violationStatus: [String] = []
    var violationFine: [String] = []
    
    @IBOutlet weak var violationsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.violationsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        violationsTable.reloadData()
        violationsTable.delegate = self
        violationsTable.dataSource = self
        
        sendRequestViolationList()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "trueBG.png")!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.violationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.violationsTable.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = self.violationList[indexPath.row] + " | " + self.violationType[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        let alertController = UIAlertController(title: "Responsible Manager: " +
            (violationManager[(indexPath.row)]), message: "Fine: " + (violationFine[(indexPath.row)]) + " | Status: " + (violationStatus[(indexPath.row)]), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func sendRequestViolationList()
    {
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/violation/all"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        execViolation(request: request, session: session)
    }
    
    func execViolation(request: URLRequest, session: URLSession)
    {
        let sem = DispatchSemaphore.init(value: 0)
        let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
            let json = try? JSONSerialization.jsonObject(with: (data ?? nil)!, options: []) as! [[String: AnyObject]]
            for(index, element) in (json?.enumerated())!
            {
                let stringPass = element["ViolationId"] as? String
                let addresser = element["MemberAddress"] as? String
                let stringManager = element["ResponsibleManager"] as? String
                let stringFine = element["Fine"] as? String
                let stringStatus = element["Status"] as? String
                let stringType = element["ViolationType"] as? String
                
                if(addresser == self.address )
                {
                    self.violationList.append(stringPass!)
                    self.violationFine.append(stringFine!)
                    self.violationType.append(stringType!)
                    self.violationStatus.append(stringStatus!)
                    self.violationManager.append(stringManager!)
                }
                
            }
            
            sem.signal()
        }
        )
        task.resume()
        sem.wait()
    }
    
    @IBAction func homeViolationsButton(_ sender: Any) {
        self.performSegue(withIdentifier: "violationsToMain" , sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ViewControllerMain = segue.destination as? ViewControllerMain {
            ViewControllerMain.Name = loginName
            ViewControllerMain.Address = address
        }}
}
