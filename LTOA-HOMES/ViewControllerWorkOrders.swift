//
//  ViewControllerWorkOrders.swift
//  LTOA-HOMES
//
//  Created by Stephen Harb on 4/20/19.
//  Copyright © 2019 Stephen Harb. All rights reserved.
//

import UIKit

class ViewControllerWorkOrders: UIViewController, UITextFieldDelegate {

    var loginName: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func homeWorkOrdersButton(_ sender: Any) {
        self.performSegue(withIdentifier: "workOrdersToMain" , sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ViewControllerMain = segue.destination as? ViewControllerMain {
            ViewControllerMain.Name = loginName
        }}
}
