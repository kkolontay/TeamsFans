//
//  TeamTableViewCell.swift
//  TeamsFans
//
//  Created by kkolontay on 1/14/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
  
  @IBOutlet weak var leadingNameTeamConstraint: NSLayoutConstraint!
  @IBOutlet weak var nameTeamLabel: UILabel!
  @IBOutlet weak var logoTeamImageView: UIImageView!
  @IBOutlet weak var imaginationTeamView: UIView!
  @IBOutlet weak var firstColorTeamView: UIView!
  @IBOutlet weak var secondColorTeamView: UIView!
  var teamInfo: LeaguesTeamsModel?
  
  
  override func prepareForReuse() {
    secondColorTeamView.backgroundColor = .white
    firstColorTeamView.backgroundColor = .white
    logoTeamImageView.image = nil
  }
  
  func setData(_ item: LeaguesTeamsModel) {
    teamInfo = item
    nameTeamLabel.text = item.name
    logoTeamImageView.isHidden = true
    if (item.logo?.isEmpty ?? true) && (item.colour_1?.isEmpty ?? true) && (item.colour_2?.isEmpty ?? true) {
      leadingNameTeamConstraint.constant = 16
      imaginationTeamView.isHidden = true
    } else {
      firstColorTeamView.backgroundColor = UIColor.RGB(item.colour_1 ?? "000000")
      secondColorTeamView.backgroundColor = UIColor.RGB(item.colour_2 ?? "000000")
      leadingNameTeamConstraint.constant = 136
      imaginationTeamView.isHidden = false
    }
  }
  
  func setImage(_ image: UIImage?, url: String) {
    DispatchQueue.main.async {
      if image != nil && url == self.teamInfo?.logo {
        self.logoTeamImageView.isHidden = false
        self.logoTeamImageView.image = image
        self.secondColorTeamView.backgroundColor = .white
        self.firstColorTeamView.backgroundColor = .white
      }
    }
  }
}
