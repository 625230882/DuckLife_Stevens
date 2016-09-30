//
//  RegisterViewController.swift
//  StevensLife
//
//  Created by Xiao Li on 5/28/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var myStevensEmailText: UITextField!
    @IBOutlet weak var myUsernameText: UITextField!
    @IBOutlet weak var myPasswordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "LoginViewImage_2.jpg")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func myRegisterAction(sender: AnyObject) {
        let t = HttpCallBack()
        
        // send user name and password to server to do authentication
        t.sendRegister(self.myUsernameText.text!, passwd: self.myPasswordText.text!, email: self.myStevensEmailText.text! , successHandler: {
            (response) in
            
            // if response is true, the anthentication has passed, go to main view
            if NSString(string: response) == "true"
            {
                dispatch_async(dispatch_get_main_queue())
                {
                    let alertView = UIAlertController(title: "Alert", message: "register successful! \n Please sign in!", preferredStyle: UIAlertControllerStyle.Alert)
                    let OKAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ (action) in
                        // pop here
                        if let navController = self.navigationController {
                            navController.popViewControllerAnimated(true)
                        }
                    }
                    alertView.addAction(OKAction)
                    self.presentViewController(alertView, animated: true, completion: nil)
                    
                }
            }
                
                
                // if response is false, the anthentication has not passed, send alert to user
            else
            {   dispatch_async(dispatch_get_main_queue())
                {
                let alert = UIAlertController(title: "Alert", message: "cannot register!! \n Please try again!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            return response
        });
    }
}
