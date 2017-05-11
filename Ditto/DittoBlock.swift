//
//  DittoBlock.swift
//  Ditto
//
//  Created by Chase McClure on 11/22/15.
//  Copyright (c) 2015 Giant Slide Game Company. All rights reserved.
//

import Foundation

public class DittoBlock {
    
    let strings: [ String ]
    let devices: [ ScreenClass ]
    let widths: [ SizeClass ]
    let constraints: [ NSLayoutConstraint ]
    let heights: [ SizeClass ]
    
    init(
        devices: [ ScreenClass ] = [],
        widths: [ SizeClass ] = [],
        heights: [ SizeClass ] = [],
        constraints: [ NSLayoutConstraint ] = [],
        strings: [ String ]
    ) {
        self.devices = devices
        self.widths = widths
        self.heights = heights
        self.constraints = constraints
        self.strings = strings
    }
    
    func match() -> Int {
        var score = 0
        
        // device
        if !(devices.isEmpty || devices.contains(DittoDimensions.screenClass)) {
            return -1
        }
        
        // width
        if widths.isEmpty || widths.contains(DittoDimensions.widthClass) {
            score += 1
        }
        
        // height
        if heights.isEmpty || heights.contains(DittoDimensions.heightClass) {
            score += 1
        }
        
        return score
    }
    
}
