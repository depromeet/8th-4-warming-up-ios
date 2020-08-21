//
//  CommentViewController.swift
//  Development
//
//  Created by Soso on 2020/08/19.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxKeyboard
import ReusableKit

class CommentViewController: BaseViewController, View {

    private enum Color {
        static let yellow1 = 0xFFD136.color
        static let black1 = 0x323232.color
        static let lightGray2 = 0xF8F8F8.color
        static let lightGray4 = 0xCACACA.color
    }
    private enum Font {
        static let sdR14 = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
    }
    struct Reusable {
        static let commentCell = ReusableCell<ItemCommentCell>()
        static let subCommentCell = ReusableCell<ItemSubCommentCell>()
    }

    lazy var navigationBar = NavigationBar(
        leftView: buttonBack
    ).then {
        $0.backgroundColor = .clear
    }
    let buttonBack = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_back_w24h24"), for: .normal)
    }

    let tableView = UITableView().then {
        $0.register(Reusable.commentCell)
        $0.register(Reusable.subCommentCell)
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .interactive
    }

    let viewInput = UIView().then {
        $0.backgroundColor = .clear
    }
    let textViewInput = ResizableTextView().then {
        $0.font = Font.sdR14
        $0.textColor = Color.black1
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
    }
    let buttonSend = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_write_selected_w16h16"), for: .normal)
        $0.setImage(#imageLiteral(resourceName: "icon_write_w16h16"), for: .disabled)
        $0.adjustsImageWhenHighlighted = false
    }
    let labelInputPlaceholder = UILabel().then {
        $0.font = Font.sdR14
        $0.textColor = Color.lightGray4
        $0.text = "댓글 달기"
    }
    var constraintInputBottom: NSLayoutConstraint!

    init(reactor: CommentReactor) {
        super.init(provider: reactor.provider)
        self.reactor = reactor
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupConstraints() {
        setupNavigationBar()
        setupTableView()
        setupInputView()
    }

    func bind(reactor: CommentReactor) {
        buttonBack.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        textViewInput.rx.text.orEmpty
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(to: buttonSend.rx.isEnabled)
            .disposed(by: disposeBag)

        textViewInput.rx.text.orEmpty
            .map { !$0.isEmpty }
            .distinctUntilChanged()
            .bind(to: labelInputPlaceholder.rx.isHidden)
            .disposed(by: disposeBag)

        Observable
            .just(["1", "2", "3", "4", "5", "6", "7", "8"])
            .bind(to: tableView.rx.items(Reusable.subCommentCell)) { index, data, cell in
                print(index, data, cell)
                cell.buttonMore.rx.tap
                    .subscribe(onNext: { [weak self] in
                        self?.presentCommentActionSheet()
                    })
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)

        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] height in
                let constant = height - self.view.safeAreaInsets.bottom
                self.constraintInputBottom?.constant = -max(constant, 0)
                self.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
    }

    private func presentCommentActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actionEdit = UIAlertAction(title: "수정", style: .default, handler: nil)
        let actionDelete = UIAlertAction(title: "삭제하기", style: .destructive, handler: nil)
        let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        actionSheet.addAction(actionEdit)
        actionSheet.addAction(actionDelete)
        actionSheet.addAction(actionCancel)
        present(actionSheet, animated: true, completion: nil)
    }
}

extension CommentViewController {
    private func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(44)
        }
        let viewBackground = UIView().then {
            $0.backgroundColor = Color.yellow1
        }
        view.insertSubview(viewBackground, belowSubview: navigationBar)
        viewBackground.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar)
        }
    }
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setupInputView() {
        view.addSubview(viewInput)
        viewInput.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        constraintInputBottom = viewInput.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        constraintInputBottom.isActive = true
        let viewBackground = UIView().then {
            $0.backgroundColor = Color.lightGray2
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        viewInput.addSubview(viewBackground)
        viewBackground.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview().inset(18).priority(999)
        }
        viewBackground.addSubview(textViewInput)
        textViewInput.snp.makeConstraints {
            $0.top.equalToSuperview().inset(1)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(12)
            $0.trailing.equalToSuperview().inset(32).priority(999)
        }
        viewBackground.addSubview(buttonSend)
        buttonSend.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        viewBackground.addSubview(labelInputPlaceholder)
        labelInputPlaceholder.snp.makeConstraints {
            $0.leading.equalTo(textViewInput).inset(5)
            $0.centerY.equalTo(textViewInput)
        }
        let viewSeparator = UIView().then {
            $0.backgroundColor = 0xCACACA.color
        }
        viewInput.addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}