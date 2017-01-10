//
//  ReceivedImages.swift
//  BluetoothModule
//
//  Created by THINK on 12/10/2015.
//  Copyright © 2015 THINK. All rights reserved.
//

import Foundation
import UIKit

class NewImage : NSObject {
    var newImageTime : String
    var newImageFile : UIImage
    var newImageUser : String
    
    init(user : String, time : String, image : UIImage) {
        self.newImageUser = user
        self.newImageTime = time
        self.newImageFile = image
    }
}