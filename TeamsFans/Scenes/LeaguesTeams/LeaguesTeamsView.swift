//  
//  LeaguesTeamsView.swift
//  TeamsFans
//
//  Created by kkolontay on 1/14/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class LeaguesTeamsView: BaseTableViewController {
  var slug: String = ""
  var viewModel: LeaguesTeamsViewModel?
  var searchTeams = Array<LeaguesTeamsModel>() {
    didSet {
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
  }
  var teams = Array<LeaguesTeamsModel>() {
    didSet{
      searchTeams = teams
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      viewModel = LeaguesTeamsViewModel()
      viewModel?.updateLoadedStatus = {
        [weak self] teams in
        self?.teams = teams
        self?.stopActivityIndicator()
      }
      viewModel?.showAlertClosure = {
        [weak self] error in
        DispatchQueue.main.async {
          self?.showAlert(error)
          self?.stopActivityIndicator()
        }
      }
      viewModel?.fetchTeams(slug: slug)
      showActivityIndicator()
      navigationItem.searchController?.searchResultsUpdater = self
      tableView.tableFooterView = UIView()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchTeams.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TeamTableViewCell
    return cell
  }
  
  override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    guard let cell = cell as? TeamTableViewCell else {
      return
    }
    cell.setData(searchTeams[indexPath.row])
    if let url = searchTeams[indexPath.row].logo, !url.isEmpty {
      self.viewModel?.fetchLogo(url: url, logo: {[weak cell] (image, networkUrl) in
        cell?.setImage(image, url: networkUrl)
      })
    }
  }
  
}

extension LeaguesTeamsView: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if let searchString = searchController.searchBar.text {
      if searchString.isEmpty {
        searchTeams = teams
      } else {
        filterContentForSearchText(searchString)
      }
    } else {
      searchTeams = teams
    }
  }
  
  func filterContentForSearchText(_ searchText: String) {
    searchTeams = teams.filter({( team : LeaguesTeamsModel) -> Bool in
      return team.full_name?.lowercased().contains(searchText.lowercased()) ?? false || team.name?.lowercased().contains(searchText.lowercased()) ?? false || team.location?.lowercased().contains(searchText.lowercased()) ?? false
    })
  }
}



