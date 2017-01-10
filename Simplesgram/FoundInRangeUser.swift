//
//  FoundInRangeUser.swift
//  BluetoothModule
//
//  Created by THINK on 11/10/2015.
//  Copyright © 2015 THINK. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class FoundInRangeUser: NSObject {
    
    var foundUserID : MCPeerID!
    var isFriend : Bool
    var connectState : ConnectState!
    var isSelected : Bool
    //var userImageView : UIImageView!
    
    init(ID : MCPeerID, isFriend : Bool, state : ConnectState, select : Bool) {
        self.foundUserID = ID
        self.isFriend = isFriend
        self.connectState = state
        self.isSelected = select
        //self.userImageView.image = image
    }
}