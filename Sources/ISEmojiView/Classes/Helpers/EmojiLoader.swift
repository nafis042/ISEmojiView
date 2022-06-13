//
//  EmojiLoader.swift
//  ISEmojiView
//
//  Created by Beniamin Sarkisyan on 01/08/2018.
//

import Foundation

final public class EmojiLoader {
    
    static func recentEmojiCategory() -> EmojiCategory {
        return EmojiCategory(
            category: .recents,
            emojis: RecentEmojisManager.sharedManager.recentEmojis()
        )
    }
    
    static func emojiCategories() -> [EmojiCategory] {
        var emojiPListFileName = "ISEmojiList_iOS10";
        if #available(iOS 11.0, *) { emojiPListFileName = "ISEmojiList_iOS11" }
        if #available(iOS 12.1, *) { emojiPListFileName = "ISEmojiList" }
        if #available(iOS 13.2, *) { emojiPListFileName = "emoji_13_2" }
        if #available(iOS 14.2, *) { emojiPListFileName = "emoji_14_2" }
        if #available(iOS 14.5, *) { emojiPListFileName = "emoji_14_5" }
        if #available(iOS 15.4, *) { emojiPListFileName = "emoji_15_4" }
        
        guard let filePath = Bundle.podBundle.path(forResource: emojiPListFileName, ofType: "plist") else {
            return []
        }
        
        guard let categories = NSArray(contentsOfFile: filePath) as? [[String:Any]] else {
            return []
        }
        
        var emojiCategories = [EmojiCategory]()
        
        let availableCategories: [Category] = [
            .smileysAndPeople, .animalsAndNature, .foodAndDrink,
            .activity, .travelAndPlaces, .objects, .symbols, .flags
        ]
        
        for dictionary in categories {
            guard let title = dictionary["title"] as? String else {
                continue
            }
            
            guard let category = availableCategories.first(where: { $0.title == title }) else {
                continue
            }
            
            guard let rawEmojis = dictionary["emojis"] as? [Any] else {
                continue
            }
            
            var emojis = [Emoji]()
            
            for value in rawEmojis {
                if let string = value as? String {
                    emojis.append(Emoji(emojis: [string]))
                } else if let array = value as? [String] {
                    emojis.append(Emoji(emojis: array))
                }
            }
            
            let emojiCategory = EmojiCategory(category: category, emojis: emojis)
            emojiCategories.append(emojiCategory)
        }
        
        return emojiCategories
    }
    
}
