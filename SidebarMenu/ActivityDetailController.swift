//
//  ActivityDetailController.swift
//  StevensLife
//
//  Created by Xiao Li on 6/6/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class ActivityDetailController: UIViewController{

    var story: ActivityInfo?
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = story?.Text
        print(story)
        let data = NSData(contentsOfURL: story!.URL!)
        //imageView.image = UIImage(data: data!)

        self.navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width,60)
        self.textView.frame = CGRectMake(4, 62, self.view.frame.size.width-8,250)
        self.textView.layer.cornerRadius = 8.0
        //self.inputText.layer.masksToBounds = true
        self.textView.layer.borderWidth = 0.3
        var imageView = UIImageView(frame: CGRectMake(8, 250, self.view.frame.size.width-16, self.view.frame.size.width*0.75-16));
        var image = UIImage(data: data!);
        imageView.image = image;
        self.view.addSubview(imageView);    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
}
