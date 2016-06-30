//
//  ParallaxBackground.swift
//  Cosmos
//
//  Created by sseen on 16/6/30.
//  Copyright © 2016年 C4. All rights reserved.
//

import UIKit

class ParallexBackground : CanvasController {
    let signCount : CGFloat = 12.0
    let speeds : [CGFloat] = [0.08,0.0,0.10,0.12,0.15,1.0,0.8,1.0]
    
    var scrollviewOffsetContext = 0
    var scrollviews = [InfiniteScrollView]()
    
    
    func createLayer(speed : CGFloat) -> InfiniteScrollView {
        let frame = view.bounds
        let layer = InfiniteScrollView(frame: frame)
        
        var contentSize = CGSizeMake(frame.size.width * 2.0 * signCount * speed, frame.size.height)
        // 由于和画布
        contentSize.width += speed < 1.0 ? view.frame.width : 0
        layer.contentSize = contentSize
        
        print("__ ", contentSize.width)
        
        let dx = Double(layer.contentSize.width) / 100.0
        let dy = Double(layer.contentSize.height) / Double(speeds.count + 1)
        var center = Point(dx, Double(scrollviews.count + 1) * dy)
        let fontSize = Double(scrollviews.count + 1) * 6.0
        let font = Font(name:"AvenirNext-DemiBold", size: fontSize)!
        repeat {
            let label = TextShape(text: "\(scrollviews.count)", font: font)!
            label.center = center
            layer.add(label)
            center.x += dx
        } while center.x < Double(layer.contentSize.width)
        
        return layer
    }
    
    override func setup() {
        for i in 0..<speeds.count {
            let layer = createLayer(speeds[i])
            canvas.add(layer)
            scrollviews.append(layer)
        }
        
        if let topLayer = scrollviews.last {
            topLayer.addObserver(self, forKeyPath: "contentOffset", options: .New, context: &scrollviewOffsetContext)
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &scrollviewOffsetContext {
            let sv = object as! InfiniteScrollView
            let offset = sv.contentOffset
        
            for i in 0..<scrollviews.count - 1 {
                let layer = scrollviews[i]
                layer.contentOffset = CGPointMake(offset.x * speeds[i], 0.0)
                
                print(i, layer.contentOffset.x, offset.x, layer.contentSize.width)
            }
        }
    }
}
