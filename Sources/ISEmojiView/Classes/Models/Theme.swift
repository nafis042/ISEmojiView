//
//  Theme.swift
//  ISEmojiView
//
//  Created by Nafis Islam on 24/5/22.
//

import UIKit

@objc(ThemeData)
public class Theme : NSObject {
    
    @objc let name: String
    @objc let key: String
    @objc let backgroundColor: [String]
    @objc let keyBackground: String
    @objc let arrow: String
    @objc let textColor: UIColor
    @objc let hintColor: UIColor
    @objc let suggestionBorderColor: UIColor
    @objc let suggestionTextColor: UIColor
    @objc let popupBackgroundColor: UIColor
    @objc let popupSelectedSelectedBackgroundColor: UIColor
    @objc let popupShadowColor: UIColor
    @objc let popupStrokeColor: UIColor
    @objc let normalKeyBackgroundColor: UIColor
    @objc let specialKeyBackgroundColor: UIColor
    @objc let shadowColor: UIColor
    @objc let shadowOpacity: CGFloat
    @objc let shadowOffset: CGSize
    @objc let specialKeyColor: UIColor
    @objc let borderColor: UIColor
    @objc let gradientDirection: Int

    
    @objc public init(name: String, key: String, backgroundColor: [String], keyBackground:String, arrow: String, textColor: UIColor, hintColor: UIColor, suggestionBorderColor: UIColor, suggestionTextColor: UIColor, popupBackgroundColor: UIColor, popupSelectedSelectedBackgroundColor: UIColor, popupShadowColor:UIColor, popupStrokeColor: UIColor, normalKeyBackgroundColor: UIColor, specialKeyBackgroundColor: UIColor, shadowColor: UIColor, shadowOpacity: CGFloat, shadowOffset: CGSize = CGSize(width: 0, height: 1), specialKeyColor: UIColor, borderColor: UIColor = .clear, gradientDirection: Int = 4) {
        self.name = name;
        self.key = key;
        self.backgroundColor = backgroundColor
        self.textColor = textColor;
        self.hintColor = hintColor;
        self.suggestionTextColor = suggestionTextColor;
        self.suggestionBorderColor = suggestionBorderColor;
        self.popupBackgroundColor = popupBackgroundColor;
        self.popupShadowColor = popupShadowColor;
        self.popupStrokeColor = popupStrokeColor;
        self.popupSelectedSelectedBackgroundColor = popupSelectedSelectedBackgroundColor;
        self.keyBackground = keyBackground;
        self.arrow = arrow;
        self.normalKeyBackgroundColor = normalKeyBackgroundColor
        self.specialKeyBackgroundColor = specialKeyBackgroundColor
        self.shadowOpacity = shadowOpacity
        self.shadowColor = shadowColor
        self.specialKeyColor = specialKeyColor
        self.borderColor = borderColor
        self.gradientDirection = gradientDirection
        self.shadowOffset = shadowOffset
    }
    
}
