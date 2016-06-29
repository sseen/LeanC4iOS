// Copyright © 2016 C4
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.
import UIKit

//three colors we'll use throughout the app, so we make them project-level variables
let cosmosprpl = Color(red:0.565, green: 0.075, blue: 0.996, alpha: 1.0)
let cosmosblue = Color(red: 0.094, green: 0.271, blue: 1.0, alpha: 1.0)
let cosmosbkgd = Color(red: 0.078, green: 0.118, blue: 0.306, alpha: 1.0)

class WorkSpace: CanvasController {
    var layers = [UIScrollView]()
    
    override func setup() {
        repeat {
            let layer = UIScrollView(frame: view.frame)
            // layer 好大 都是 10 倍的
            layer.contentSize = CGSizeMake(layer.frame.size.width * 10, 0)
            canvas.add(layer)
            layers.append(layer)
            
            var center = Point(24, canvas.height / 2.0)
            let layerNumber = 10 - layers.count
            let font = Font(name: "AvenirNext-DemiBold", size: Double(layers.count + 1) * 8.0)!
            
            repeat {
                let label = TextShape(text: "\(layerNumber)", font: font)!
                label.center = center
                center.x += 130.0
                layer.add( label )
            } while center.x < Double(layer.contentSize.width)
            
            layer.tag += 1
        } while layers.count < 10
      
        // 下一步就是创建一个观察器，查看一下最上层的 layer，在滚动时将剩下的 layer 移走。
        if let top = layers.last {
            var c = 0
            top.addObserver(self, forKeyPath:"contentOffset",  options: NSKeyValueObservingOptions.New, context: &c)
        }
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        for i in 0..<layers.count-1 {
            let layer = self.layers[i]
            let mod = 0.1 * CGFloat( i + 1 )
            if let x = layers.last?.contentOffset.x {
                layer.contentOffset = CGPointMake(x * mod, 0)
            }
        }
    }
}