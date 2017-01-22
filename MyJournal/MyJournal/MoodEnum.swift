//
//  Mood.swift
//  MyJournal
//
//  Created by Yuanqing Jiang on 13/01/2017.
//  Copyright © 2017 LegDay. All rights reserved.
//

import Foundation

/**
 Enum that matches mood to icon
 **/
enum MoodEnum: String {
    
    /* This mood enum class contains the following 5 states:
     1.  happy
     2.  sad
     3.  okay
     4.  tired
     5.  peaceful
     
     each of these mood states relate to specific mood icon
     */
    
    case happy, sad, okay, tired, peaceful
    
    // default init
    init() {
        self = .happy
    }
    
    init?(mood: String) {
        switch mood {
        case "happy": self = .happy
        case "sad" : self = .sad
        case "okay" : self = .okay
        case "tired" : self = .tired
        case "peaceful" : self = .peaceful
        default: self = .okay
        }
    }
    
    var description:String {
        get {
            switch self {
            case .happy: return "happy"
            case .sad: return "sad"
            case .okay: return "okay"
            case .tired: return "tired"
            case .peaceful: return "peaceful"
            }
        }
        
        set(mood) {
            switch mood {
            case "happy": self = .happy
            case "sad": self = .sad
            case "okay": self = .okay
            case "tired" : self = .tired
            case "peaceful" : self = .peaceful
            default: self = .happy
            }
        }
    }
}
