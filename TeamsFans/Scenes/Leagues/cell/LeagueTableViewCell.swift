//
//  LeagueTableViewCell.swift
//  TeamsFans
//
//  Created by kkolontay on 1/14/19.
//  Copyright © 2019 com.kkolontay. All rights reserved.
//

import UIKit

class LeagueTableViewCell: UITableViewCell {
  @IBOutlet weak var leagueLabel: UILabel!

  override func prepareForReuse() {
    leagueLabel.text = ""
  }
  
  func setData(_ nameOfLeague: String) {
    leagueLabel.text = nameOfLeague
  }

}
