//
//  DataPacket.swift
//  AtomDash
//
//  Created by Oran Luzon on 10/9/15.
//  Copyright © 2015 SoyMobile. All rights reserved.
//

import Foundation
import SpriteKit

class DataPacket{
    
    var data: NSData!
    
    var enemyNodePosition: CGPoint!
    var targetPosition: CGPoint!
    var multiplayerNode: CGPoint!
    var newTarget: Bool!
    var newEnemy: Bool!
    
    init (data: NSData){
        self.data = data
    }
    
    init(enemyNodePosition: CGPoint!, targetPosition: CGPoint!, multiplayerNode: CGPoint!, newTarget: Bool!, newEnemy: Bool!){
        self.enemyNodePosition = enemyNodePosition
        self.targetPosition = targetPosition
        self.multiplayerNode = multiplayerNode
        self.newTarget = newTarget
        self.newEnemy = newEnemy
    }
    
    // Recieve + set position of enemy node (every frame)
    
    // Recieve + set position of target (when it sends a message that the target is gone)
    
    // Recieve + set position of enemies (when instantiated)
    
    // Recieve position of Enemies every 1 second (to make sure they are on track)
    
    func archiveAndSendPacket(){
        var positions: NSMutableData!
        var booleans: NSMutableData!
        
        var positionArray: [CGFloat] = []
        var booleanArray: [Bool] = []

        //Archive all of the data above into their own NSDatas and send them
        
        
        // Archiving and sending enemyNodePosition
        positionArray.append(enemyNodePosition.x)
        positionArray.append(enemyNodePosition.y)
        
        // Archiving and sending target Node
        positionArray.append(targetPosition.x)
        positionArray.append(targetPosition.y)
        
        // Archiving and sending Multiplayer Node
        positionArray.append(multiplayerNode.x)
        positionArray.append(multiplayerNode.y)
        
        positions = NSMutableData(bytes: &positionArray, length: positionArray.count * sizeof(CGFloat))
        
        booleanArray.append(newTarget)
        booleanArray.append(newEnemy)
        
        
        booleans = NSMutableData(bytes: &booleanArray, length: booleanArray.count *  sizeof(Bool))
        
        print("Sending Positions")
        sendData(positions)
        print("Sending Booleans")
        sendData(booleans)
    }
    
    func unarchiveData() -> (enemyNodePosition: CGPoint!, targetPosition: CGPoint!, multiplayerNode: CGPoint!, newTarget: Bool!, newEnemy: Bool!){
       // Unarchive all of the data above from NSDatas to initial values
        
        if data == nil{
            print("No Input to Convert")
        }
        
        /*
        if data.length > 2{
            let count = data.length / sizeof(CGFloat)
        
            var array = [CGFloat](count: count, repeatedValue: 0)
        
            data.getBytes(&array, length: count * sizeof(CGFloat))
        }
        else{
            let count = data.length / sizeof(Bool)
            
            var array = [Bool](count: count, repeatedValue: 0)
            
            data.getBytes(&array, length: count * sizeof(CGFloat))
        }
        */
        
        
        return (enemyNodePosition, targetPosition, multiplayerNode, newTarget, newEnemy)
    }
    
    private func sendData(data: NSData){
        do {
            try GCHelper.sharedInstance.match.sendDataToAllPlayers(data, withDataMode: .Reliable)
            print("Sent")
        }
        catch{
            print("there was an error Sending Data \(error)")
        }
    }
}