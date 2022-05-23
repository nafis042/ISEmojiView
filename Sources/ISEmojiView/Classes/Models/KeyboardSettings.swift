//
//  KeyboardSettings.swift
//  ISEmojiView
//
//  Created by Beniamin Sarkisyan on 03/08/2018.
//

import Foundation

@objc final public class KeyboardSettings: NSObject {
    
    // MARK: - Public variables
    
    /// false if you want update recent emoji every popup.
    @objc public var updateRecentEmojiImmediately:Bool = true
    
    /// Type of bottom view. Default is `.pageControl`.
    public var bottomType: BottomType! = .pageControl
    
    /// Array with custom emojis
    public var customEmojis: [EmojiCategory]?
    
    /// Long press to pop preview effect like iOS10 system emoji keyboard. Default is true.
    @objc public var isShowPopPreview: Bool = true
    
    /// The max number of recent emojis, if set 0, nothing will be shown. Default is 50.
    @objc public var countOfRecentsEmojis: Int = MaxCountOfRecentsEmojis
    
    /// Need to show change keyboard button
    /// This button is located in `Categories` bottom view.
    /// Default is false.
    @objc public var needToShowAbcButton: Bool = false
    
    // MARK: - Init functions
    
    public override init() {
        self.bottomType = .categories
    }
    
}
