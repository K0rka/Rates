//
//  ConverionsViewController.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import UIKit

class ConversionsViewController: UIViewController, ConversionsViewInput {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: ConversionsViewOutput!
    
    var dataToShow = [ConversionRateViewModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
        presenter.viewIsReady()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterNotifications()
        presenter.viewIsHiding()
    }
    
    func showNoResultsView() {
        loadingView.isHidden = true
        tableView.isHidden = true
        errorView.isHidden = false
    }
    
    func showLoading() {
        loadingView.isHidden = false
        tableView.isHidden = true
        errorView.isHidden = true

    }
    
    func show(rates: [ConversionRateViewModel]) {
        loadingView.isHidden = true
        tableView.isHidden = false
        errorView.isHidden = true
        if dataToShow.count != rates.count {
            dataToShow = rates
            tableView.reloadData()
        } else {
            dataToShow = rates
            let visible = tableView.indexPathsForVisibleRows
            visible?.forEach({ (index) in
                guard index != tableView.indexPathForSelectedRow else {
                    return
                }
                // Awful idea, but fixes animation. No, animation: .none didn't work
                let cell = tableView.cellForRow(at: index) as? ConversionCell
                cell?.configure(with: dataToShow[index.row])
            })
        }
    }

    
    // MARK: Keyboard Notifications
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        tableView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height

    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        tableView.contentInset.bottom = 0
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
        tableView.scrollToNearestSelectedRow(at: .top, animated: true)
        if let cell = tableView.cellForRow(at: indexPath) as? ConversionCell {
            cell.handleSelection()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let selectedIndex = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndex, animated: false)
        }
        scrollView.endEditing(true)
    }
}
