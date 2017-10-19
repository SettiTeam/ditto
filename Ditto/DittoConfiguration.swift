//
//  LayoutConfiguration.swift
//  Ditto
//
//  Created by Chase McClure on 11/19/15.
//  Copyright (c) 2015 Giant Slide Game Company. All rights reserved.
//

import Foundation

public class DittoConfiguration {
    
    var treatsMultitaskingPadAsPhoneInPortrait = true
    var treatsMultitaskingPadAsPhoneInLandscapeSecondary = true
    
    var breakpoints = (
        phoneHeightSmall: CGFloat(568),  // iPhone 4
        phoneHeightMedium: CGFloat(736), // iPhone 5/6
        
        // iPhone 6+
        phoneWidthSmall: CGFloat(375),   // iPhone 4/5
        phoneWidthMedium: CGFloat(414),  // iPhone 6
        
        // iPhone 6+
        padHeightSmall: CGFloat(1024),   // iPad Landscape
        
        // iPad Portrait
        padWidthSmall: CGFloat(694),     // iPad Landscape Half
        padWidthMedium: CGFloat(1024),    // iPad Portrait/Landscape Primary
    
        // iPad Pro
        padWidthLarge: CGFloat(1365)    // iPad Portrait/Landscape Primary
    )
    
    var heightOversizeThreshold: CGFloat = 768
    
}
