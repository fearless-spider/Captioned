//
//  CaptionCell.swift
//  Captioned
//
//  Created by Przemysław Pająk on 09.05.2016.
//  Copyright © 2016 Fearless Spider. All rights reserved.
//

import UIKit
import TTTAttributedLabel

let CaptionViewLeadingEdgeInset: CGFloat = 10.0;
let CaptionViewTrailingEdgeInset: CGFloat = 10.0;

let HashTagAndMentionRegex: NSString = "(#|@)(\\w+)";


public protocol CaptionCellDelegate: class {
    func didSelectHashtag(captionCell: CaptionCell, hashtag: NSString)
    func didSelectMention(captionCell: CaptionCell, mention: NSString);
    func didSelectPoster(captionCell: CaptionCell, user: User);

}

public class CaptionCell: UITableViewCell, TTTAttributedLabelDelegate {
    
    var caption: NSDictionary!
    weak var delegate: CaptionCellDelegate?
    
    func initWithCaption(caption: NSDictionary, reuseIdentifier: NSString) {
        
        
    }
}