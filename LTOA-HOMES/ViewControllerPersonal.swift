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
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    @IBAction func homeButton(_ sender: Any) {
    }
    @IBAction func changeName(_ sender: Any) {
    }
    @IBAction func changeAddress(_ sender: Any) {
    }
    @IBAction func changeNuber(_ sender: Any) {
    }
    @IBAction func changeEmail(_ sender: Any) {
    }
}
