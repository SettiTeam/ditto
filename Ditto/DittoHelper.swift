//
//  DittoHelper.swift
//  Ditto
//
//  Created by Chase McClure on 11/22/15.
//  Copyright (c) 2015 Giant Slide Game Company. All rights reserved.
//

import Foundation

public class DittoHelpers {
    
    public static func addEqualHConstraints(withSuperView superView: UIView, views: [ UIView ], toView: UIView? = nil) {

        let toView = toView ?? superView
        
        for (index, view) in views.enumerated() {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .leading,
                        relatedBy: .equal,
                        toItem: superView,
                        attribute: .leading,
                        multiplier: 1,
                        constant: 0))
            }
            else {
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .leading,
                        relatedBy: .equal,
                        toItem: views[index - 1],
                        attribute: .trailing,
                        multiplier: 1,
                        constant: 0))
                
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .width,
                        relatedBy: .equal,
                        toItem: views[0],
                        attribute: .width,
                        multiplier: 1,
                        constant: 0))
            }
            
            if index == views.count - 1 {                
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .trailing,
                        relatedBy: .equal,
                        toItem: superView,
                        attribute: .trailing,
                        multiplier: 1,
                        constant: 0))
            }
            
        }
    
    }
    
    
    
    public static func addEqualVConstraints(withSuperView superView: UIView, views: [ UIView ], toView: UIView? = nil) {
        
        let toView = toView ?? superView
        
        for (index, view) in views.enumerated() {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .top,
                        relatedBy: .equal,
                        toItem: superView,
                        attribute: .top,
                        multiplier: 1,
                        constant: 0))
            }
            else {
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .top,
                        relatedBy: .equal,
                        toItem: views[index - 1],
                        attribute: .bottom,
                        multiplier: 1,
                        constant: 0))
                
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .height,
                        relatedBy: .equal,
                        toItem: views[0],
                        attribute: .height,
                        multiplier: 1,
                        constant: 0))
            }
            
            if index == views.count - 1 {
                toView.addConstraint(
                    NSLayoutConstraint(
                        item: view,
                        attribute: .bottom,
                        relatedBy: .equal,
                        toItem: superView,
                        attribute: .bottom,
                        multiplier: 1,
                        constant: 0))
            }
            
        }
        
    }
    
    
    
    public static func addFullVConstraints(withSuperView superView: UIView, views: [ UIView ], toView: UIView? = nil) {
        
        let toView = toView ?? superView

        for view in views {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            toView.addConstraints([
                NSLayoutConstraint(
                    item: view,
                    attribute: .top,
                    relatedBy: .equal,
                    toItem: superView,
                    attribute: .top,
                    multiplier: 1,
                    constant: 0),
                
                NSLayoutConstraint(
                    item: view,
                    attribute: .bottom,
                    relatedBy: .equal,
                    toItem: superView,
                    attribute: .bottom,
                    multiplier: 1,
                    constant: 0),
            ])
        }
        
    }
    
    
    
    public static func addFullHConstraints(withSuperView superView: UIView, views: [ UIView ], toView: UIView? = nil) {

        let toView = toView ?? superView

        for view in views {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            
            toView.addConstraints([
                NSLayoutConstraint(
                    item: view,
                    attribute: .left,
                    relatedBy: .equal,
                    toItem: superView,
                    attribute: .left,
                    multiplier: 1,
                    constant: 0),
                
                NSLayoutConstraint(
                    item: view,
                    attribute: .right,
                    relatedBy: .equal,
                    toItem: superView,
                    attribute: .right,
                    multiplier: 1,
                    constant: 0),
                ])
        }
        
    }
    
    
    
    open static func addFullConstraints(withSuperView superView: UIView, views: [ UIView ], toView: UIView? = nil) {
        addFullHConstraints(withSuperView: superView, views: views, toView: toView)
        addFullVConstraints(withSuperView: superView, views: views, toView: toView)
    }

}
