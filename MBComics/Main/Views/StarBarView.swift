//
//  StarBarView.swift
//  MBComics
//
//  Created by HoaPQ on 6/13/20.
//  Copyright © 2020 HoaPQ. All rights reserved.
//

import UIKit

struct BarEntry {
    let score: Int
    let title: String
}

class StarBarView: UIView {
    
    // MARK: - Outlets
    private let mainLayer: CALayer = CALayer()
    
    // MARK: - Values
    var space: CGFloat = 10
    var barHeight: CGFloat = 5
    var contentSpace: CGFloat = 5.0
    var barCornerRadius: CGFloat = 2.5
    var fontSize: CGFloat = 12
    var titleFont: UIFont = .systemFont(ofSize: 20)
    var autoResize = false
    var barColor = UIColor.darkGray
    var backgroundBarColor = UIColor.lightGray
    
    private var barX: CGFloat = 144.0
    private var sumValue = 0
    private var maxLengthTitle = ""
    private var maxTitleWidth: CGFloat = 0
    
    var dataEntries: [BarEntry] = [] {
        didSet {
            updateViews()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateViews()
    }
    
    private func setupView() {
        layer.addSublayer(mainLayer)
    }
    
    private func updateViews() {
        mainLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        sumValue = max(dataEntries.reduce(0, { $0 + $1.score }), 1)
        dataEntries.forEach {
            if $0.title.count > maxLengthTitle.count {
                maxLengthTitle = $0.title
            }
        }
        
        if autoResize {
            barHeight = height / CGFloat(dataEntries.count*4+3)
            space = barHeight * 3
            calculateFontSize()
        }
        
        barX = maxLengthTitle.size(of: titleFont.withSize(fontSize)).width + contentSpace
        mainLayer.frame = CGRect(x: 0,
                                 y: 0,
                                 width: width,
                                 height: height)
        for (index, data) in dataEntries.enumerated() {
            showEntry(index: index, entry: data)
        }
    }
    
    // MARK: - Draw
    private func showEntry(index: Int, entry: BarEntry) {
        let xPos = translateWidthValue(value: CGFloat(entry.score) / CGFloat(sumValue))
        let yPos = space + CGFloat(index) * (barHeight + space)
        let titleHeight = barHeight + space * 2
        drawBar(width: xPos, yPos: yPos)
        drawTitle(xPos: 0,
                  yPos: yPos + barHeight/2 - titleHeight/2,
                  width: barX - contentSpace,
                  height: titleHeight, title: entry.title)
    }
    
    private func drawBar(width: CGFloat, yPos: CGFloat) {
        let fullWidth = self.width - barX
        let backgroundBarLayer = CALayer().then {
            $0.frame = CGRect(x: barX,
                              y: yPos,
                              width: fullWidth,
                              height: barHeight)
            $0.backgroundColor = backgroundBarColor.cgColor
            $0.cornerRadius = barCornerRadius
            $0.masksToBounds = true
        }
        mainLayer.addSublayer(backgroundBarLayer)
        
        let barLayer = CALayer().then {
            $0.frame = CGRect(x: 0,
                              y: 0,
                              width: width,
                              height: barHeight)
            $0.backgroundColor = barColor.cgColor
        }
        backgroundBarLayer.addSublayer(barLayer)
    }
    
    private func drawTitle(xPos: CGFloat,
                           yPos: CGFloat,
                           width: CGFloat,
                           height: CGFloat = 22,
                           title: String) {
        let textLayer = MBTextLayer().then {
            $0.frame = CGRect(x: xPos,
                              y: yPos,
                              width: width,
                              height: height)
            $0.foregroundColor = barColor.cgColor
            $0.backgroundColor = UIColor.clear.cgColor
            $0.alignmentMode = CATextLayerAlignmentMode.right
            $0.contentsScale = UIScreen.main.scale
            $0.font = titleFont
            $0.fontSize = fontSize
            $0.string = title
        }
        mainLayer.addSublayer(textLayer)
    }
    
    private func translateWidthValue(value: CGFloat) -> CGFloat {
        let width = value * (mainLayer.frame.width - space)
        return abs(width)
    }
    
    private func calculateFontSize() {
        let height = barHeight + space * 2
        while maxLengthTitle.size(of: titleFont.withSize(fontSize)).height >= height && height > 0 {
            fontSize -= 0.1
        }
    }
}

private class MBTextLayer: CATextLayer {
    override func draw(in context: CGContext) {
        let height = self.bounds.size.height
        let fontSize = self.fontSize
        let yDiff = (height-fontSize)/2 - fontSize/10

        context.saveGState()
        context.translateBy(x: 0, y: yDiff)
        super.draw(in: context)
        context.restoreGState()
    }
}
