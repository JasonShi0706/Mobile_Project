//
//  ReceivedImagesCollectionViewCell.swift
//  BluetoothModule
//
//  Created by THINK on 13/10/2015.
//  Copyright © 2015 THINK. All rights reserved.
//

import UIKit

class ReceivedImagesCollectionViewCell: UICollectionViewCell{
    var usernameLabel : UILabel!
    var timeLabel : UILabel!
    var imageView : UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width - 40))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        contentView.addSubview(imageView)
        
        usernameLabel = UILabel(frame: CGRect(x: 0, y: self.frame.width - 40, width: self.frame.width, height: 20))
        usernameLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(usernameLabel)
        
        timeLabel = UILabel(frame: CGRect(x: 0, y: self.frame.width - 20, width: self.frame.width, height: 20))
        timeLabel.adjustsFontSizeToFitWidth = true
        contentView.addSubview(timeLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
