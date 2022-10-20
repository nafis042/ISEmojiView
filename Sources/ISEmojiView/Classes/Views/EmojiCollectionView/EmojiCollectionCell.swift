//
//  EmojiCollectionCell.swift
//  ISEmojiView
//
//  Created by Beniamin Sarkisyan on 01/08/2018.
//

import Foundation
import UIKit

internal class EmojiCollectionCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    // MARK: - Private variables
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
//        label.font = EmojiFont
        label.textAlignment = .center
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        return label
    }()
    
    var cellTapped: () -> (Void) = {}
    
    // MARK: - Override functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Internal functions
    
    internal func setEmoji(_ emoji: String) {
        emojiLabel.text = emoji
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        emojiLabel.frame = bounds
        addSubview(emojiLabel)
        let tapGesture = UITapGestureRecognizer(target: self,
                                                          action: #selector(handleTap(recognizer:)))
        tapGesture.delegate = self
        emojiLabel.isUserInteractionEnabled = true
        emojiLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(recognizer:UITapGestureRecognizer) {
        self.cellTapped()
      }
}
