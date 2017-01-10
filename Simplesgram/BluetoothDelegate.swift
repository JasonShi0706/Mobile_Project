//
//  BluetoothDelegate.swift
//  BluetoothModule
//
//  Created by THINK on 11/10/2015.
//  Copyright © 2015 THINK. All rights reserved.
//

import Foundation
import MultipeerConnectivity

@objc protocol BluetoothDelegate {
    
    func foundUser()
    func lostUser(peerID: MCPeerID)
    
    optional func refresh(peerID: MCPeerID)
    //optional func invitationWasReceived(peerID: MCPeerID)
    //optional func connectedWithOtherUser(peerID: MCPeerID)
    //optional func connectingWithOtherUser(peerID: MCPeerID)
    //optional func notConnectedWithOtherUser(peerID: MCPeerID)
}
