//
//  ActivityModel.swift
//  StevensLife
//
//  Created by 杨仁青 on 16/6/8.
//  Copyright © 2016年 AppCoda. All rights reserved.
//

import Foundation

class ActivityInfo: NSObject {
    var Title: String?
    var Text: String?
    var URL: NSURL?
    
    init(_ dictionary: [String: AnyObject]) {
        super.init()
        
        Text = dictionary["text"] as? String
        Title = dictionary["title"] as? String

        if let urlString = dictionary["url"] as? String {
            URL = NSURL(string: urlString)
        }
    }
    
}