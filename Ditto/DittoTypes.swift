//
//  DittoTypes.swift
//  DailyCuriosity
//
//  Created by Chase McClure on 11/19/15.
//  Copyright © 2015 Curiosity. All rights reserved.
//

import Foundation

public enum Orientation {
    case portrait, landscape
}

public enum ScreenClass {
    case phone, pad
}

public enum SizeClass {
    case small, medium, large
}

public enum DensityClass {
    case low, medium, high
}

public typealias DittoSheet = [ String: [ DittoBlock ] ]

