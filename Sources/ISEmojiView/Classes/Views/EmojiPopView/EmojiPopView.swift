//
//  EmojiPopView.swift
//  ISEmojiView
//
//  Created by Beniamin Sarkisyan on 01/08/2018.
//

import Foundation
import UIKit

internal protocol EmojiPopViewDelegate: class {
    
    /// called when the popView needs to dismiss itself
    func emojiPopViewShouldDismiss(emojiPopView: EmojiPopView)
    
}

internal class EmojiPopView: UIView {
    
    // MARK: - Internal variables
    
    /// the delegate for callback
    internal weak var delegate: EmojiPopViewDelegate?
    
    internal var currentEmoji: String = ""
    internal var emojiArray: [String] = []
    
    // MARK: - Private variables
    
    private var locationX: CGFloat = 0.0
    
    private var emojiButtons: [UIButton] = []
    private var emojisView: UIView = UIView()
    
    private var emojisX: CGFloat = 0.0
    private var emojisWidth: CGFloat = 0.0
    
    public var theme: Theme? {
        didSet {
            
        }
    }
    
    // MARK: - Init functions
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: EmojiPopViewSize.width, height: EmojiPopViewSize.height))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Override functions
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let result = point.x >= emojisX && point.x <= emojisX + emojisWidth && point.y >= 0 && point.y <= TopPartSize.height
        
        if !result {
            dismiss()
        }
        
        return result
    }
    
    // MARK: - Internal functions
    
    internal func move(location: CGPoint, animation: Bool = true) {
        locationX = location.x
        setupUI()
        
        UIView.animate(withDuration: animation ? 0.08 : 0, animations: {
            self.alpha = 1
            self.frame = CGRect(x: location.x, y: location.y, width: self.frame.width, height: self.frame.height)
        }, completion: { complate in
            self.isHidden = false
        })
    }
    
    internal func dismiss() {
        UIView.animate(withDuration: 0.08, animations: {
            self.alpha = 0
        }, completion: { complate in
            self.isHidden = true
        })
    }
    
    internal func setEmoji(_ emoji: Emoji) {
        self.currentEmoji = emoji.emoji
        self.emojiArray = emoji.emojis
    }
    
}

// MARK: - Private functions

extension EmojiPopView {
    
    func didChangeLongPress(_ sender: UILongPressGestureRecognizer) {
        guard emojiButtons.count > 1 else { return }
            let point = sender.location(in: emojisView)
            let previouslySelectedButton = emojiButtons.first { $0.isSelected }
            emojiButtons.forEach {
                $0.isSelected = $0.frame.insetBy(dx: 0, dy: -80).contains(point)
                $0.backgroundColor = $0.isSelected ? theme!.specialKeyColor : .clear
            }
            let selectedButton = emojiButtons.first { $0.isSelected }
            if let selectedButton = selectedButton, selectedButton != previouslySelectedButton {
                SelectionHapticFeedback().selectionChanged()
            }
    }

    func didEndLongPress(_ sender: UILongPressGestureRecognizer) {
//        guard emojiButtons.count > 1 else { return }

        let point = sender.location(in: emojisView)
        if self.frame.contains(sender.location(in: self)) {
            // Do nothing.
        } else if let selectedButton = emojiButtons.first(where: {
            $0.frame.insetBy(dx: 0, dy: -80).contains(point)
        }) {
            selectedButton.sendActions(for: .touchUpInside)
        } else {
            dismiss()
        }
    }
    
