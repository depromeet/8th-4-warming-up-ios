//
//  CommentCell.swift
//  Depromeet8th4
//
//  Created by Yeojaeng on 2020/08/03.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var commentedTime: UILabel!
    @IBOutlet weak var commentContent: UILabel!
    @IBOutlet weak var thumbsUpCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var moreButton: UIButton!
}
