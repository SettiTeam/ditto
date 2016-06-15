//
//  DittoDimensions.swift
//  DailyCuriosity
//
//  Created by Chase McClure on 11/19/15.
//  Copyright © 2015 Curiosity. All rights reserved.
//

import Foundation

public let DittoDimensionsDidChange = "DittoDimensionsDidChange"

public class DittoDimensions {
    
    /// current configuration used to calculate dimensions and classes
    public static var configuration: DittoConfiguration!
    
    
    
    // MARK: Dimensions
    
    /// The width of the device
    public static var deviceWidth: CGFloat!
    
    /// The hight of the device
    public static var deviceHeight: CGFloat!
    
    /// The width of the application window
    public static var screenWidth: CGFloat!
    
    /// The height of the application window
    public static var screenHeight: CGFloat!
    
    
    
    // MARK: Current Classes
    
    /// The orientation of the application window
    public static var orientation: Orientation!
    
    /// The screen class of the device
    public static var deviceClass: ScreenClass!
    
    /// The screen class of the application window
    public static var screenClass: ScreenClass!
    
    /// The width size class of the application window
    public static var widthClass: SizeClass!
    
    // The height size class of the application window
    public static var heightClass: SizeClass!
    
    /// The density class of the device
    public static var resolutionClass: DensityClass!
    
    
    
    // MARK: Flags
    
    /// true if device density is at least 2x
    public static var isRetina: Bool!
    
    /// true if screen height is greater than configuration.heightOversizeThreshold
    public static var isHeightOversize: Bool!
    
    /// true if the device is a multitasking iPad
    public static var isMultitasking: Bool!
    
    /// true if the device is an iPad Pro
    public static var isPadPro: Bool!
    
    
    
    // MARK: Details of Notification
    
    /// true if the device orientation changed on last dimension change
    public static var isNewOrientation = true
    private static var tempOrientation: Orientation!
    
    /// true if the screen class changed on last dimension change
    public static var isNewScreenClass = true
    private static var tempScreenClass: ScreenClass!
    
    /// true if the width size class changed on last dimension change
    public static var isNewWidthClass = true
    private static var tempWidthClass: SizeClass!
    
    /// true if the height size class changed on last dimension change
    public static var isNewHeightClass = true
    private static var tempHeightClass: SizeClass!
    
    
    
    // MARK: Set Dimensions
    
    public static func set() {
        
        deviceWidth = UIScreen.mainScreen().bounds.width
        deviceHeight = UIScreen.mainScreen().bounds.height
        screenWidth = UIApplication.sharedApplication().keyWindow!.bounds.width
        screenHeight = UIApplication.sharedApplication().keyWindow!.bounds.height
        
        orientation = setOrientation()
        deviceClass = setDeviceClass()
        screenClass = setScreenClass()
        heightClass = setHeightClass()
        widthClass = setWidthClass()
        resolutionClass = setResolutionClass()
        
        isRetina = UIScreen.mainScreen().respondsToSelector(#selector(NSDecimalNumberBehaviors.scale)) && UIScreen.mainScreen().scale >= 2.0
        isHeightOversize = setHeightOversize()
        isMultitasking = setIsMultitasking()
        isPadPro = setIsPadPro()
        
        isNewOrientation = (orientation != tempOrientation)
        tempOrientation = orientation
        
        isNewScreenClass = (screenClass != tempScreenClass)
        tempScreenClass = screenClass
        
        isNewWidthClass = (widthClass != tempWidthClass)
        tempWidthClass = widthClass
        
        isNewHeightClass = (heightClass != tempHeightClass)
        tempHeightClass = heightClass
        
        if isNewOrientation || isNewScreenClass || isNewWidthClass || isNewHeightClass {
            NSNotificationCenter.defaultCenter()
                .postNotificationName(DittoDimensionsDidChange, object: nil)
        }
        
    }
    
    
    
    // MARK: Setters
    
    private static func setOrientation() -> Orientation {
        return UIApplication.sharedApplication().statusBarOrientation == .LandscapeLeft
            || UIApplication.sharedApplication().statusBarOrientation == .LandscapeRight
            ? .Landscape
            : .Portrait
    }
    
    private static func setDeviceClass() -> ScreenClass {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            return .Pad
        }
        else {
            return .Phone
        }
    }
    
    private static func setScreenClass() -> ScreenClass {
        if deviceClass == ScreenClass.Phone {
            return .Phone
        }
        
        if configuration.treatsMultitaskingPadAsPhoneInPortrait {
            if orientation == Orientation.Portrait && screenWidth < deviceWidth {
                return .Phone
            }
        }
        
        if configuration.treatsMultitaskingPadAsPhoneInLandscapeSecondary {
            if orientation == Orientation.Landscape && screenWidth < deviceWidth / 2 - 10 {
                return .Phone
            }
        }
        
        return .Pad
    }
    
    private static func setHeightClass() -> SizeClass {
        if screenClass == ScreenClass.Phone {
            if screenHeight < configuration.breakpoints.phoneHeightSmall {
                return .Small
            }
            if screenHeight < configuration.breakpoints.phoneHeightMedium {
                return .Medium
            }
            return .Large
        }
        
        if screenHeight < configuration.breakpoints.padHeightSmall {
            return .Small
        }
        
        // There is currenly no concept of Medium Pad
        
        return .Large
    }
    
    private static func setWidthClass() -> SizeClass {
        if screenClass == ScreenClass.Phone {
            if screenWidth < configuration.breakpoints.phoneWidthSmall {
                return .Small
            }
            
            if screenWidth < configuration.breakpoints.phoneWidthMedium {
                return .Medium
            }
        }
        
        if screenWidth < configuration.breakpoints.padWidthSmall {
            return .Small
        }
        
        if screenWidth < configuration.breakpoints.padWidthMedium {
            return .Medium
        }
        
        return .Large
    }
    
    private static func setResolutionClass() -> DensityClass {
        if !UIScreen.mainScreen().respondsToSelector(#selector(NSDecimalNumberBehaviors.scale)) {
            return DensityClass.Low
        }
        
        if UIScreen.mainScreen().scale >= 3.0 {
            return DensityClass.High
        }
        
        if UIScreen.mainScreen().scale >= 2.0 {
            return DensityClass.Medium
        }
        
        return DensityClass.Low
    }
    
    private static func setHeightOversize() -> Bool {
        return screenClass == ScreenClass.Phone
            && screenHeight >= configuration.heightOversizeThreshold
    }
    
    private static func setIsMultitasking() -> Bool {
        return screenWidth < deviceWidth
    }
    
    private static func setIsPadPro() -> Bool {
        return deviceClass == .Pad && (screenWidth == 1366 || screenHeight == 1366)
    }
    
}