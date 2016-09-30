//
//  UIApplication+NetworkIndicator.swift
//  StevensLife
//
//  Created by Xiao Li on 6/1/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

private var networkActivityCount = 0

extension UIApplication {
    
    func startNetworkActivity() {
        networkActivityCount += 1
        networkActivityIndicatorVisible = true
    }
    
    func stopNetworkActivity() {
        if networkActivityCount < 1 {
            return;
        }
        
        networkActivityCount -= 1
        if networkActivityCount == 0 {
            networkActivityIndicatorVisible = false
        }
    }
    
}