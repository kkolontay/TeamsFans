//  
//  LeaguesView.swift
//  TeamsFans
//
//  Created by kkolontay on 1/14/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class LeaguesView: BaseTableViewController {
  var leagues = Array<LeaguesModel>() {
    didSet {
      leaguesSearch = leagues
    }
  }
  var leaguesSearch = Array<LeaguesModel>() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  var viewModel: LeaguesViewModel?
  
    override func viewDidLoad() {
        super.viewDidLoad()
      tableView.rowHeight = UITableView.automaticDimension
      tableView.estimatedRowHeight = 64
       viewModel = LeaguesViewModel()
      viewModel?.updateLoadedStatus = {
        [weak self] leagues in
        self?.leagues = leagues
        self?.stopActivityIndicator()
      }
      viewModel?.showAlertClosure = {
        [weak self] error in
        DispatchQueue.main.async {
          self?.showAlert(error)
          self?.stopActivityIndicator()
        }
      }
      viewModel?.fetchLeagues()
      showActivityIndicator()
      navigationItem.searchController?.searchResultsUpdater = self
      tableView.tableFooterView = UIView()
    }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return leaguesSearch.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LeagueTableViewCell
   cell.setData(leaguesSearch[indexPath.row].full_name ?? "")
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "teamsOfLeague", sender: leaguesSearch[indexPath.row].slug)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "teamsOfLeague" {
      if let slug = sender as? String {
        let controller = segue.destination as! LeaguesTeamsView
        controller.slug = slug
      }
    }
  }
}

extension LeaguesView: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if let searchString = searchController.searchBar.text {
      if searchString.isEmpty {
        leaguesSearch = leagues
      } else {
        filterContentForSearchText(searchString)
      }
    } else {
      leaguesSearch = leagues
    }
  }
  
  func filterContentForSearchText(_ searchText: String) {
    leaguesSearch = leagues.filter({( league : LeaguesModel) -> Bool in
      return league.full_name?.lowercased().contains(searchText.lowercased()) ?? false || league.slug?.lowercased().contains(searchText.lowercased()) ?? false
    })
  }
}

