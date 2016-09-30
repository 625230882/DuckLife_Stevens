//
//  ActivityController.swift
//  StevensLife
//
//  Created by Xiao Li on 5/31/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

private let useAutosizingCells = true

class ActivityController: UITableViewController {

    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    private let cellIdentifier = "ActivityCell"
    private let showActivitySegueIdentifier = "showActivity"
    private let JSONResultsKey = "results"
    private let JSONNumPagesKey = "results"
    
    private var currentPage = 0
    private var numPages = 0
    private var stories = [ActivityInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.tableView.rowHeight = 240
        }
        
        self.tableView.separatorStyle = .None
        if useAutosizingCells && tableView.respondsToSelector(Selector("layoutMargins")) {
            tableView.estimatedRowHeight = 242
            tableView.rowHeight = UITableViewAutomaticDimension
        }
        
        // Set custom indicator
        tableView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRectMake(0, 0, 24, 24))
        
        // Set custom indicator margin
        tableView.infiniteScrollIndicatorMargin = 40
        
        // Add infinite scroll handler
        tableView.addInfiniteScrollWithHandler { [weak self] (scrollView) -> Void in
            self?.fetchData() {
                scrollView.finishInfiniteScroll()
            }
        }
        
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: Selector("refreshTableView"), forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = refreshControl
        
        fetchData(nil)
    }
    
    func refreshTableView(){
        print("refresh")
        stories = []
        tableView.reloadData()
        fetchData(nil)
        refreshControl?.endRefreshing()
    }
    
    @IBAction func segmentChange(sender: UISegmentedControl) {
        switch segmentController.selectedSegmentIndex
        {
        case 0:
            break
        //show popular view
        case 1:
            break
        //show history view
        default:
            break;
        }
    }
    
    @IBAction func send(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("createActivity")
        self.presentViewController(nextViewController, animated:true, completion:nil)

    }
    
    // MARK: - UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(stories.count)
        return stories.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = stories[indexPath.row]
        print("select:\(selectedItem)")
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("ActivityDetails")
        as! ActivityDetailController
        //nextViewController.story = selectedItem
        nextViewController.story = selectedItem
        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 150;//Choose your custom row height
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ActivityTableViewCell
        
        let story = stories[indexPath.row]
        let data = NSData(contentsOfURL: story.URL!)
        print(story.URL)
        cell.numberLabel.text = "0/54"
        cell.activityImage.image = UIImage(data: data!)
        cell.activityTitle.text = story.Title
        cell.activityContent.text = story.Text
        //cell.activityImage.image = story.Image
        
        
        if useAutosizingCells && tableView.respondsToSelector(Selector("layoutMargins")) {
            cell.activityTitle.numberOfLines = 2
            cell.activityContent.numberOfLines = 2
        }
        
        return cell
    }
    
    private func apiURL(numHits: Int, page: Int) -> NSURL {
        let string = "http://localhost:8080/iosServer/GetActivity"
        let url = NSURL(string: string)
        
        return url!
    }
    
    
    private func fetchData(handler: ((Void) -> Void)?) {
        let hits: Int = Int(CGRectGetHeight(tableView.bounds)) / 44
        let requestURL = apiURL(hits, page: currentPage)
        let urlRequest = NSMutableURLRequest(
        URL: requestURL,
        cachePolicy:  .ReloadIgnoringLocalAndRemoteCacheData,
        timeoutInterval: 10.0 * 1000
        )
        
        var post: NSString = String(stories.count)
        var postData: NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
        
        urlRequest.HTTPMethod = "POST"
        let body = NSMutableData()
        body.appendData(postData)
        urlRequest.HTTPBody = body
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest, completionHandler: {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.handleResponse(data, response: response, error: error)
                
                UIApplication.sharedApplication().stopNetworkActivity()
                
                handler?()
            });
        })
    UIApplication.sharedApplication().startNetworkActivity()
            task.resume()
    }
    
    private func handleResponse(data: NSData!, response: NSURLResponse!, error: NSError!) {
        if let _ = error {
            showAlertWithError(error)
            return;
        }
        print(String(data:data! , encoding: NSUTF8StringEncoding)!)
        var jsonError: NSError?
        var responseDict: [String: AnyObject]?
        
        do {
            responseDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
            print(responseDict)
        } catch {
            jsonError = NSError(domain: "JSONError", code: 1, userInfo: [ NSLocalizedDescriptionKey: "Failed to parse JSON." ])
        }
        
        if let jsonError = jsonError {
            showAlertWithError(jsonError)
            return
        }

        //print("reponse from website :::    \(responseDict)")
        if let pages = responseDict?[JSONNumPagesKey] as? NSNumber {
            numPages = pages as Int
        }
        
        if let results = responseDict?[JSONResultsKey] as? [[String: AnyObject]] {
            currentPage += 1
            print("results is \(results)")
            for i in results {
                stories.append(ActivityInfo(i))
            }
            
            tableView.reloadData()
        }
    }
    
    
    private func showAlertWithError(error: NSError) {
        let alert = UIAlertController(title: NSLocalizedString("Error fetching data", comment: ""), message: error.localizedDescription, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .Cancel, handler: { (action) -> Void in
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: .Default, handler: { (action) -> Void in
            self.fetchData(nil)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    
    
}
