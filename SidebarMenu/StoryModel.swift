//
//  StoryModel.swift
//  StevensLife
//
//  Created by Xiao Li on 6/1/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

class StoryModel: NSObject {
    
    var Title: String?
    var Date: String?
    var Content: String?
    var URL: NSURL?
    var picURL: NSURL?
    var Image: UIImage?
    
    init(_ dictionary: [String: AnyObject]) {
        super.init()
        
        Title = dictionary["Title"] as? String
        Date = dictionary["Date"] as? String
        Content = dictionary["Content"] as? String
        
        Image = dictionary["Image"] as? UIImage
        
        
        if let urlString = dictionary["URL"] as? String {
            URL = NSURL(string: urlString)
        }
        
        if let urlString = dictionary["picURL"] as? String {
            picURL = NSURL(string: urlString)
        }
    }
    
}