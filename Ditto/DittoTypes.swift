//
//  DittoTypes.swift
//  Ditto
//
//  Created by Chase McClure on 11/19/15.
//  Copyright (c) 2015 Giant Slide Game Company. All rights reserved.
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

