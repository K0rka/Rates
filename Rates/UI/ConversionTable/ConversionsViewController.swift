//
//  ConverionsViewController.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import UIKit

class ConversionsViewController: UIViewController {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var dataToShow = [ConversionRateViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}


extension ConversionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversionCell", for: indexPath)
        if let cell = cell as? ConversionCell {
            cell.configure(with: dataToShow[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? ConversionCell {
            tableView.scrollToNearestSelectedRow(at: .top, animated: true)
            cell.handleSelection()
        }
    }
    
    
}
