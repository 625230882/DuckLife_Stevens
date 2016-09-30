//
//  NewsTableViewController.swift
//  SidebarMenu
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit

private let useAutosizingCells = true


class NewsTableViewController: UITableViewController {
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    private let cellIdentifier = "Cell"
    private let showBrowserSegueIdentifier = "ShowBrowser"
    private let JSONResultsKey = "results"
    private let JSONNumPagesKey = "results"
    
    private var currentPage = 0
    private var numPages = 0
    private var stories = [StoryModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.tableView.rowHeight = 240
        }
        //delete lines between table cell
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == showBrowserSegueIdentifier {
            if let selectedRow = tableView.indexPathForSelectedRow {
               // print("\(stories[selectedRow.row].URL)")
                let browser = segue.destinationViewController as! BrowserViewController
                browser.story = stories[selectedRow.row]
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(stories.count)
        return stories.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 150;//Choose your custom row height
    }
    
    func refreshTableView(){
        print("refresh")
        stories = []
        tableView.reloadData()
        fetchData(nil)
        refreshControl?.endRefreshing()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NewsTableViewCell
        let story = stories[indexPath.row]
        
        cell.newsTitle.text = story.Title
        cell.newsContent.text = story.Content
        
        let picUrl  = NSURL(string: "https://www.stevens.edu/sites/all/themes/stevens/images/favicons/apple-touch-icon-180x180.png")
        var  data = NSData(contentsOfURL: story.picURL!)
        
        if data == nil  {
           // print("picUrl is \(picUrl)")
            data = NSData(contentsOfURL: picUrl!)
        }
        
        if data != nil {
            cell.newsImage.image = UIImage(data: data!)
        }
        
        if useAutosizingCells && tableView.respondsToSelector(Selector("layoutMargins")) {
            cell.newsTitle.numberOfLines = 2
            cell.newsContent.numberOfLines = 2
        }
        
        return cell
    }
    
    // MARK: - Private
    
    private func apiURL(numHits: Int, page: Int) -> NSURL {
        //let string = "https://hn.algolia.com/api/v1/search_by_date?tags=story&hitsPerPage=\(numHits)&page=\(page)"
        //let string = "https://www.stevens.edu/"
        let string = "http://localhost:8080/iosServer/ConnectNewsTest"
        let url = NSURL(string: string)
        
        return url!
    }
    
    private func fetchData(handler: ((Void) -> Void)?) {
        let hits: Int = Int(CGRectGetHeight(tableView.bounds)) / 44
        let requestURL = apiURL(hits, page: currentPage)
        let urlRequest = NSMutableURLRequest(
            URL: requestURL,
            cachePolicy: .ReloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 10.0 * 1000)
        var post:NSString = String(stories.count)
        var postData:NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
        
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
        
        // I run task.resume() with delay because my network is too fast
        // let delay = (stories.count == 0 ? 0 : 5) * Double(NSEC_PER_SEC)
        //let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        //dispatch_after(time, dispatch_get_main_queue(), {
        task.resume()
        //})
    }
    
    private func handleResponse(data: NSData!, response: NSURLResponse!, error: NSError!) {
        //print("\(NSString(data: data!, encoding: NSUTF8StringEncoding)! as String!) in try")
        
        if let _ = error {
            showAlertWithError(error)
            return;
        }
        
        var jsonError: NSError?
        var responseDict: [String: AnyObject]?
        
        do {
            responseDict = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
            
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
            //print("results is \(results)")
            for i in results {
                stories.append(StoryModel(i))
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
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
}
