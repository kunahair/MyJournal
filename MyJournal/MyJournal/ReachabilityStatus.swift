//
//  ReachabilityStatus.swift
//  MyJournal
//
//  Created by XING ZHAO on 1/02/2017.
//  Copyright © 2017 Xing. All rights reserved.
//
/*
    This class is to check internet connection
 */
import Foundation
import SystemConfiguration

class ReachabilityStatus {
    
    static func isConnected() -> Bool {
        //initialized socket address structure
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        //give size of structure and also convert it to uint8
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        //call the given closure with a pointer to the zeroAddress.
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) { $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            //creates a reachability reference to the specified network address.
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        //initialized SCNetworkReachabilityFlags 
        //flags indicate the reachability of a network node name or address
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        //determines if the specified network target is reachable using the current network configuration. check defaultRoute reachability and pass the flags that describe the reachability of this specified target.        
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            //return false if the status could not be determined.
            return false
        }
        //check for flags
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        //return true if network is connected, otherwise return false
        return (isReachable && !needsConnection) ? true : false
       
    }

}
