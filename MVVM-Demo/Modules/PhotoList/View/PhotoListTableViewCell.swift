//
//  PhotoListTableViewCell.swift
//  MVVM-Demo
//
//  Created by Islam 3bRahiem on 7/17/20.
//  Copyright © 2020 Organization. All rights reserved.
//

import UIKit

class PhotoListTableViewCell: UITableViewCell {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descContainerHeightConstraint: NSLayoutConstraint!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    var photoListCellViewModel : PhotoListCellViewModel? {
        didSet {
            nameLabel.text = photoListCellViewModel?.titleText
            descriptionLabel.text = photoListCellViewModel?.descText
            mainImageView?.sd_setImage(with: URL( string: photoListCellViewModel?.imageUrl ?? "" ), completed: nil)
            dateLabel.text = photoListCellViewModel?.dateText
        }
    }

}
