//
//  BaseTableViewController.swift
//  TeamsFans
//
//  Created by kkolontay on 1/14/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
  
  var activityIndicator: UIActivityIndicatorView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    activityIndicator = UIActivityIndicatorView(style: .gray)
    activityIndicator?.hidesWhenStopped = true
    let searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    definesPresentationContext = true
  }
  
  func showActivityIndicator() {
    let window = (UIApplication.shared.delegate as! AppDelegate).window
    let heightWindow = window?.bounds.height
    let widthWindow = window?.bounds.width
    activityIndicator?.frame = CGRect(x: (widthWindow ?? 0 - 45) / 2, y: (heightWindow ?? 0 - 45) / 2, width: 45, height: 45)
    window?.addSubview(activityIndicator!)
    activityIndicator?.startAnimating()
  }
  
  func stopActivityIndicator() {
    DispatchQueue.main.async {
      if self.activityIndicator?.isAnimating ?? false {
        self.activityIndicator?.stopAnimating()
        self.activityIndicator?.removeFromSuperview()
      }
    }
  }
  
  func showAlert(_ message: String) {
    let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(action)
    self.present(alertController, animated: true, completion: nil)
  }
}
