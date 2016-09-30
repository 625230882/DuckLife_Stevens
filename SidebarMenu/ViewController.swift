//
//  ViewController.swift
//  SidebarMenu
//
//  Created by Xiao Li on 5/26/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

//import Foundation
import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var myLoginView: UIImageView!
    @IBOutlet weak var myIDLabel: UILabel!
    @IBOutlet weak var myPaLabel: UILabel!
    
    @IBOutlet weak var myIDText: UITextField!
    @IBOutlet weak var myPaText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "LoginViewImage_2.jpg")!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
    
    @IBAction func myIDTextFieldAction(sender: AnyObject) {
        
    }
    
    @IBAction func myLoginAction(sender: AnyObject) {
        
        // use callback and dispatch to deal with the main view
        let t = HttpCallBack()
        
        // send user name and password to server to do authentication
        t.send(self.myIDText.text!, passwd: self.myPaText.text! , successHandler: {
            (response) in
            
            // if response is true, the anthentication has passed, go to main view
            if NSString(string: response) == "true"
            {
                dispatch_async(dispatch_get_main_queue())
                {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("RevealViewController")
                    self.presentViewController(nextViewController, animated:true, completion:nil)
                }
            }
            
                
            // if response is false, the anthentication has not passed, send alert to user
            else
            {   dispatch_async(dispatch_get_main_queue())
                {
                    let alert = UIAlertController(title: "Alert", message: "wrong password or username \n Please try again!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
            return response
            });
        
    }
    
    
    @IBAction func myRegisterButton(sender: AnyObject) {
        self.performSegueWithIdentifier("RegisterView", sender: sender)
    }
    
}







