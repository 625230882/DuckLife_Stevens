//
//  ActivityCreateEvent.swift
//  StevensLife
//
//  Created by 杨仁青 on 16/6/8.
//  Copyright © 2016年 AppCoda. All rights reserved.
//

import UIKit

//
//  ActivityDetailController.swift
//  StevensLife
//
//  Created by Xiao Li on 6/6/16.
//  Copyright © 2016 AppCoda. All rights reserved.

class ActivityCreateEvent: UIViewController ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @IBOutlet weak var publishButton: UIButton!
    
    @IBOutlet weak var inputTitle: UITextField!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var inputText: UITextView!
    //@IBOutlet weak var activityImage: UIImageView!
    var activityImage: UIImage?
    var story: ActivityInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = story?.Text
        self.navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width,60)
        self.inputTitle.frame = CGRectMake(4, 62, self.view.frame.size.width-8,44)
        self.inputText.frame = CGRectMake(4, 110, self.view.frame.size.width-8,250)
        self.inputText.layer.cornerRadius = 8.0
        self.inputTitle.layer.cornerRadius = 8.0
        self.publishButton.layer.cornerRadius = 8.0
        //self.inputText.layer.masksToBounds = true
        self.inputText.layer.borderWidth = 0.3
        self.inputTitle.layer.borderWidth = 0.3
        self.publishButton.layer.borderWidth = 0.4
        self.inputTitle.placeholder = "set title here"
        self.inputText.text = ""
        
        //self.activityImage.frame = CGRectMake(4, 316,50,50)
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func registerButtonAction(sender: AnyObject) {
        let httpRequest = HttpCallBack()
        httpRequest.sendPic(activityImage!,content: inputText.text!,id: "1",title: inputTitle.text!)
        let alertView = UIAlertController(title: "Alert", message: "register successful! \n Please sign in!", preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default){ (action) in
            // pop here
            self.dismissViewControllerAnimated(true, completion: nil);
        }
        alertView.addAction(OKAction)
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    
    @IBAction func addPic(sender: AnyObject) {
        //send image to server
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    @IBAction func backToActivity(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        activityImage = selectedImage
        //imageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}
