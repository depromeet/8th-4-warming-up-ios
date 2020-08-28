//
//  DiscountCell.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/17.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit

class DiscountCell: BaseTableViewCell {
    let imageViewStep = UIImageView().then {
        $0.image = nil
    }

    let labelPercent = UILabel().then {
        $0.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        $0.textColor = 0x323232.color
    }

    let labelCount = UILabel().then {
        $0.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        $0.textColor = 0x8C8C8C.color
    }

    override func initialize() {
        selectionStyle = .none
        addSubview(imageViewStep)
        imageViewStep.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        addSubview(labelPercent)
        labelPercent.snp.makeConstraints {
            $0.leading.equalTo(imageViewStep.snp.trailing).offset(12)
            $0.centerY.equalTo(imageViewStep).offset(1)
        }
        addSubview(labelCount)
        labelCount.snp.makeConstraints {
            $0.leading.equalTo(labelPercent.snp.trailing).offset(8)
            $0.centerY.equalTo(labelPercent).offset(1)
        }
    }
}
