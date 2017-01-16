//
//  DeviceLocationError.swift
//  MyJournal
//
//  Created by Josh Gerlach on 14/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation

/**
 Enum that specifies custom Device Location Errors
 **/
enum DeviceLocationError: Error
{
    case locationError
    case locationNotFound
    case permissionDenied
}
