//
//  RecentEmojisManager.swift
//  ISEmojiView
//
//  Created by Beniamin Sarkisyan on 01/08/2018.
//

import Foundation

private let recentEmojisKey = "ISEmojiView.recent"
private let recentEmojisFreqStorageKey = "ISEmojiView.recent-freq"

final internal class RecentEmojisManager {
    
    // MARK: - Public variables
    
    static var sharedInstance: RecentEmojisManager?
    class var sharedManager : RecentEmojisManager {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance = RecentEmojisManager()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    
    class func destroySharedManager() {
        sharedInstance = nil
    }
    
    internal var maxCountOfCenetEmojis: Int = 0
    
    // MARK: - Public functions
    
    internal func add(emoji: Emoji, selectedEmoji: String) -> Bool {
        guard maxCountOfCenetEmojis > 0 else {
            return false
        }
        
        var emojis = recentEmojis()
        var freqData = recentEmojisFreqData()
        
        emoji.selectedEmoji = selectedEmoji
        
        if let freq = freqData[selectedEmoji] {
            freqData[selectedEmoji] = freq+1
        } else {
            freqData[selectedEmoji] = 0
            
        }
        
        guard emojis.firstIndex(of: emoji) == nil else {
                UserDefaults.standard.set(freqData, forKey: recentEmojisFreqStorageKey)
                return true
        }

        if emojis.count > maxCountOfCenetEmojis {
            emojis.removeLast(emojis.count-maxCountOfCenetEmojis)
        }
        
        if emojis.count > 0 && emojis.count == maxCountOfCenetEmojis {
            let toRemove = emojis.removeLast()
            let newIndex = maxCountOfCenetEmojis/3
            let oldOne = emojis[newIndex].selectedEmoji ?? ""
            emojis.insert(emoji, at: newIndex)
            freqData[selectedEmoji] = (freqData[oldOne] ?? 0) + 1
            freqData.removeValue(forKey: toRemove.selectedEmoji ?? "")
        } else {
            emojis.append(emoji)
        }
        
        if let data = try? JSONEncoder().encode(emojis) {
            UserDefaults.standard.set(data, forKey: recentEmojisKey)
        }
        
        UserDefaults.standard.set(freqData, forKey: recentEmojisFreqStorageKey)
        
        return true
    }
    
    internal func recentEmojisFreqData() ->[String:Int] {
        guard let data = UserDefaults.standard.dictionary(forKey: recentEmojisFreqStorageKey) as? [String:Int] else {return [:]}
        return data
    }
    
    internal func recentEmojis() -> [Emoji] {
        let dummyEmoji = [
            Emoji(emojis: ["😀"]),
            Emoji(emojis: ["😂"]),
            Emoji(emojis: ["😅"]),
            Emoji(emojis: ["🤩"]),
            Emoji(emojis: ["😪"]),
            Emoji(emojis: ["😰"]),
            Emoji(emojis: ["👿"]),
            Emoji(emojis: ["😻"]),
            Emoji(emojis: ["👑"]),
            Emoji(emojis: ["🍓"]),
            Emoji(emojis: ["🍕"]),
            Emoji(emojis: ["🍔"]),
            Emoji(emojis: ["☕️"]),
            Emoji(emojis: ["⚽️"]),
            Emoji(emojis: ["🏸"]),
            Emoji(emojis: ["🎾"]),
            Emoji(emojis: ["🏆"]),
            Emoji(emojis: ["🎹"]),
            Emoji(emojis: ["🎸"]),
            Emoji(emojis: ["🇧🇩"]),
            Emoji(emojis: ["🚗"]),
            Emoji(emojis: ["🚜"]),
            Emoji(emojis: ["✈️"]),
            Emoji(emojis: ["🏝"]),
        ]
        guard let data = UserDefaults.standard.data(forKey: recentEmojisKey) else {
            return dummyEmoji
        }
        
        guard let emojis = try? JSONDecoder().decode([Emoji].self, from: data) else {
            return dummyEmoji
        }
        let freqData = recentEmojisFreqData()
        let seq = emojis.sorted {
            let left = freqData[$0.selectedEmoji ?? ""] ?? 0
            let right = freqData[$1.selectedEmoji ?? ""] ?? 0
            return left > right
        }
        if seq.count < 20 {
            var filteredDummyEmoji: [Emoji] = []
            for emoji in dummyEmoji {
                for element in seq {
                    if element.emoji != emoji.emoji {
                        filteredDummyEmoji.append(emoji)
                    }
                }
            }
            return seq + filteredDummyEmoji
        }
        return seq
    }
}
