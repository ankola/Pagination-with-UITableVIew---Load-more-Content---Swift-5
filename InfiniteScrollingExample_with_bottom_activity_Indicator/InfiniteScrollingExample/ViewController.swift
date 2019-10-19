//
//  ViewController.swift
//  InfiniteScrollingExample
//
//  Created by Robert Canton on 2018-03-12.
//  Copyright © 2018 Robert Canton. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var height_activityIndicator: NSLayoutConstraint!
    
    var fetchingMore = false
    var items = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.height_activityIndicator.constant = 0
        self.activityIndicator.isHidden = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
        let loadingNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: "loadingCell")
        tableView.delegate = self
        tableView.dataSource = self
 
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = "Item \(items[indexPath.row])"
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
//        print("offsetY - ", offsetY, " contentHeight",contentHeight, "scrollView.height", scrollView.frame.height * 2)
        if offsetY > contentHeight - scrollView.frame.height * 2 {
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
//        print("beginBatchFetch!")
        self.height_activityIndicator.constant = 50
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            let newItems = (self.items.count...self.items.count + 12).map { index in index }
            self.items.append(contentsOf: newItems)
            self.fetchingMore = false
            print(self.items.count)
            self.tableView.reloadData()
            self.height_activityIndicator.constant = 0
            self.activityIndicator.isHidden = true
        })
    }
}

