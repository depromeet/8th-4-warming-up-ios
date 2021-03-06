//
//  VideoCell.swift
//  YoutubeExample
//
//  Created by Soso on 2020/07/05.
//  Copyright © 2020 Soso. All rights reserved.
//

import RxSwift
import UIKit

class BaseTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialize()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initialize() {}

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }
}
