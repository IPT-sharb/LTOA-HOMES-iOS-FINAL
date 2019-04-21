//
//  ViewControllerGuests.swift
//  LTOA-HOMES
//
//  Created by Stephen Harb on 4/19/19.
//  Copyright © 2019 Stephen Harb. All rights reserved.
//

import UIKit

class ViewControllerGuests: UIViewController, UITextFieldDelegate  {
    
    var loginName: String?
    var address: String?
    
    @IBOutlet weak var tableCells: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
