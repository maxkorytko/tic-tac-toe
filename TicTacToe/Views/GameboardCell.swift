//
//  GameboardCell.swift
//  TicTacToe
//
//  Created by Max Korytko on 2025-03-19.
//

import Foundation
import UIKit

final class GameboardCell: UICollectionViewCell {
    var item: Gameboard.Square? {
        didSet {
            updateUI()
        }
    }

    private let marker: Marker = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = .gray
    }

    private func updateUI() {
        switch item?.owner {
        case .o:
            draw("o")
        case .x:
            draw("x")
        case nil:
            displayEmpty()
        }
    }

    private func draw(_ shape: String) {
        setupMarker()
        marker.draw(shape)
    }

    private func displayEmpty() {
        marker.removeFromSuperlayer()
    }

    private func setupMarker() {
        if marker.superlayer == nil {
            contentView.layer.insertSublayer(marker, at: 0)
        }
        marker.backgroundColor = UIColor.gray.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        marker.frame = contentView.bounds.insetBy(
            dx: bounds.size.width * 0.15,
            dy: bounds.size.height * 0.15
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        item = nil
    }
}

// MARK: - Marker

private final class Marker: CALayer {
    private enum Constants {
        static let lineWidth: CGFloat = 5
    }

    private var shape: String?

    override init() {
        super.init()
        setup()
    }

    override init(layer: Any) {
        super.init(layer: layer)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentsScale = UIScreen.main.scale
    }

    func draw(_ shape: String) {
        self.shape = shape
        setNeedsDisplay()
    }

    override func draw(in ctx: CGContext) {
        super.draw(in: ctx)

        ctx.clear(bounds)
        ctx.setLineWidth(Constants.lineWidth)
        ctx.setStrokeColor(UIColor.black.cgColor)

        if shape == "o" {
            ctx.addEllipse(in: bounds.insetBy(dx: Constants.lineWidth / 2, dy: Constants.lineWidth / 2))
        } else if shape == "x" {
            ctx.move(to: bounds.origin)
            ctx.addLine(to: .init(x: bounds.maxX, y: bounds.maxY))
            ctx.move(to: .init(x: 0, y: bounds.maxY))
            ctx.addLine(to: .init(x: bounds.maxX, y: 0))
        }

        ctx.strokePath()
    }
}
