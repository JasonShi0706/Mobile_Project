//
//  Bluetooth.swift
//  BluetoothModule
//
//  Created by THINK on 9/10/2015.
//  Copyright © 2015 THINK. All rights reserved.
//
import UIKit

import Parse
import MultipeerConnectivity

enum ConnectState : String {
    case Connected = "Connected"
    case Connecting = "Connecting"
    case NotConnected = "Not Connected"
}

class Bluetooth: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate
{
    let serviceName = "usersinrange"
    var bluetoothUser : MCPeerID!
    var bluetoothSession : MCSession!
    var bluetoothBrowser : MCNearbyServiceBrowser!
    var bluetoothAdvertiser : MCNearbyServiceAdvertiser!
    var bluetoothDelegate : BluetoothDelegate?
    var invitationResponse: ((Bool, MCSession)->Void)?
    var foundInRangeUsers = [FoundInRangeUser]()
    var foundUserID : MCPeerID!
    var isBrowsering : Bool!
    var isAdvertising : Bool!
    
    override init() {
        super.init()
        self.bluetoothUser = MCPeerID(displayName:(PFUser.currentUser()?.username)!) //should be changed later
        self.bluetoothSession = MCSession(peer: self.bluetoothUser, securityIdentity: nil, encryptionPreference: .Required)
        self.bluetoothBrowser = MCNearbyServiceBrowser(peer: self.bluetoothUser, serviceType: self.serviceName)
        self.bluetoothAdvertiser = MCNearbyServiceAdvertiser(peer: self.bluetoothUser, discoveryInfo: nil, serviceType: self.serviceName)
        self.bluetoothSession.delegate = self
        self.bluetoothBrowser.delegate = self
        self.bluetoothAdvertiser.delegate = self
        self.isAdvertising = false
        self.isBrowsering = false
    }
    
    func sendPhoto(timeAndImage data: Dictionary<String, UIImage>, targetUsers users: [MCPeerID]) -> Bool {
        let objectToSend = NSKeyedArchiver.archivedDataWithRootObject(data)
        if let error = try? self.bluetoothSession.sendData(objectToSend, toPeers: users, withMode: MCSessionSendDataMode.Reliable) {
            print(error)
            return false
        }
        return true
    }
    
    // Remote peer changed state.
    func session(session: MCSession, peer peerID: MCPeerID, didChangeState state: MCSessionState) {
        switch state {
        case MCSessionState.Connected:
            for user in self.foundInRangeUsers {
                if user.foundUserID.isEqual(peerID) {
                    user.connectState = ConnectState.Connected
                }
            }
            self.bluetoothDelegate?.refresh!(peerID)
            //self.bluetoothDelegate?.connectedWithOtherUser!(peerID)
            break
        case MCSessionState.Connecting:
            for user in self.foundInRangeUsers {
                if user.foundUserID.isEqual(peerID) {
                    user.connectState = ConnectState.Connecting
                }
            }
            self.bluetoothDelegate?.refresh!(peerID)
            //self.bluetoothDelegate?.connectingWithOtherUser!(peerID)
            break
        case MCSessionState.NotConnected:
            for user in self.foundInRangeUsers {
                if user.foundUserID.isEqual(peerID) {
                    user.connectState = ConnectState.NotConnected
                    let index = self.foundInRangeUsers.indexOf(user)
                    self.foundInRangeUsers.removeAtIndex(index!)
                    bluetoothDelegate?.lostUser(peerID)
                    
                }
            }
            break
        }
    }
    
    // Received data from remote peer.
    func session(session: MCSession, didReceiveData data: NSData, fromPeer peerID: MCPeerID) {
        let dictionary: [String: AnyObject] = ["Data": data, "FromUser": peerID]
        NSNotificationCenter.defaultCenter().postNotificationName("NewPhoto", object: dictionary)
    }
    
    // Received a byte stream from remote peer.
    func session(session: MCSession, didReceiveStream stream: NSInputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    // Start receiving a resource from remote peer.
    func session(session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, withProgress progress: NSProgress) {
        
    }
    
    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.\
    func session(session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, atURL localURL: NSURL, withError error: NSError?) {
        
    }
    
    // Made first contact with peer and have identity information about the
    // remote peer (certificate may be nil).
    //optional
    func session(session: MCSession, didReceiveCertificate certificate: [AnyObject]?, fromPeer peerID: MCPeerID, certificateHandler: (Bool) -> Void) {
        certificateHandler(true)
    }
    
    // Found a nearby advertising peer.
    func browser(browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        for user in self.foundInRangeUsers {
            if (user.foundUserID.displayName.isEqual(peerID.displayName) && (user.connectState == ConnectState.NotConnected)){
                let index = self.foundInRangeUsers.indexOf(user)
                self.foundInRangeUsers.removeAtIndex(index!)
                let friend = GlobalVariable.follower.contains(peerID.displayName)
                self.foundInRangeUsers.append(FoundInRangeUser(ID: peerID, isFriend: friend, state: ConnectState.Connecting, select: false))
                self.bluetoothBrowser.invitePeer(peerID, toSession: self.bluetoothSession, withContext: nil, timeout: 5)
                bluetoothDelegate?.foundUser()
            }
            else if user.foundUserID.displayName.isEqual(peerID.displayName) {
                return
            }
            
        }
        
        self.bluetoothBrowser.invitePeer(peerID, toSession: self.bluetoothSession, withContext: nil, timeout: 5)
        
        let friend = GlobalVariable.follower.contains(peerID.displayName)
        self.foundInRangeUsers.append(FoundInRangeUser(ID: peerID, isFriend: friend, state: ConnectState.Connecting, select: false))
        bluetoothDelegate?.foundUser()
    }
    
    // A nearby peer has stopped advertising.
    func browser(browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for user in self.foundInRangeUsers {
            if user.foundUserID.isEqual(peerID) {
                let index = self.foundInRangeUsers.indexOf(user)
                self.foundInRangeUsers.removeAtIndex(index!)
                bluetoothDelegate?.lostUser(peerID)
            }
        }
    }
    
    // Browsing did not start due to an error.
    //optional
    func browser(browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: NSError) {
        print(error.localizedDescription)
    }
    
    // Incoming invitation request.  Call the invitationHandler block with YES
    // and a valid session to connect the inviting peer to the session.
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: NSData?, invitationHandler: (Bool, MCSession?) -> Void) {
        
        for user in self.foundInRangeUsers {
            if (user.foundUserID.displayName.isEqual(peerID.displayName) && (user.connectState == ConnectState.NotConnected)){
                let index = self.foundInRangeUsers.indexOf(user)
                self.foundInRangeUsers.removeAtIndex(index!)
                let friend = GlobalVariable.follower.contains(peerID.displayName)
                self.foundInRangeUsers.append(FoundInRangeUser(ID: peerID, isFriend: friend, state: ConnectState.Connecting, select: false))
                invitationHandler(true, self.bluetoothSession)
                bluetoothDelegate?.foundUser()
            }
            else if user.foundUserID.displayName.isEqual(peerID.displayName) {
                return
            }
            
        }
        let friend = GlobalVariable.follower.contains(peerID.displayName)
        self.foundInRangeUsers.append(FoundInRangeUser(ID: peerID, isFriend: friend, state: ConnectState.Connecting, select: false))
        invitationHandler(true, self.bluetoothSession)
        bluetoothDelegate?.foundUser()
        
        
    }
    
    // Advertising did not start due to an error.
    //optional
    func advertiser(advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: NSError) {
        print(error.localizedDescription)
    }
}
