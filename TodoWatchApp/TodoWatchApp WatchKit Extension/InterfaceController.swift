//
//  InterfaceController.swift
//  TodoWatchApp WatchKit Extension
//
//  Created by diego.rios on 20/02/19.
//  Copyright © 2019 diego.rios. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func addNewItem() {
        let suggestionsArray = ["Visit Diego", "Code ;)"]
        
        presentTextInputController(withSuggestions: suggestionsArray,allowedInputMode: WKTextInputMode.allowEmoji, completion: { (result) -> Void in
            guard let choice = result else { return }
            
            let newItem = choice[0] as! String
            self.postValue(value: newItem)
        })
    }
    
    func postValue(value: String) {
        let parameters = ["value": value] as [String: Any]
        let url = URL(string: "http://127.0.0.1:5000/addItem")!
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(
                withJSONObject: parameters,
                options: .prettyPrinted
            )
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
    }
}
