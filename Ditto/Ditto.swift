//
//  Layout.swift
//  DailyCuriosity
//
//  Created by Chase McClure on 11/19/15.
//  Copyright © 2015 Curiosity. All rights reserved.
//

import Foundation

@objc public protocol DittoLayoutable {
    func teardownLayout()
}

public class Ditto {
    
    private static var configuration: DittoConfiguration!
    private static var layoutSheet: DittoSheet = [:]
    
    private let keys: [ String ]
    private weak var view: UIView!
    private var views: [ String: UIView ] = [:]
    private var blocks: [[ DittoBlock ]] = []
    private var currentConstraints: [ NSLayoutConstraint ] = []
    
    
    public init(
        key: String? = nil,
        keys: [ String ] = [],
        view: UIView,
        views: [ String: UIView ],
        placeholders: [ String ] = [],
        additionalBlocks: [[ DittoBlock ]] = []
    ) {
        var keys = keys
        var views = views
        
        if key != nil {
            keys.append(key!)
        }
        
        self.keys = keys
        self.view = view
        
        // add blocks from sheets
        for key in keys {
            if let b = Ditto.layoutSheet[key] {
                blocks.append(b)
            }
        }
        
        // add additional blocks
        for b in additionalBlocks {
            blocks.append(b)
        }
        
        // Prepare views
        for s in placeholders {
            if views[s] == nil {
                let v = UIView()
                v.hidden = true
                view.addSubview(v)
                views[s] = v
            }
        }
        
        for (_, v) in views {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // set super view
        views["super"] = view
        self.views = views
        
        //        DittoTracker.open(key)
        
        // prepare for auto update
        registerDimensionsDidChangeNotification()
        
    }
    
    deinit {
        //        DittoTracker.close(key)
        view = nil
        views = [:]
        currentConstraints = []
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    public func set(immediate: Bool = false) {
        removeConstraints()
        
        for group in blocks {
            if let block = getMatchedBlock(group) {
                
                if !block.constraints.isEmpty {
                    currentConstraints.appendContentsOf(block.constraints)
                    view.addConstraints(block.constraints)
                }
                
                for string in block.strings {
                    
                    // CenterX:
                    if string.containsString("CenterX:") {
                        addCenterXConstraint(string)
                    }
                        // CenterY:
                    else if string.containsString("CenterY:") {
                        addCenterYConstraint(string)
                    }
                        // Hide:
                    else if string.containsString("Hide:") {
                        hideView(string)
                    }
                        // Show:
                    else if string.containsString("Show:") {
                        showView(string)
                    }
                        // VFL
                    else {
                        addVFLConstraint(string)
                    }
                    
                }
            }
        }
        
        if (immediate) {
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
        
    }
    
    private func addCenterXConstraint(string: String) {
        var string = String(string.characters.dropFirst(9))
        string = String(string.characters.dropLast(2))
        
        let views = string.characters.split{$0 == "["}.map(String.init)
        
        if self.views[views[1]] == nil {
            print("CenterX: Constraint can't be set. Missing inner view \(views[1])")
            return
        }
        
        if self.views[views[0]] == nil {
            print("CenterX: Constraint can't be set. Missing outer view \(views[0])")
            return
        }
        
        let c = NSLayoutConstraint(
            item: self.views[views[1]]!,
            attribute: .CenterX,
            relatedBy: .Equal,
            toItem: self.views[views[0]],
            attribute: .CenterX,
            multiplier: 1,
            constant: 0)
        
        currentConstraints.append(c)
        view.addConstraint(c)
    }
    
    private func addCenterYConstraint(string: String) {
        var string = String(string.characters.dropFirst(9))
        string = String(string.characters.dropLast(2))
        
        let views = string.characters.split{$0 == "["}.map(String.init)
        
        if self.views[views[1]] == nil {
            print("CenterY: Constraint can't be set. Missing inner view \(views[1])")
            return
        }
        
        if self.views[views[0]] == nil {
            print("CenterY: Constraint can't be set. Missing outer view \(views[0])")
            return
        }
        
        let c = NSLayoutConstraint(
            item: self.views[views[1]]!,
            attribute: .CenterY,
            relatedBy: .Equal,
            toItem: self.views[views[0]]!,
            attribute: .CenterY,
            multiplier: 1,
            constant: 0)
        
        currentConstraints.append(c)
        view.addConstraint(c)
    }
    
    private func hideView(string: String) {
        var string = String(string.characters.dropFirst(6))
        string = String(string.characters.dropLast(1))
        
        views[string]?.hidden = true
    }
    
    private func showView(string: String) {
        var string = String(string.characters.dropFirst(6))
        string = String(string.characters.dropLast(1))
        
        views[string]?.hidden = false
    }
    
    private func addVFLConstraint(string: String) {
        let c = NSLayoutConstraint.constraintsWithVisualFormat(
            string,
            options: [],
            metrics: nil,
            views: views )
        
        currentConstraints.appendContentsOf(c)
        view.addConstraints(c)
    }
    
    
    
    // MARK: Match Blocks
    
    private func getMatchedBlock(blocks: [ DittoBlock ]) -> DittoBlock? {
        var block: DittoBlock!
        var score = -1
        
        for b in blocks {
            let s = b.match()
            
            if s > score {
                block = b
                score = s
            }
        }
        
        return block
    }
    
    
    
    // MARK: Remove Constraints
    
    public func removeConstraints() {
        for c in currentConstraints {
            c.active = false
        }
        
        currentConstraints = []
    }
    
    private func registerDimensionsDidChangeNotification() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(onDimensionsDidChange),
            name: DittoDimensionsDidChange,
            object: nil)
    }
    
    @objc private func onDimensionsDidChange() {
        set(true)
    }
    
    
    
    /*
     * Cleans up an array of views that have layouts
     */
    public static func cleanUp(views: AnyObject) {
        if let v = views as? [ DittoLayoutable? ] {
            for view in v {
                view?.teardownLayout()
            }
        }
    }
    
    public static func cleanUp(view: DittoLayoutable?) {
        view?.teardownLayout()
    }
    
    
    
    
    // MARK: Initialize the Layout Engine
    
    /**
     Prepares Layout for use
     
     - Parameter sheets: LayoutSheets to be considered
     - Parameter config: Configuration used
     */
    public static func initialize(sheets: [ DittoSheet ], configuration: DittoConfiguration? = nil) {
        // Combine all sheets into a single private sheet
        for sheet in sheets {
            for (key, def) in sheet {
                layoutSheet[key] = def
            }
        }
        
        // Create default configuration if one is not passed
        if configuration != nil {
            self.configuration = configuration
        }
        else {
            self.configuration = DittoConfiguration()
        }
        
        DittoDimensions.configuration = self.configuration
        
        Ditto.updateDimensions()
    }
    
    
    
    // MARK: Update Dimensions
    
    public static func updateDimensions() {
        DittoDimensions.set()
    }
    
    
    
    // MARK: Convenience methods for creating a LayoutBlock
    
    /**
     Initializes a new LayoutBlock targeted for all devices
     
     - Parameter width: Width to target
     - Parameter height: Height to target
     - Parameter widths: Widths to target
     - Parameter heights: Heights to target
     - Parameter constraints: Prebuilt NSLayoutConstraints
     - Parameter strings: XVFL strings
     
     - Returns: A targeted LayoutBlock
     */
    public static func Universal(
        width width: SizeClass? = nil,
              height: SizeClass? = nil,
              widths: [ SizeClass ] = [],
              heights: [ SizeClass ] = [],
              constraints: [ NSLayoutConstraint ] = [],
              strings: [ String ] = []
        ) -> DittoBlock {
        var widths = widths
        var heights = heights
        
        if let w = width {
            widths = [ w ]
        }
        
        if let h = height {
            heights = [ h ]
        }
        
        return DittoBlock(
            devices: [],
            widths: widths,
            heights: heights,
            constraints: constraints,
            strings: strings )
    }
    
    /**
     Initializes a new LayoutBlock targeted for phones
     
     - Parameter width: Width to target
     - Parameter height: Height to target
     - Parameter widths: Widths to target
     - Parameter heights: Heights to target
     - Parameter constraints: Prebuilt NSLayoutConstraints
     - Parameter strings: XVFL strings
     
     - Returns: A targeted LayoutBlock
     */
    public static func Phone(
        width width: SizeClass? = nil,
              height: SizeClass? = nil,
              widths: [ SizeClass ] = [],
              heights: [ SizeClass ] = [],
              constraints: [ NSLayoutConstraint ] = [],
              strings: [ String ] = []
        ) -> DittoBlock {
        var widths = widths
        var heights = heights
        
        if let w = width {
            widths = [ w ]
        }
        
        if let h = height {
            heights = [ h ]
        }
        
        return DittoBlock(
            devices: [ .Phone ],
            widths: widths,
            heights: heights,
            constraints: constraints,
            strings: strings )
    }
    
    /**
     Initializes a new LayoutBlock targeted for pads
     
     - Parameter width: Width to target
     - Parameter height: Height to target
     - Parameter widths: Widths to target
     - Parameter heights: Heights to target
     - Parameter constraints: Prebuilt NSLayoutConstraints
     - Parameter strings: XVFL strings
     
     - Returns: A targeted LayoutBlock
     */
    public static func Pad(
        width width: SizeClass? = nil,
              height: SizeClass? = nil,
              widths: [ SizeClass ] = [],
              heights: [ SizeClass ] = [],
              constraints: [ NSLayoutConstraint ] = [],
              strings: [ String ] = []
        ) -> DittoBlock {
        var widths = widths
        var heights = heights
        
        if let w = width {
            widths = [ w ]
        }
        
        if let h = height {
            heights = [ h ]
        }
        
        return DittoBlock(
            devices: [ .Pad ],
            widths: widths,
            heights: heights,
            constraints: constraints,
            strings: strings )
    }
    
}
