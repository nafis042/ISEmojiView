//
//  EmojiKeyboardViewController.swift
//  ISEmojiViewExample
//
//  Created by Beniamin Sarkisyan on 03/08/2018.
//

import UIKit
import ISEmojiView

class EmojiKeyboardViewController: UIViewController, EmojiViewDelegate {
    
    // MARK: - Public variables
    
    var bottomType: BottomType!
    var emojis: [EmojiCategory]?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var textView: UITextView!
    
    // MARK: - Override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Support "Dark Mode"
        if #available(iOS 13.0, *) {
            textView!.textColor = .label
        }
        
        let keyboardSettings = KeyboardSettings()
        keyboardSettings.customEmojis = emojis
        keyboardSettings.countOfRecentsEmojis = 20
        keyboardSettings.updateRecentEmojiImmediately = false
        keyboardSettings.needToShowAbcButton = true
        let emojiView = EmojiView(keyboardSettings: keyboardSettings)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.delegate = self
        emojiView.theme = Theme(
            name: "Dark",
            key: "dark",
            backgroundColor: [["#2B2B2B", "#2B2B2B"]],
            keyBackground: "dark_key",
            arrow: "light_arrow",
            textColor: UIColor.white,
            hintColor: UIColor.lightGray,
            suggestionBorderColor: UIColor(hex: "#434343")!,
            suggestionTextColor: UIColor.white,
            suggestionSelectedBackgroundColor: UIColor(hex: "#434343")!,
            suggestionSelectedTextColor: UIColor.white,
            popupBackgroundColor: UIColor(hex: "#434343")!,
            popupSelectedSelectedBackgroundColor: .black.withAlphaComponent(0.15),
            popupShadowColor: .black.withAlphaComponent(0.25),
            popupStrokeColor: .clear,
            normalKeyBackgroundColor: UIColor(hex: "#434343")!,
            specialKeyBackgroundColor: UIColor(hex: "#252424")!,
            shadowColor: .black,
            shadowOpacity: 0.3,
            specialKeyColor: .white
        )
        textView.inputView = emojiView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    // MARK: - EmojiViewDelegate
    
    func emojiViewDidSelectEmoji(_ emoji: String, emojiView: EmojiView) {
        textView.insertText(emoji)
    }
    
    func emojiViewDidPressChangeKeyboardButton(_ emojiView: EmojiView) {
        textView.inputView = nil
        textView.keyboardType = .default
        textView.reloadInputViews()
    }
    
    func emojiViewDidPressDeleteBackwardButton(_ emojiView: EmojiView) {
        textView.deleteBackward()
    }
    
    func emojiViewDidPressDismissKeyboardButton(_ emojiView: EmojiView) {
        textView.resignFirstResponder()
    }
    
}

extension UIColor {
    /// Initializes a `UIColor` object with the provided `HEX` value.
    /// - Parameter hex: The `HEX` value which should be converted to UIColor. It supports both **8-bit** HEX & **6-bit** CSS/HTML string as value.
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if hexColor.count == 8 {
                if scanner.scanHexInt64(&hexNumber) {
                    a = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    r = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            } else if hexColor.count == 6 {
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1.0
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }

    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
