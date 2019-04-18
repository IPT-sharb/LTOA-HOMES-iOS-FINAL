//
//  ViewControllerMain.swift
//  LTOA-HOMES
//
//  Created by Stephen Harb on 4/18/19.
//  Copyright © 2019 Stephen Harb. All rights reserved.
//

import UIKit

class ViewControllerMain: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var memberName: UILabel!
    
    var Name: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Name)
        self.memberName.text = self.Name
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
}
