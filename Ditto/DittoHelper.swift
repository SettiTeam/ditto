//
//  DittoHelper.swift
//  Pods
//
//  Created by Chase McClure on 6/10/16.
//
//

import Foundation

public class DittoHelpers {
    
    public static func setEqualHorizontalConstraints(superView: UIView, views: [ UIView ], toView: UIView? = nil) {

        let toView = toView ?? superView
        
        for (index, view) in views.enumerate() {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .Leading,
                        relatedBy: .Equal,
                        toItem: superView,
                        attribute: .Leading,
                        multiplier: 1,
                        constant: 0))
            }
            else {
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .Leading,
                        relatedBy: .Equal,
                        toItem: views[index - 1],
                        attribute: .Trailing,
                        multiplier: 1,
                        constant: 0))
                
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .Width,
                        relatedBy: .Equal,
                        toItem: views[0],
                        attribute: .Width,
                        multiplier: 1,
                        constant: 0))
            }
            
            if index == views.count - 1 {                
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .Trailing,
                        relatedBy: .Equal,
                        toItem: superView,
                        attribute: .Trailing,
                        multiplier: 1,
                        constant: 0))
            }
            
        }
    
    }
    
    
    
    public static func setEqualVerticalConstraints(superView: UIView, views: [ UIView ], toView: UIView? = nil) {
        
        let toView = toView ?? superView
        
        for (index, view) in views.enumerate() {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .Top,
                        relatedBy: .Equal,
                        toItem: superView,
                        attribute: .Top,
                        multiplier: 1,
                        constant: 0))
            }
            else {
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .Top,
                        relatedBy: .Equal,
                        toItem: views[index - 1],
                        attribute: .Bottom,
                        multiplier: 1,
                        constant: 0))
                
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .Height,
                        relatedBy: .Equal,
                        toItem: views[0],
                        attribute: .Height,
                        multiplier: 1,
                        constant: 0))
            }
            
            if index == views.count - 1 {
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .Bottom,
                        relatedBy: .Equal,
                        toItem: superView,
                        attribute: .Bottom,
                        multiplier: 1,
                        constant: 0))
            }
            
        }
        
    }
    
    
    
    public static func setFullVerticalConstraints(superView: UIView, views: [ UIView ], toView: UIView? = nil) {
        
        let toView = toView ?? superView

        for view in views {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            toView.addConstraints([
                NSLayoutConstraint(
                    item: view,
                    attribute: .Top,
                    relatedBy: .Equal,
                    toItem: superView,
                    attribute: .Top,
                    multiplier: 1,
                    constant: 0),
                
                NSLayoutConstraint(
                    item: view,
                    attribute: .Bottom,
                    relatedBy: .Equal,
                    toItem: superView,
                    attribute: .Bottom,
                    multiplier: 1,
                    constant: 0),
            ])
        }
        
    }
    
    
    
    public static func setFullHorizontalConstraints(superView: UIView, views: [ UIView ], toView: UIView? = nil) {

        let toView = toView ?? superView

        for view in views {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            toView.addConstraints([
                NSLayoutConstraint(
                    item: view,
                    attribute: .Left,
                    relatedBy: .Equal,
                    toItem: superView,
                    attribute: .Left,
                    multiplier: 1,
                    constant: 0),
                
                NSLayoutConstraint(
                    item: view,
                    attribute: .Right,
                    relatedBy: .Equal,
                    toItem: superView,
                    attribute: .Right,
                    multiplier: 1,
                    constant: 0),
                ])
        }
        
    }
    
    
    
    public static func setFullHorizontalAndVerticalConstraints(superView: UIView, views: [ UIView ]) {
        
        setFullHorizontalConstraints(superView, views: views)
        setFullVerticalConstraints(superView, views: views)
        
    }

}
