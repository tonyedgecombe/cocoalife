//
//  drawingView.swift
//  cocoalife
//
//  Created by Tony Edgecombe on 12/04/2020.
//  Copyright © 2020 Tony Edgecombe. All rights reserved.
//

import Cocoa

class DrawingView: NSView {

    var currentImage:[[Bool]]
    let columns = 32
    let rows = 32
    
    var timer: Timer? = nil

    required init?(coder:NSCoder) {
        currentImage = Array(repeating: Array(repeating: false, count: columns), count: rows)

        super.init(coder: coder)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        let backgroundColor = NSColor.black
        backgroundColor.set()
        dirtyRect.fill()
        
        let lineWidth:CGFloat = 2.0
        let bounds = self.bounds
        
        let viewWidth = bounds.width - lineWidth
        let viewHeight = bounds.height - lineWidth
        
        let cellWidth = viewWidth / CGFloat(columns)
        let cellHeight = viewHeight / CGFloat(rows)

        let color = NSColor.gray
        color.set()

        for i in 0...columns {
            let rect = NSMakeRect(CGFloat(i) * cellWidth, 0.0, lineWidth, viewHeight)
            rect.fill()
        }
        
        for i in 0...rows {
            let rect = NSMakeRect(0.0, CGFloat(i) * cellHeight, viewWidth, lineWidth)
            rect.fill()
        }
        
        
        for x in 0..<columns {
            for y in 0..<rows {
                let cellColor = currentImage[x][y] ? NSColor.white : backgroundColor
                cellColor.set()
                let rect = NSMakeRect(
                    CGFloat(x) * cellWidth + lineWidth,
                    CGFloat(y) * cellHeight + lineWidth,
                    cellWidth - lineWidth,
                    cellHeight - lineWidth)
                
                rect.fill()
            }
        }
    }
    
    override func mouseUp(with event: NSEvent) {
        let lineWidth:CGFloat = 2.0
        let bounds = self.bounds
        
        let viewWidth = bounds.width - lineWidth
        let viewHeight = bounds.height - lineWidth
        
        let cellWidth = viewWidth / CGFloat(columns)
        let cellHeight = viewHeight / CGFloat(rows)

        let location = self.convert(event.locationInWindow, from: nil)

        var x = Int(location.x / cellWidth)
        var y = Int(location.y / cellHeight)
        
        if x >= columns {
            x = columns - 1
        }
        
        if y >= rows {
            y = rows - 1
        }
        
        currentImage[x][y] = !currentImage[x][y]
        
        self.setNeedsDisplay(bounds)
    }
    
    func start() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {timer in
            self.updateCells()
        }
    }
    
    func stop() {
        self.timer?.invalidate()
    }

    func updateCells() {
        var newImage = Array(repeating: Array(repeating: false, count: columns), count: rows)

        for x in 0..<columns {
            for y in 0..<rows {
                let neighbours = countNeighbours(x: x, y: y)
                if currentImage[x][y] {
                    newImage[x][y] = neighbours == 2 || neighbours == 3
                }
                else {
                    newImage[x][y] = neighbours == 3
                }
            }
        }
        
        currentImage = newImage
        self.setNeedsDisplay(self.bounds)
    }
    
    func countNeighbours(x: Int, y: Int) -> Int {
        let startX = x == 0 ? 0 : -1
        let endX = x == columns - 1 ? 0 : 1
        let startY = y == 0 ? 0 : -1
        let endY = y == rows - 1 ? 0 : 1
        
        var result = 0
        
        for i in startX...endX {
            for j in startY...endY {
                if i == 0 && j == 0 { // Current cell
                    continue
                }
                
                if currentImage[x + i][y + j] {
                    result += 1
                }
            }
        }
        
        return result
    }
}
