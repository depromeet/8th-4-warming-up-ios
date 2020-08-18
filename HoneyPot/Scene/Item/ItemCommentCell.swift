//
//  ItemCommentCell.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/15.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import SnapKit
import Then

class ItemCommentCell: BaseTableViewCell {
    private enum Color {
        static let mainText = 0x323232.color
        static let subText = 0xA5A5A5.color
    }
    private enum Font {
        static let usernameText = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)!
        static let contentText = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
        static let extraText = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)!
        static let commentText = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 12)!
    }
    private enum Style {
        static let paragraph = NSMutableParagraphStyle().then {
            $0.lineSpacing = 3
        }
        static let contentText: [NSAttributedString.Key: Any] = [
            .kern: -0.4,
            .font: Font.contentText,
            .foregroundColor: Color.mainText,
            .paragraphStyle: paragraph
        ]
    }

    let viewContainer = UIView().then {
        $0.backgroundColor = .clear
    }
    let viewBottom = UIView().then {
        $0.backgroundColor = .red
        $0.isHidden = true
    }

    let labelBottom = UILabel().then {
        $0.text = "이전 대댓글 2개 더 보기"
        $0.textColor = Color.mainText
        $0.font = Font.extraText
    }

    let labelUsername = UILabel().then {
        $0.text = "여정수"
        $0.textColor = Color.mainText
        $0.font = Font.usernameText
    }
    let labelTime = UILabel().then {
        $0.text = "10분 전"
        $0.textColor = Color.subText
        $0.font = Font.extraText
    }
    let buttonMore = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_more_w24h24"), for: .normal)
    }

    let labelContent = UILabel().then {
        let attributedString = NSAttributedString(string: "요즘 너무 더워서 이런 선풍기 하나 있으면 너무 좋더라구요", attributes: Style.contentText)
        $0.attributedText = attributedString
        $0.numberOfLines = 0
    }

    let buttonLike = UIButton().then {
        $0.setTitle("14", for: .normal)
        $0.setTitleColor(Color.subText, for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_like_normal_w16h16"), for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_like_selected_w16h16"), for: .selected)
        $0.titleLabel?.font = Font.extraText
        $0.titleEdgeInsets = .init(top: 1, left: 3, bottom: 0, right: -3)
        $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 3)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonComment = UIButton().then {
        $0.setTitle("5", for: .normal)
        $0.setTitleColor(Color.subText, for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_bubble_light_w16h16"), for: .normal)
        $0.titleLabel?.font = Font.extraText
        $0.titleEdgeInsets = .init(top: 1, left: 3, bottom: 0, right: -3)
        $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 3)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonReply = UIButton().then {
        $0.setTitle("대댓글 달기", for: .normal)
        $0.setTitleColor(Color.subText, for: .normal)
        $0.titleLabel?.font = Font.commentText
    }

    override func initialize() {
        setupViews()
    }

    private func setupViews() {
        selectionStyle = .none
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
        }
        addSubview(viewContainer)
        viewContainer.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(18)
        }
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(viewContainer.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview()
        }
        viewBottom.snp.makeConstraints {
            $0.height.equalTo(35)
        }
        let viewSeparator2 = UIView().then {
            $0.backgroundColor = 0xEEEEEE.color
        }
        viewBottom.addSubview(viewSeparator2)
        viewSeparator2.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        viewBottom.addSubview(labelBottom)
        labelBottom.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.centerY.equalToSuperview().offset(1)
        }
        stackView.addArrangedSubview(viewBottom)

        let viewSeparator = UIView().then {
            $0.backgroundColor = 0xEEEEEE.color
        }
        addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }

        setupInfo()
        setupContent()
        setupAction()
    }

    func setContentText(text: String) {
        let attributedString = NSAttributedString(string: text, attributes: Style.contentText)
        labelContent.attributedText = attributedString
    }
}

extension ItemCommentCell {
    private func setupInfo() {
        viewContainer.addSubview(labelUsername)
        labelUsername.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.leading.equalToSuperview()
        }
        viewContainer.addSubview(labelTime)
        labelTime.snp.makeConstraints {
            $0.leading.equalTo(labelUsername.snp.trailing).offset(8)
            $0.centerY.equalTo(labelUsername).offset(1)
        }
        viewContainer.addSubview(buttonMore)
        buttonMore.snp.makeConstraints {
            $0.leading.greaterThanOrEqualTo(labelTime.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(labelUsername)
        }
    }
    private func setupContent() {
        viewContainer.addSubview(labelContent)
        labelContent.snp.makeConstraints {
            $0.top.equalTo(labelUsername.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview()
        }
    }
    private func setupAction() {
        viewContainer.addSubview(buttonLike)
        buttonLike.snp.makeConstraints {
            $0.top.equalTo(labelContent.snp.bottom).offset(7)
            $0.leading.bottom.equalToSuperview()
            $0.height.equalTo(16)
        }
        viewContainer.addSubview(buttonComment)
        buttonComment.snp.makeConstraints {
            $0.top.bottom.equalTo(buttonLike)
            $0.leading.equalTo(buttonLike.snp.trailing).offset(10)
        }
        viewContainer.addSubview(buttonReply)
        buttonReply.snp.makeConstraints {
            $0.top.bottom.equalTo(buttonComment)
            $0.leading.equalTo(buttonComment.snp.trailing).offset(10)
        }
    }
}
