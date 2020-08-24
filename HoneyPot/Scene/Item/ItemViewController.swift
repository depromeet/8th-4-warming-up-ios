//
//  ItemViewController.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/08/13.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import RxKeyboard
import RxKingfisher
import ReusableKit

class ItemViewController: BaseViewController, View {
    private enum Color {
        static let red1 = 0xEB5757.color
        static let yellow1 = 0xFFD136.color
        static let black1 = 0x323232.color
        static let black2 = 0x464646.color
        static let lightGray1 = 0xA5A5A5.color
        static let lightGray2 = 0xF8F8F8.color
        static let lightGray3 = 0x8C8C8C.color
        static let lightGray4 = 0xCACACA.color
    }
    private enum Font {
        static let godoB24 = UIFont(name: "GodoB", size: 24)!
        static let godoB16 = UIFont(name: "GodoB", size: 16)!
        static let sdR14 = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)!
        static let sdR12 = UIFont(name: "AppleSDGothicNeo-Regular", size: 12)!
        static let sdB24 = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)!
        static let sdB18 = UIFont(name: "AppleSDGothicNeo-Bold", size: 18)!
        static let sdB16 = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)!
        static let sdB14 = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)!
        static let sdB12 = UIFont(name: "AppleSDGothicNeo-Bold", size: 12)!
    }
    private enum Metric {
        static let leadingOffset: CGFloat = 18
        static let trailingOffset: CGFloat = 18
    }
    private enum Style {
        static let paragraph = NSMutableParagraphStyle().then {
            $0.lineSpacing = 4
        }
        static let itemText: [NSAttributedString.Key: Any] = [
            .kern: -0.72,
            .font: Font.godoB24,
            .foregroundColor: Color.black1,
            .paragraphStyle: paragraph
        ]
        static let priceOriginalText: [NSAttributedString.Key: Any] = [
            .kern: -0.4,
            .font: Font.sdR14,
            .foregroundColor: Color.lightGray1,
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
        ]
        static let countNormalText: [NSAttributedString.Key: Any] = [
            .kern: -0.3,
            .font: Font.sdR14,
            .foregroundColor: Color.lightGray3
        ]
        static let countFocusText: [NSAttributedString.Key: Any] = [
            .kern: -0.3,
            .font: Font.sdB14,
            .foregroundColor: Color.lightGray3
        ]
    }
    struct Reusable {
        static let commentCell = ReusableCell<ItemCommentCell>()
    }

    let viewBackground = UIView().then {
        $0.backgroundColor = Color.yellow1
    }

    // MARK: - Navigation
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
        $0.contentInsetAdjustmentBehavior = .never
        $0.backgroundColor = .systemBackground
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .interactive
    }

    let viewHeader = UIView().then {
        $0.backgroundColor = .clear
    }

    // MARK: - Banner
    let imageViewItem = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = 0xEEEEEE.color
    }
    let buttonCategory = UIButton().then {
        $0.setTitleColor(Color.black2, for: .normal)
        $0.titleLabel?.font = Font.sdR14
        $0.backgroundColor = UIColor.white.withAlphaComponent(80)
        $0.contentEdgeInsets = .init(top: 5, left: 10, bottom: 3, right: 10)
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = false
    }

    // MARK: - Title & Price
    let labelItem = UILabel().then {
        $0.numberOfLines = 0
    }
    let labelPriceOriginal = UILabel().then {
        $0.numberOfLines = 1
    }
    let labelPricePercent = UILabel().then {
        $0.font = Font.sdB24
        $0.textColor = Color.red1
    }
    let labelPriceDiscount = UILabel().then {
        $0.font = Font.sdB24
        $0.textColor = Color.black1
    }
    let labelCurrency = UILabel().then {
        $0.font = Font.sdR14
        $0.textColor = Color.black1
    }

    // MARK: - Progress
    let buttonDiscountUntil = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_logo_w24h21"), for: .normal)
        $0.setTitleColor(Color.black1, for: .normal)
        $0.titleEdgeInsets = .init(top: 1, left: 5, bottom: 0, right: -5)
        $0.titleLabel?.font = Font.sdB18
        $0.isUserInteractionEnabled = false
    }
    let buttonDiscountInfo = UIButton().then {
        $0.setTitle("할인안내", for: .normal)
        $0.setTitleColor(Color.black2, for: .normal)
        $0.backgroundColor = Color.lightGray2
        $0.contentEdgeInsets = .init(top: 5, left: 10, bottom: 3, right: 10)
        $0.titleLabel?.font = Font.sdR12
        $0.layer.cornerRadius = 5
        $0.layer.masksToBounds = true
    }
    let viewProgressBackground = UIView().then {
        $0.backgroundColor = 0xEAEAEA.color
    }
    var constraintProgressTrailing: NSLayoutConstraint!

    // MARK: - Count & Time
    let buttonCount = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_people_w18h18"), for: .normal)
        $0.titleEdgeInsets = .init(top: 1, left: 5, bottom: 0, right: -5)
        $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        $0.isUserInteractionEnabled = false
    }
    let buttonTime = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_clock_w18h18"), for: .normal)
        $0.titleEdgeInsets = .init(top: 1, left: 5, bottom: 0, right: -5)
        $0.contentEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 5)
        $0.isUserInteractionEnabled = false
    }

    // MARK: - Seller
    let labelSeller = UILabel().then {
        $0.textColor = Color.black2
        $0.font = Font.sdB16
    }
    let labelReview = UILabel().then {
        $0.textColor = Color.black2
        $0.font = Font.sdR12
    }

    // MARK: - Detail
    let imageViewDetail = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = 0xEEEEEE.color
    }
    var constraintDetailHeight: NSLayoutConstraint!

    // MARK: - Input
    let viewInput = UIView().then {
        $0.backgroundColor = .clear
    }
    let buttonComment = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "icon_bubble_w24h24"), for: .normal)
        $0.setTitleColor(Color.lightGray1, for: .normal)
        $0.titleLabel?.font = Font.sdB16
        $0.titleEdgeInsets = .init(top: 1, left: 2, bottom: 0, right: -2)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonViewAll = UIButton(type: .system).then {
        $0.setTitle("댓글 전체보기", for: .normal)
        $0.setTitleColor(Color.lightGray1, for: .normal)
        $0.titleLabel?.font = Font.sdR14
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
        $0.isEnabled = false
    }
    let labelInputPlaceholder = UILabel().then {
        $0.font = Font.sdR14
        $0.textColor = Color.lightGray4
        $0.text = "댓글 달기"
    }
    let buttonRedirect = UIButton().then {
        $0.backgroundColor = .clear
    }

    // MARK: - Bottom
    let viewBottom = UIView().then {
        $0.backgroundColor = .white
    }
    var constraintBottomView: NSLayoutConstraint!
    let buttonShare = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "image_share_w48h50"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonLike = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "image_favorite_w48h50"), for: .normal)
        $0.setImage(#imageLiteral(resourceName: "image_favorite_selected_w48h50"), for: .selected)
        $0.adjustsImageWhenHighlighted = false
    }
    let buttonSubmit = UIButton().then {
        $0.setTitle("참여하기", for: .normal)
        $0.setTitle("참여중", for: .selected)
        $0.setTitle("마감된 상품입니다", for: .disabled)
        $0.setTitle("마감된 상품입니다", for: [.disabled, .selected])
        $0.setTitleColor(0xFFC500.color, for: .selected)
        $0.setBackgroundImage(#imageLiteral(resourceName: "image_background_yellow"), for: .normal)
        $0.setBackgroundImage(#imageLiteral(resourceName: "image_background_bordered_yellow"), for: .selected)
        $0.setBackgroundImage(#imageLiteral(resourceName: "image_background_gray"), for: .disabled)
        $0.setBackgroundImage(#imageLiteral(resourceName: "image_background_gray"), for: [.disabled, .selected])
        $0.titleLabel?.font = Font.godoB16
        $0.setContentHuggingPriority(.init(1), for: .horizontal)
        $0.adjustsImageWhenHighlighted = false
        $0.adjustsImageWhenDisabled = false
    }
    let buttonSharePopUp = UIButton().then {
        $0.setTitle("소문내고 더 할인받기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundImage(#imageLiteral(resourceName: "image_black_bubble"), for: .normal)
        $0.contentEdgeInsets = .init(top: 7, left: 8, bottom: 12, right: 25)
        $0.titleLabel?.font = Font.sdR12
    }
    let buttonScrollToTop = UIButton().then {
        $0.setImage(#imageLiteral(resourceName: "image_floating_top_w38h38"), for: .normal)
        $0.adjustsImageWhenHighlighted = false
    }

    // MARK: - Life Cycle
    init(reactor: ItemReactor) {
        super.init(provider: reactor.provider)
        self.reactor = reactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setupConstraints() {
        setupNavigationBar()
        setupTableView()
        setupBottomView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let headerView = tableView.tableHeaderView {
            headerView.frame.size.height = viewHeader.bounds.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }

    func bind(reactor: ItemReactor) {
        bindView(reactor: reactor)
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    private func bindView(reactor: ItemReactor) {
        buttonBack.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        buttonShare.rx.tap
            .withLatestFrom(reactor.state.map { $0.itemID })
            .compactMap { $0 }
            .map { "honeypot://item/\($0)" }
            .map { ([$0], nil) }
            .map(UIActivityViewController.init)
            .subscribe(onNext: { [weak self] activity in
                self?.present(activity, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        buttonScrollToTop.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.tableView.setContentOffset(.zero, animated: true)
            })
            .disposed(by: disposeBag)

        buttonDiscountInfo.rx.tap
            .withLatestFrom(reactor.state)
            .compactMap { $0.discounts }
            .subscribe(onNext: { [weak self] discounts in
                guard let self = self else { return }
                let modal = DiscountModalViewController(provider: self.provider, discounts: discounts)
                self.present(modal, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        buttonRedirect.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let id = reactor.currentState.itemID
                let viewController = CommentViewController(reactor: .init(provider: self.provider, itemID: id))
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)

        let isHidden = tableView.rx.contentOffset
            .map { $0.y < 150 }
            .distinctUntilChanged()

        isHidden
            .bind(to: viewBackground.rx.isHidden)
            .disposed(by: disposeBag)

        isHidden
            .bind(to: navigationBar.labelTitle.rx.isHidden)
            .disposed(by: disposeBag)

        isHidden
            .bind(to: buttonScrollToTop.rx.isHidden)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                let id = reactor.currentState.itemID
                let viewController = CommentViewController(reactor: .init(provider: self.provider, itemID: id))
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
    private func bindAction(reactor: ItemReactor) {
        rx.viewWillAppear
            .take(1)
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        buttonSharePopUp.rx.tap
            .map { Reactor.Action.toggleSharePopUp }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        buttonLike.rx.tap
            .map { Reactor.Action.likePost }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    private func bindState(reactor: ItemReactor) {
        bindURLsAndDescription(reactor: reactor)
        bindPrice(reactor: reactor)
        bindInfoAndSeller(reactor: reactor)
        bindComments(reactor: reactor)
    }
    private func bindURLsAndDescription(reactor: ItemReactor) {
        reactor.state
            .compactMap { $0.bannerURL }
            .distinctUntilChanged()
            .compactMap(URL.init)
            .bind(to: imageViewItem.kf.rx.image())
            .disposed(by: disposeBag)

        let imageViewDetail = self.imageViewDetail
        reactor.state
            .compactMap { $0.contentURL }
            .distinctUntilChanged()
            .compactMap(URL.init)
            .flatMap({ imageViewDetail.kf.rx.setImage(with: $0) })
            .subscribe(onNext: { [weak self] image in
                guard let self = self else { return }
                let size = image.size
                let ratio = size.height / size.width
                let constant = ratio * self.imageViewDetail.bounds.width
                self.constraintDetailHeight.constant = constant
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.title }
            .distinctUntilChanged()
            .map { [weak self] in self?.attributedStringFor(title: $0) }
            .do(onNext: { [weak self] _ in
                self?.view.setNeedsLayout()
                self?.view.layoutIfNeeded()
            })
            .bind(to: labelItem.rx.attributedText)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.title }
            .distinctUntilChanged()
            .bind(to: navigationBar.labelTitle.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.category }
            .distinctUntilChanged()
            .bind(to: buttonCategory.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    private func bindPrice(reactor: ItemReactor) {
        reactor.state
            .map { $0.priceOriginal }
            .distinctUntilChanged()
            .map { [weak self] price in self?.attributedStringFor(price: price) }
            .bind(to: labelPriceOriginal.rx.attributedText)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.pricePercent }
            .distinctUntilChanged()
            .bind(to: labelPricePercent.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.priceDiscount }
            .distinctUntilChanged()
            .bind(to: labelPriceDiscount.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.discountUntil }
            .distinctUntilChanged()
            .bind(to: buttonDiscountUntil.rx.title(for: .normal))
            .disposed(by: disposeBag)

        let viewProgressBackground = self.viewProgressBackground
        reactor.state
            .map { $0.percent }
            .distinctUntilChanged()
            .map { CGFloat(1 - $0) * viewProgressBackground.bounds.width }
            .subscribe(onNext: { [weak self] constant in
                self?.constraintProgressTrailing.constant = constant
            })
            .disposed(by: disposeBag)
    }
    private func bindInfoAndSeller(reactor: ItemReactor) {
        reactor.state
            .map { $0.participants }
            .distinctUntilChanged()
            .map { [weak self] in self?.attributedStringFor(number: $0) }
            .bind(to: buttonCount.rx.attributedTitle(for: .normal))
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.deadline }
            .distinctUntilChanged()
            .map { [weak self] in self?.attributedStringFor(time: $0) }
            .bind(to: buttonTime.rx.attributedTitle(for: .normal))
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.sellerName }
            .distinctUntilChanged()
            .bind(to: labelSeller.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.numberOfReview }
            .distinctUntilChanged()
            .bind(to: labelReview.rx.text)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isLiked }
            .distinctUntilChanged()
            .bind(to: buttonLike.rx.isSelected)
            .disposed(by: disposeBag)

        reactor.state
            .map { !$0.isClosed }
            .distinctUntilChanged()
            .bind(to: buttonSubmit.rx.isEnabled)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isParticipating }
            .distinctUntilChanged()
            .bind(to: buttonSubmit.rx.isSelected)
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.isSharePopUpHidden }
            .bind(to: buttonSharePopUp.rx.isHidden)
            .disposed(by: disposeBag)
    }
    private func bindComments(reactor: ItemReactor) {
        reactor.state
            .map { $0.commentText }
            .distinctUntilChanged()
            .bind(to: buttonComment.rx.title(for: .normal))
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.comments ?? [] }
            .bind(to: tableView.rx.items(Reusable.commentCell)) { [weak self] _, comment, cell in
                cell.setData(comment: comment)
                cell.buttonReply.isEnabled = false
                cell.buttonMore.rx.tap
                    .subscribe(onNext: {
                        self?.presentCommentActionSheet()
                    })
                    .disposed(by: cell.disposeBag)
                cell.buttonLike.rx.tap
                    .map { Reactor.Action.likeComment(comment.commentId) }
                    .bind(to: reactor.action)
                    .disposed(by: cell.disposeBag)
            }
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
    private func attributedStringFor(title: String?) -> NSAttributedString? {
        guard let title = title else { return nil }
        let attributedText = NSAttributedString(string: title, attributes: Style.itemText)
        return attributedText
    }
    private func attributedStringFor(price: String?) -> NSAttributedString? {
        guard let price = price else { return nil }
        let attributedText = NSAttributedString(string: price, attributes: Style.priceOriginalText)
        return attributedText
    }
    private func attributedStringFor(number: Int?) -> NSAttributedString? {
        guard let number = number else { return nil }
        if number == 0 {
            return NSAttributedString(string: "1등으로 참여하기", attributes: Style.countFocusText)
        } else {
            let first = NSAttributedString(string: "\(number)명", attributes: Style.countFocusText)
            let second = NSAttributedString(string: " 참여중", attributes: Style.countNormalText)
            let attributedText = NSMutableAttributedString()
            attributedText.append(first)
            attributedText.append(second)
            return attributedText
        }
    }
    private func attributedStringFor(time: String?) -> NSAttributedString? {
        guard let time = time else { return nil }
        let first = NSAttributedString(string: time, attributes: Style.countFocusText)
        let second = NSAttributedString(string: " 남음", attributes: Style.countNormalText)
        let attributedText = NSMutableAttributedString()
        attributedText.append(first)
        attributedText.append(second)
        return attributedText
    }
}

extension ItemViewController {
    private func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).inset(44)
        }
        view.insertSubview(viewBackground, belowSubview: navigationBar)
        viewBackground.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar)
        }
    }
    private func setupTableView() {
        view.insertSubview(tableView, at: 0)
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }

        let viewBanner = setupItemBanner()
        let viewInfo = setupItemInfo(view: viewBanner)
        let viewDiscount = setupItemDiscount(view: viewInfo)
        let viewDeadline = setupItemDeadline(view: viewDiscount)
        let viewProfile = setupItemProfile(view: viewDeadline)
        setupItemDetail(view: viewProfile)
        setupInput()

        let viewTableHeader = UIView().then {
            $0.backgroundColor = .clear
        }
        viewTableHeader.addSubview(viewHeader)
        viewHeader.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        tableView.tableHeaderView = viewTableHeader
    }
    private func setupItemBanner() -> UIView {
        let viewBanner = UIView().then {
            $0.backgroundColor = .clear
        }
        viewHeader.addSubview(viewBanner)
        viewBanner.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(viewBanner.snp.width)
        }
        viewBanner.addSubview(imageViewItem)
        imageViewItem.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }

        viewBanner.addSubview(buttonCategory)
        buttonCategory.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(18)
            $0.bottom.equalToSuperview().inset(15)
        }
        return viewBanner
    }
    private func setupItemInfo(view: UIView) -> UIView {
        let viewInfo = UIView().then {
            $0.backgroundColor = .clear
        }
        viewHeader.addSubview(viewInfo)
        viewInfo.snp.makeConstraints {
            $0.top.equalTo(imageViewItem.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        viewInfo.addSubview(labelItem)
        labelItem.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(18).priority(999)
        }
        let stackViewPrice = UIStackView().then {
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.alignment = .leading
            $0.spacing = 3
        }
        viewInfo.addSubview(stackViewPrice)
        stackViewPrice.snp.makeConstraints {
            $0.top.equalTo(labelItem.snp.bottom).offset(8)
            $0.leading.equalTo(labelItem)
            $0.bottom.equalToSuperview().inset(16)
        }
        let stackViewDiscount = UIStackView().then {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
            $0.alignment = .leading
            $0.spacing = 11
        }
        stackViewDiscount.addArrangedSubview(labelPricePercent)
        stackViewDiscount.addArrangedSubview(labelPriceDiscount)
        viewInfo.addSubview(labelCurrency)
        labelCurrency.snp.makeConstraints {
            $0.leading.equalTo(stackViewPrice.snp.trailing).offset(2)
            $0.bottom.equalTo(stackViewPrice).inset(6)
        }
        stackViewPrice.addArrangedSubview(labelPriceOriginal)
        stackViewPrice.addArrangedSubview(stackViewDiscount)
        let viewSeparator = UIView().then {
            $0.backgroundColor = 0xEEEEEE.color
        }
        viewInfo.addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20).priority(999)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        return viewInfo
    }
    private func setupItemDiscount(view: UIView) -> UIView {
        let viewDiscount = UIView().then {
            $0.backgroundColor = .clear
        }
        viewHeader.addSubview(viewDiscount)
        viewDiscount.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        viewDiscount.addSubview(buttonDiscountUntil)
        buttonDiscountUntil.snp.makeConstraints {
            $0.top.equalToSuperview().inset(19)
            $0.leading.equalToSuperview().inset(17)
        }
        viewDiscount.addSubview(buttonDiscountInfo)
        buttonDiscountInfo.snp.makeConstraints {
            $0.top.equalToSuperview().inset(17)
            $0.trailing.equalToSuperview().inset(18)
        }
        viewDiscount.addSubview(viewProgressBackground)
        viewProgressBackground.snp.makeConstraints {
            $0.top.equalTo(buttonDiscountUntil.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(Metric.leadingOffset).priority(999)
            $0.height.equalTo(4)
            $0.bottom.equalToSuperview()
        }
        let viewProgress = UIView().then {
            $0.backgroundColor = 0xFFC500.color
        }
        viewProgressBackground.addSubview(viewProgress)
        viewProgress.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        constraintProgressTrailing = viewProgressBackground.trailingAnchor.constraint(equalTo: viewProgress.trailingAnchor, constant: 100)
        constraintProgressTrailing.isActive = true
        return viewDiscount
    }
    private func setupItemDeadline(view: UIView) -> UIView {
        let viewDeadline = UIView().then {
            $0.backgroundColor = .clear
        }
        viewHeader.addSubview(viewDeadline)
        viewDeadline.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        viewDeadline.addSubview(buttonCount)
        buttonCount.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11)
            $0.leading.equalToSuperview().inset(Metric.leadingOffset)
            $0.bottom.equalToSuperview()
        }
        viewDeadline.addSubview(buttonTime)
        buttonTime.snp.makeConstraints {
            $0.leading.equalTo(buttonCount.snp.trailing).offset(8)
            $0.top.bottom.equalTo(buttonCount)
        }

        return viewDeadline
    }
    private func setupItemProfile(view: UIView) -> UIView {
        let viewProfile = UIView().then {
            $0.backgroundColor = .clear
        }
        viewHeader.addSubview(viewProfile)
        viewProfile.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        let viewBackground = UIView().then {
            $0.backgroundColor = Color.lightGray2
            $0.layer.cornerRadius = 5
            $0.layer.masksToBounds = true
        }
        viewProfile.addSubview(viewBackground)
        viewBackground.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(18).priority(999)
            $0.height.equalTo(66)
        }
        let imageViewThumbnail = UIImageView(image: #imageLiteral(resourceName: "image_thumbnail_w40h36"))
        viewBackground.addSubview(imageViewThumbnail)
        imageViewThumbnail.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(40)
        }
        let viewText = UIView().then {
            $0.backgroundColor = .clear
        }
        viewBackground.addSubview(viewText)
        viewText.snp.makeConstraints {
            $0.leading.equalTo(imageViewThumbnail.snp.trailing).offset(8)
            $0.centerY.equalToSuperview().offset(2)
        }
        viewText.addSubview(labelSeller)
        labelSeller.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        viewText.addSubview(labelReview)
        labelReview.snp.makeConstraints {
            $0.top.equalTo(labelSeller.snp.bottom).offset(2)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        let buttonEdit = UIButton().then {
            $0.setImage(#imageLiteral(resourceName: "icon_indicator_w24h24"), for: .normal)
        }
        viewBackground.addSubview(buttonEdit)
        buttonEdit.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(viewText.snp.trailing)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(44)
        }
        return viewProfile
    }
    private func setupItemDetail(view: UIView) {
        viewHeader.addSubview(imageViewDetail)
        imageViewDetail.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        constraintDetailHeight = imageViewDetail.heightAnchor.constraint(equalToConstant: 300)
        constraintDetailHeight.isActive = true
    }
    private func setupInput() {
        viewHeader.addSubview(viewInput)
        viewInput.snp.makeConstraints {
            $0.top.equalTo(imageViewDetail.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        viewInput.addSubview(buttonComment)
        buttonComment.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(18)
        }
        viewInput.addSubview(buttonViewAll)
        buttonViewAll.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(18)
            $0.centerY.equalTo(buttonComment)
        }
        let viewBackground = UIView().then {
            $0.backgroundColor = Color.lightGray2
            $0.layer.cornerRadius = 10
            $0.layer.masksToBounds = true
        }
        viewInput.addSubview(viewBackground)
        viewBackground.snp.makeConstraints {
            $0.top.equalTo(buttonComment.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview().inset(18).priority(999)
            $0.bottom.equalToSuperview().inset(25)
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
            $0.backgroundColor = 0xEEEEEE.color
        }
        viewInput.addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        viewInput.addSubview(buttonRedirect)
        buttonRedirect.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    private func setupBottomView() {
        view.addSubview(viewBottom)
        viewBottom.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(80)
        }
        constraintBottomView = viewBottom.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        constraintBottomView.isActive = true
        viewBottom.addSubview(buttonShare)
        buttonShare.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview().inset(Metric.leadingOffset)
        }
        viewBottom.addSubview(buttonLike)
        buttonLike.snp.makeConstraints {
            $0.leading.equalTo(buttonShare.snp.trailing).offset(10)
            $0.centerY.equalTo(buttonShare)
        }
        viewBottom.addSubview(buttonSubmit)
        buttonSubmit.snp.makeConstraints {
            $0.leading.equalTo(buttonLike.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(Metric.trailingOffset)
            $0.centerY.equalTo(buttonLike)
        }
        let viewSeparator = UIView().then {
            $0.backgroundColor = 0xCACACA.color
        }
        viewBottom.addSubview(viewSeparator)
        viewSeparator.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        view.addSubview(buttonSharePopUp)
        buttonSharePopUp.snp.makeConstraints {
            $0.leading.equalTo(buttonShare)
            $0.bottom.equalTo(buttonShare.snp.top).offset(-2)
        }
        view.addSubview(buttonScrollToTop)
        buttonScrollToTop.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(viewBottom.snp.top).offset(-20)
        }
    }
}
