//
//  DittoDimensions.swift
//  Ditto
//
//  Created by Chase McClure on 11/19/15.
//  Copyright (c) 2015 Giant Slide Game Company. All rights reserved.
//

import Foundation

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
        
        deviceWidth = UIScreen.main.bounds.width
        deviceHeight = UIScreen.main.bounds.height
        screenWidth = UIApplication.shared.keyWindow!.bounds.width
        screenHeight = UIApplication.shared.keyWindow!.bounds.height
        
        orientation = setOrientation()
        deviceClass = setDeviceClass()
        screenClass = setScreenClass()
        heightClass = setHeightClass()
        widthClass = setWidthClass()
        resolutionClass = setResolutionClass()
        
        isRetina = UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) && UIScreen.main.scale >= 2.0
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
            NotificationCenter.default
                .post(
                    name: DittoNotification.dimensionsDidChange, object: nil,
                    userInfo: [
                        "isNewScreenClass": isNewScreenClass ])
        }
        
    }
    
    
    
    // MARK: Setters
    
    private static func setOrientation() -> Orientation {
        return UIApplication.shared.statusBarOrientation == .landscapeLeft
            || UIApplication.shared.statusBarOrientation == .landscapeRight
            ? .landscape
            : .portrait
    }
    
    private static func setDeviceClass() -> ScreenClass {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .pad
        }
        else {
            return .phone
        }
    }
    
    private static func setScreenClass() -> ScreenClass {
        if deviceClass == ScreenClass.phone {
            return .phone
        }
        
        if configuration.treatsMultitaskingPadAsPhoneInPortrait {
            if orientation == Orientation.portrait && screenWidth < deviceWidth {
                return .phone
            }
        }
        
        if configuration.treatsMultitaskingPadAsPhoneInLandscapeSecondary {
            if orientation == Orientation.landscape && screenWidth < deviceWidth / 2 - 10 {
                return .phone
            }
        }
        
        return .pad
    }
    
    private static func setHeightClass() -> SizeClass {
        if screenClass == ScreenClass.phone {
            if screenHeight < configuration.breakpoints.phoneHeightSmall {
                return .small
            }
            if screenHeight < configuration.breakpoints.phoneHeightMedium {
                return .medium
            }
            return .large
        }
        
        if screenHeight < configuration.breakpoints.padHeightSmall {
            return .small
        }
        
        // There is currenly no concept of Medium Pad
        
        return .large
    }
    
    private static func setWidthClass() -> SizeClass {
        if screenClass == ScreenClass.phone {
            if screenWidth < configuration.breakpoints.phoneWidthSmall {
                return .small
            }
            
            if screenWidth < configuration.breakpoints.phoneWidthMedium {
                return .medium
            }
        }
        
        if screenWidth < configuration.breakpoints.padWidthSmall {
            return .small
        }
        
        if screenWidth < configuration.breakpoints.padWidthMedium {
            return .medium
        }
        
        if screenWidth < configuration.breakpoints.padWidthLarge {
            return .large
        }
        
        return .xlarge
    }
    
    private static func setResolutionClass() -> DensityClass {
        if !UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) {
            return DensityClass.low
        }
        
        if UIScreen.main.scale >= 3.0 {
            return DensityClass.high
        }
        
        if UIScreen.main.scale >= 2.0 {
            return DensityClass.medium
        }
        
        return DensityClass.low
    }
    
    private static func setHeightOversize() -> Bool {
        return screenClass == ScreenClass.phone
            && screenHeight >= configuration.heightOversizeThreshold
    }
    
    private static func setIsMultitasking() -> Bool {
        return screenWidth < deviceWidth
    }
    
    private static func setIsPadPro() -> Bool {
        return deviceClass == .pad && (screenWidth == 1366 || screenHeight == 1366)
    }
    
}
 
