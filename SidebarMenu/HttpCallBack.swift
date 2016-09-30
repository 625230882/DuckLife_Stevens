//
//  HttpCallBack.swift
//  SidebarMenu
//
//  Created by Xiao Li on 5/26/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import Foundation

// we create a call back funtion to retrive response from server
class HttpCallBack: NSObject {
    
    /*
     * @parameter: user means username
     * @parameter: passwd means password
     * @parameter: successfulHandler, a callback process, to get response from ascyn connection
     *
     */
    func send(user:String , passwd:String, successHandler: (response: String) -> NSString){
        
        // set server address is http://localhost:8080/IOSServer/connectedTest
        let url = NSURL(string: "http://localhost:8080/iosServer/Test")!
        
        // combine the user name and password with space and store to NSString variable post
        // and encoding with NSASCIIString format
        var post:NSString = "{\"user\":\"\(user)\",\"passwd\":\"\(passwd)\"}"
        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLength:String = String(postData.length)
        
        /*
         * @parameter: URL address
         * @parameter: cachePolicy
         * @Parameter: timeout Interval
         * @Parameter: HTTPBody: carry message
         * @Parameter: HTTPMethod: POST
         * @Parameter: setvalue: to set the post length
         * @parameter: addValue: to add format for data
         */
        let urlRequest = NSMutableURLRequest(
            URL: url,
            cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0 * 1000)
        
        urlRequest.HTTPBody = postData
        urlRequest.HTTPMethod = "POST"
        urlRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // start connection task with ascyn way
        let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest)
        {
            (data, response, error) -> Void in
            
            if error != nil
            {
                print("error=\(error)")
                
            } else
            {
                successHandler(response: NSString(data: data!, encoding: NSUTF8StringEncoding)! as String!);
            }
            
        }
        
        task.resume()
    }
    
    
    func receiveNews(successHandler: (response: String) -> NSString) {
        let url = NSURL(string: "http://localhost:8080/IOSServer/ConnectedNewsTest")!
        let urlRequest = NSMutableURLRequest(
        URL: url,
        cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
        timeoutInterval: 10.0 * 1000)
        
        urlRequest.HTTPMethod = "POST"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest)
        {
            (data, response, error) -> Void in
            
            if error != nil
            {
                print("error=\(error)")
                
            } else
            {
                successHandler(response: NSString(data: data!, encoding: NSUTF8StringEncoding)! as String!);
            }
            
        }
        
        task.resume()
    
    }
    
    
    func sendRegister(user:String , passwd:String, email:String, successHandler: (response: String) -> NSString){
        
        // set server address is http://localhost:8080/IOSServer/connectedTest
        let url = NSURL(string: "http://localhost:8080/iosServer/RegisterAction")!
        
        // combine the user name and password with space and store to NSString variable post
        // and encoding with NSASCIIString format
        var post:NSString = "{\"user\":\"\(user)\",\"passwd\":\"\(passwd)\",\"email\":\"\(email)\"}"
        var postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
        var postLength:String = String(postData.length)
        
        /*
         * @parameter: URL address
         * @parameter: cachePolicy
         * @Parameter: timeout Interval
         * @Parameter: HTTPBody: carry message
         * @Parameter: HTTPMethod: POST
         * @Parameter: setvalue: to set the post length
         * @parameter: addValue: to add format for data
         */
        let urlRequest = NSMutableURLRequest(
            URL: url,
            cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0 * 1000)
        
        urlRequest.HTTPBody = postData
        urlRequest.HTTPMethod = "POST"
        urlRequest.setValue(postLength, forHTTPHeaderField: "Content-Length")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // start connection task with ascyn way
        let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest)
        {
            (data, response, error) -> Void in
            
            if error != nil
            {
                print("error=\(error)")
                
            } else
            {
                successHandler(response: NSString(data: data!, encoding: NSUTF8StringEncoding)! as String!);
            }
            
        }
        
        task.resume()
    }
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func sendPic(imagePicture : UIImage,content: String,id: String,title: String){
        // set server address is http://localhost:8080/IOSServer/CreateActivity
        let url = NSURL(string: "http://localhost:8080/iosServer/CreateActivity")!
        /*
         * @parameter: URL address
         * @parameter: cachePolicy
         * @Parameter: timeout Interval
         * @Parameter: HTTPBody: carry message
         * @Parameter: HTTPMethod: POST
         * @Parameter: setvalue: to set the post length
         * @parameter: addValue: to add format for data
         */
        let boundary = generateBoundaryString()
        let urlRequest = NSMutableURLRequest(
            URL: url,
            cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0 * 1000)
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let image_data = UIImageJPEGRepresentation(imagePicture,0.25)
        let strBase64 = image_data!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
        let body = NSMutableData()
        body.appendData("id:\(NSUUID().UUIDString) ".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("content:\(content) ".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData("image:".dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(strBase64.dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(" title:\(title) ".dataUsingEncoding(NSUTF8StringEncoding)!)
        //        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        //        body.appendData("--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        urlRequest.HTTPBody = body
        urlRequest.HTTPMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        // start connection task with ascyn way
        let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest)
        {
            (data, response, error) -> Void in
            
            if error != nil
            {
                print("error=\(error)")
                
            } else
            {
                
            }
            
        }
        
        task.resume()
    }


}

