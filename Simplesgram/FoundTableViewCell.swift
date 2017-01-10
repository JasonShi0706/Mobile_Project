//
//  FoundTableViewCell.swift
//  BluetoothModule
//
//  Created by THINK on 8/10/2015.
//  Copyright © 2015 THINK. All rights reserved.
//

import UIKit

class FoundTableViewCell: UITableViewCell {
    let padding: CGFloat = 5
    var background: UIView!
    //var userImageView: UIImageView!
    var nameLabel: UILabel!
    var stateLabel: UILabel!
    var relationLabel: UILabel!
    var selectedLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        selectionStyle = .None
        
        background = UIView(frame: CGRectZero)
        background.alpha = 0.6
        background.backgroundColor = UIColor.whiteColor()
        contentView.addSubview(background)
        
        //userImageView = UIImageView(frame: CGRectZero)
        //contentView.addSubview(userImageView)
        
        nameLabel = UILabel(frame: CGRectZero)
        nameLabel.textColor = UIColor.blueColor()
        nameLabel.textAlignment = .Left
        contentView.addSubview(nameLabel)
        
        stateLabel = UILabel(frame: CGRectZero)
        stateLabel.textColor = UIColor.blackColor()
        stateLabel.textAlignment = .Right
        contentView.addSubview(stateLabel)
        
        relationLabel = UILabel(frame: CGRectZero)
        relationLabel.textColor = UIColor.grayColor()
        relationLabel.textAlignment = .Left
        contentView.addSubview(relationLabel)
        
        selectedLabel = UILabel(frame: CGRectZero)
        selectedLabel.textColor = UIColor.greenColor()
        selectedLabel.textAlignment = .Right
        contentView.addSubview(selectedLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        background.frame = CGRectMake(padding, padding, self.frame.width - 2 * padding, self.frame.height - 2 * padding)
        //userImageView.frame = CGRectMake(padding * 2, padding * 2, 50, 50)
        nameLabel.frame = CGRectMake(padding * 3, padding * 2, self.frame.width - 190, 30)
        nameLabel.adjustsFontSizeToFitWidth = true
        stateLabel.frame = CGRectMake(self.frame.width - 2 * padding - 150, padding * 2 + 30, 150, 20)
        stateLabel.adjustsFontSizeToFitWidth = true
        relationLabel.frame = CGRectMake(padding * 3, padding * 2 + 30, self.frame.width - 190, 20)
        relationLabel.adjustsFontSizeToFitWidth = true
        selectedLabel.frame = CGRectMake(self.frame.width - 2 * padding - 150, padding * 2, 150, 30)
        selectedLabel.adjustsFontSizeToFitWidth = true
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
