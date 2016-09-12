//
//  Ditto.swift
//  Ditto
//
//  Created by 🍕Chase McClure on 8/9/16.
//  Copyright (c) 2016 Curiosity. All rights reserved.
//

import Foundation

class DittoWeakView {
    weak var view: UIView?

    init(view: UIView) {
        self.view = view
    }
}

public class Ditto {

    private static var configuration: DittoConfiguration!
    private static var layoutSheet: DittoSheet = [:]

    private var keys: [ String ]!
    private weak var superView: UIView!
    private var weakViews: [ String: DittoWeakView ] = [:]
    private var blocks: [[ DittoBlock ]] = []
    private var onDimensionChange: (() -> ())?
    private var onScreenClassChange: (() -> ())?


    public init(
        keys: [ String ] = [],
        superView: UIView,
        views: [ String: UIView? ],
        layoutImmediately immediately: Bool = false,
        additionalBlocks: [[ DittoBlock ]] = [],
        onDimensionChange: (() -> ())? = nil,
        onScreenClassChange: (() -> ())? = nil
    ) {
        self.keys = keys
        self.onDimensionChange = onDimensionChange
        self.onScreenClassChange = onScreenClassChange

        // Parse and prepare views

        weakViews["super"] = DittoWeakView(view: superView)
        self.superView = superView

        for (key, view) in views {
            if let view = view {
                view.translatesAutoresizingMaskIntoConstraints = false
                self.weakViews[key] = DittoWeakView(view: view)
            }
        }


        // Add Relevent Blocks

        for key in keys {
            if let b = Ditto.layoutSheet[key] {
                blocks.append(b)
            }
        }

        for b in additionalBlocks {
            blocks.append(b)
        }


        // Prepare for Auto Update

        registerDimensionsDidChangeNotification()


        // Apply the initial layout

        layout(immediately: immediately)

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public func layout(immediately: Bool) {
        if superView == nil {
            return
        }

        for group in blocks {

            if let block = getMatchedBlock(group) {

                if !block.constraints.isEmpty {
                    superView.addConstraints(block.constraints)
                }

                for string in block.strings {

                    // CenterH:
                    if string.contains("CenterH:") {
                        addCenterHConstraint(withString: string)
                    }
                    // CenterV:
                    else if string.contains("CenterV:") {
                        addCenterVConstraint(withString: string)
                    }
                    // Center:
                    else if string.contains("Center:") {
                        addCenterConstraint(withString: string)
                    }
                    // VFL
                    else {
                        addVFLConstraint(withString: string)
                    }

                }
            }
        }

        if immediately {
            superView.setNeedsLayout()
            superView.layoutIfNeeded()
        }

    }

    private func addCenterHConstraint(withString string: String) {
        // "CenterH:[super[sub]]"

        var string = String(string.characters.dropFirst(9)) // "super[sub]]"
        string = String(string.characters.dropLast(2)) // "super[sub"

        let strings = string.characters.split{ $0 == "[" }.map(String.init)

        guard
            let outer = weakViews[strings[0]]?.view,
            let inner = weakViews[strings[1]]?.view
        else {
            print("CenterH: Constraint can't be set.")
            return
        }

        superView.addConstraint(
            NSLayoutConstraint(
                item: inner,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: outer,
                attribute: .centerX,
                multiplier: 1,
                constant: 0))
    }

    private func addCenterVConstraint(withString string: String) {
        // "CenterV:[super[sub]]"

        var string = String(string.characters.dropFirst(9)) // "super[sub]]"
        string = String(string.characters.dropLast(2)) // "super[sub"

        let strings = string.characters.split{ $0 == "[" }.map(String.init)

        guard
            let outer = weakViews[strings[0]]?.view,
            let inner = weakViews[strings[1]]?.view
        else {
            print("CenterV: Constraint can't be set.")
            return
        }

        superView.addConstraint(
            NSLayoutConstraint(
                item: inner,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: outer,
                attribute: .centerY,
                multiplier: 1,
                constant: 0))
    }

    private func addCenterConstraint(withString string: String) {
        // "Center:[super[sub]]"

        var string = String(string.characters.dropFirst(8)) // "super[sub]]"
        string = String(string.characters.dropLast(2)) // "super[sub"

        let strings = string.characters.split{ $0 == "[" }.map(String.init)

        guard
            let outer = weakViews[strings[0]]?.view,
            let inner = weakViews[strings[1]]?.view
        else {
            print("Center: Constraint can't be set.")
            return
        }

        superView.addConstraints([

            NSLayoutConstraint(
                item: inner,
                attribute: .centerX,
                relatedBy: .equal,
                toItem: outer,
                attribute: .centerX,
                multiplier: 1,
                constant: 0),

            NSLayoutConstraint(
                item: inner,
                attribute: .centerY,
                relatedBy: .equal,
                toItem: outer,
                attribute: .centerY,
                multiplier: 1,
                constant: 0) ])
    }

    private func addVFLConstraint(withString string: String) {
        var views: [ String: UIView ] = [:]

        for (key, weakView) in weakViews {
            views[key] = weakView.view!
        }

        superView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: string,
                options: [],
                metrics: nil,
                views: views ))
    }



    // MARK: Match Blocks

    private func getMatchedBlock(_ blocks: [ DittoBlock ]) -> DittoBlock? {
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



    // MARK: Dimension Change for Auto Update

    private func registerDimensionsDidChangeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onDimensionsDidChange),
            name: NSNotification.Name(rawValue: DittoDimensionsDidChange),
            object: nil)
    }

    @objc private func onDimensionsDidChange() {
        if onScreenClassChange != nil && DittoDimensions.isNewScreenClass {
            return onScreenClassChange!()
        }

        if onDimensionChange != nil {
            return onDimensionChange!()
        }

        layout(immediately: true)
    }



    // MARK: Initialize the Layout Engine

    /**
     Prepares Layout for use

     - Parameter sheets: LayoutSheets to be considered
     - Parameter config: Configuration used
     */
    public static func initialize(_ sheets: [ DittoSheet ], configuration: DittoConfiguration? = nil) {
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
        width: SizeClass? = nil,
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
        width: SizeClass? = nil,
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
            devices: [ .phone ],
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
        width: SizeClass? = nil,
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
            devices: [ .pad ],
            widths: widths,
            heights: heights,
            constraints: constraints,
            strings: strings )
    }

}
