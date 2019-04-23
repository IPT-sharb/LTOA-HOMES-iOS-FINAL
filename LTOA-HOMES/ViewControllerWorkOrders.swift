//
//  ViewControllerWorkOrders.swift
//  LTOA-HOMES
//
//  Created by Stephen Harb on 4/20/19.
//  Copyright © 2019 Stephen Harb. All rights reserved.
//

import UIKit

class ViewControllerWorkOrders: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    var workOrderList: [String] = []
    var workOrderType: [String] = []
    var workOrderManager: [String] = []
    var workOrderStatus: [String] = []
    var loginName: String?
    var address: String?
    
    @IBOutlet weak var tableCells: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableCells.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableCells.reloadData()
        tableCells.delegate = self
        tableCells.dataSource = self
        
        sendRequestWorkOrderList()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workOrderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableCells.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        cell.textLabel?.text = self.workOrderList[indexPath.row] + " | " + self.workOrderType[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        let alertController = UIAlertController(title: "Responsible Manager: " +
            (workOrderManager[(indexPath.row)]), message: "Status: " + (workOrderStatus[(indexPath.row)]), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func sendRequestWorkOrderList()
    {
        var endpoint : String = "https://d1jq46p2xy7y8u.cloudfront.net/work/all"
        let url = URL(string: endpoint)
        var request = URLRequest(url: url!)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        request.httpMethod = "GET"
        
        execWork(request: request, session: session)
    }
    
    func execWork(request: URLRequest, session: URLSession)
    {
        let sem = DispatchSemaphore.init(value: 0)
        let task = session.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) in
            let json = try? JSONSerialization.jsonObject(with: (data ?? nil)!, options: []) as! [[String: AnyObject]]
            for(index, element) in (json?.enumerated())!
            {
                let stringPass = element["workId"] as? String
                let addresser = element["Address"] as? String
                let stringManager = element["ResponsibleManager"] as? String
                let stringStatus = element["Status"] as? String
                let stringType = element["workType"] as? String
                
                if(addresser == self.address )
                {
                    self.workOrderList.append(stringPass!)
                    self.workOrderType.append(stringType!)
                    self.workOrderStatus.append(stringStatus!)
                    self.workOrderManager.append(stringManager!)
                }
                
            }
            
            sem.signal()
        }
        )
        task.resume()
        sem.wait()
    }
    
    @IBAction func homeWorkOrdersButton(_ sender: Any) {
        self.performSegue(withIdentifier: "workOrdersToMain" , sender: nil)
    }
    
    @IBAction func submitGoButton(_ sender: Any) {
        self.performSegue(withIdentifier: "workOrderToSubmitWorkOrder" , sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ViewControllerMain = segue.destination as? ViewControllerMain {
            ViewControllerMain.Name = loginName
        }
        if let ViewControllerSubmitWorkOrder = segue.destination as? ViewControllerSubmitWorkOrder {
            ViewControllerSubmitWorkOrder.loginName = loginName
            ViewControllerSubmitWorkOrder.address = address
        }
    }
}