    private func createEmojiButton(_ emoji: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = EmojiFont
        button.setTitle(emoji, for: .normal)
        button.frame = CGRect(x: CGFloat(emojiButtons.count) * EmojiSize.width, y: 0, width: EmojiSize.width, height: EmojiSize.height)
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(selectEmojiType(_:)), for: .touchUpInside)
        button.isUserInteractionEnabled = true
        return button
    }
    
    @objc private func selectEmojiType(_ sender: UIButton) {
        if let selectedEmoji = sender.titleLabel?.text {
            currentEmoji = selectedEmoji
            delegate?.emojiPopViewShouldDismiss(emojiPopView: self)
        }
    }
    
    private func setupUI() {
        isHidden = true
        
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        // adjust location of emoji bar if it is off the screen
        emojisWidth = TopPartSize.width + EmojiSize.width * CGFloat(emojiArray.count - 1)
        emojisX = 0.0 // the x adjustment within the popView to account for the shift in location
        let screenWidth = UIScreen.main.bounds.width
        if emojisWidth + locationX > screenWidth {
            emojisX = -CGFloat(emojisWidth + locationX - screenWidth + 8) // 8 for padding to border
        }
        // readjust in case someone is long-pressing right at the edge of the screen
        let halfWidth = TopPartSize.width / 2.0 - BottomPartSize.width / 2.0
        if emojisX + emojisWidth < halfWidth + BottomPartSize.width {
            emojisX += (halfWidth + BottomPartSize.width) - (emojisX + emojisWidth)
        }
        
        // path
        let path = maskPath()
        
        // border
        let borderLayer = CAShapeLayer()
        borderLayer.path = path
        if theme != nil {
            borderLayer.fillColor = theme!.popupBackgroundColor.cgColor
        } else {
            borderLayer.fillColor = UIColor.white.cgColor
        }
        borderLayer.lineWidth = 1
        layer.addSublayer(borderLayer)
        
        // mask
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        
        // content layer
        let contentLayer = CALayer()
        contentLayer.frame = bounds
        if theme != nil {
            contentLayer.backgroundColor = theme?.popupBackgroundColor.cgColor
        } else {
            contentLayer.backgroundColor = UIColor.white.cgColor
        }
        contentLayer.mask = maskLayer
        layer.addSublayer(contentLayer)
        
        emojisView.removeFromSuperview()
        emojisView = UIView(frame: CGRect(x: emojisX + 8, y: 10, width: CGFloat(emojiArray.count) * EmojiSize.width, height: EmojiSize.height))
        
        // add buttons
        emojiButtons = []
        for emoji in emojiArray {
            let button = createEmojiButton(emoji)
            emojiButtons.append(button)
            emojisView.addSubview(button)
        }
        
        addSubview(emojisView)
        if theme != nil {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: 0.1, height: 0.5)
            self.layer.shadowRadius = 2
        }
    }
    
    func maskPath() -> CGMutablePath {
        let path = CGMutablePath()
        
        path.addRoundedRect(
                 in: CGRect(
                     x: emojisX,
                     y: 0.0,
                     width: emojisWidth,
                     height: TopPartSize.height
                 ),
                 cornerWidth: 10,
                 cornerHeight: 10
             )

        path.addRoundedRect(
            in: CGRect(
                x: TopPartSize.width / 2.0 - BottomPartSize.width / 2.0,
                y: TopPartSize.height - 10,
                width: BottomPartSize.width,
                height: BottomPartSize.height + 10
            ),
            cornerWidth: 5,
            cornerHeight: 5
        )
        
        return path
    }
}

public class SelectionHapticFeedback {
    let selectionFeedbackGenerator: UISelectionFeedbackGenerator

    public init() {
//        AssertIsOnMainThread()

        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator.prepare()
    }

    public func selectionChanged() {
        DispatchQueue.main.async {
            self.selectionFeedbackGenerator.selectionChanged()
            self.selectionFeedbackGenerator.prepare()
        }
    }
}

public class ImpactHapticFeedback: NSObject {
    @objc
    public class func impactOccured(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        }
    }

    @objc
    public class func impactOccured(style: UIImpactFeedbackGenerator.FeedbackStyle, intensity: CGFloat) {
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            if #available(iOS 13.0, *) {
                generator.impactOccurred(intensity: intensity)
            } else {
                // Fallback on earlier versions
                generator.impactOccurred()
            }
        }
    }
}
