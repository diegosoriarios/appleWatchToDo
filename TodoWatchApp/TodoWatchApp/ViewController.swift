//
//  ViewController.swift
//  TodoWatchApp
//
//  Created by diego.rios on 20/02/19.
//  Copyright © 2019 diego.rios. All rights reserved.
//

import UIKit
import PusherSwift

class ViewController: UITableViewController {
    
    var pusher: Pusher!
    
    var itemList = [String]() {
        didSet{
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupPusher()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // inflate each row
        let currentItem = itemList[indexPath.row]
        let todoCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableCell
        todoCell.setLabel(labelValue: currentItem)
        return todoCell
    }
    
    func setupPusher() {
        let options = PusherClientOptions(
            host: .cluster("us2")
        )
        
        pusher = Pusher(
            key: "2d88a674e241b1eaa239",
            options: options
        )
        
        let channel = pusher.subscribe("todo")
        
        let _ = channel.bind(eventName: "addItem", callback: { (data: Any?) -> Void in
            if let data = data as? [String: AnyObject] {
                let value = data["text"] as! String
                self.itemList.append(value)
            }
        })
        
        pusher.connect()
    }


}

