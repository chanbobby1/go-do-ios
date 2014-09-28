//
//  ShortcutCollectionCell.swift
//  Go
//
//  Created by Bobby on 9/27/14.
//  Copyright (c) 2014 Bobby. All rights reserved.
//

import UIKit

class ShortcutCollectionCell : UICollectionViewCell {
    var shortcut:Shortcut?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        renderedView()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        renderedView()
    }
    
    func renderedView() {
        self.backgroundColor = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 0.75)
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
    }
}