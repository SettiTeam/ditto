//
//  DittoTracker.swift
//  DailyCuriosity
//
//  Created by Chase McClure on 11/22/15.
//  Copyright © 2015 Curiosity. All rights reserved.
//

import Foundation

public class DittoTracker {
    
    //    static let config = (
    //        timer: false,
    //        interval: NSTimeInterval(5),
    //        whitelist: [ String ]() )
    //
    //    class Item {
    //
    //        var count = 0
    //        var labels = [ String ]()
    //
    //        init(label: String?) {
    //            add(label)
    //        }
    //
    //        func add(label: String?) {
    //            count++
    //            if label != nil {
    //                labels.append(label!)
    //            }
    //        }
    //
    //        func remove(label: String?) {
    //            count--
    //            if label != nil {
    //                if let index = labels.indexOf(label!) {
    //                    labels.removeAtIndex(index)
    //                }
    //            }
    //        }
    //
    //    }
    //
    //    static var items: Dictionary<String, Item> = [:]
    //    static var timer: PDKTimer!
    //
    //    static func initialize() {
    //        if config.timer {
    //            startTimer()
    //        }
    //    }
    //
    //    static func open(type: String, label: String? = nil) {
    //        if config.whitelist.isEmpty || config.whitelist.indexOf(type) != nil {
    //            if items[type] == nil {
    //                items[type] = Item(label: label)
    //            }
    //            else {
    //                items[type]?.add(label)
    //            }
    //        }
    //    }
    //
    //    static func close(type: String, label: String? = nil) {
    //        items[type]?.remove(label)
    //    }
    //
    //    static func startTimer() {
    //        timer = PDKTimer.every(config.interval) {
    //            var total = 0
    //
    //            print("+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+")
    //            print("Plumber Status")
    //
    //            for (type, item) in items {
    //                total += item.count
    //
    //                var string = "\(String(format: "%02d", item.count)): \(type)"
    //
    //
    //                if !item.labels.isEmpty {
    //                    string += " \(String(item.labels))"
    //                }
    //                
    //                print(string)
    //            }
    //            
    //            print("Total Item Count: \(total)")
    //            
    //        }
    //    }
    
}

