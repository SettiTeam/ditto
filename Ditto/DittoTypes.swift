//
//  DittoTypes.swift
//  DailyCuriosity
//
//  Created by Chase McClure on 11/19/15.
//  Copyright © 2015 Curiosity. All rights reserved.
//

import Foundation

public enum Orientation {
    case Portrait, Landscape
}

public enum ScreenClass {
    case Phone, Pad
}

public enum SizeClass {
    case Small, Medium, Large
}

public enum DensityClass {
    case Low, Medium, High
}

public typealias DittoSheet = [ String: [ DittoBlock ] ]

