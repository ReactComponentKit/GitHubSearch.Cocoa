//
//  UserItemComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import CocoaReactComponentKit
import SnapKit
import RxSwift
import SDWebImage

class UserItemComponent: NSViewComponent {
    
    private var htmlUrl: String? = nil
    private let disposeBag = DisposeBag()
    
    private lazy var cardView: NSView = {
        let view = NSView(frame: .zero)
        view.wantsLayer = true
        view.layer?.backgroundColor = .white
        
        let cornerRadius: CGFloat = 3
        let shadowOffsetWidth: Int = 0
        let shadowOffsetHeight: Int = 3
        let shadowColor: NSColor = NSColor.black
        let shadowOpacity: Float = 0.5
        view.layer?.cornerRadius = cornerRadius
        view.layer?.masksToBounds = false
        view.layer?.shadowColor = shadowColor.cgColor
        view.layer?.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        view.layer?.shadowOpacity = shadowOpacity
        
        return view
    }()
    
    private lazy var clickView: NSView = {
        let view = NSView(frame: .zero)
        view.wantsLayer = true
        view.layer?.backgroundColor = .clear
        return view
    }()
    
    private lazy var avatarImageView: NSImageView = {
        let view = NSImageView(frame: .zero)
        view.imageScaling = .scaleProportionallyUpOrDown
        view.wantsLayer = true
        view.layer?.cornerRadius = 30
        view.layer?.masksToBounds = true
        return view
    }()
    
    private lazy var nameLabel: NSTextField = {
        let label = NSTextField(frame: .zero)
        label.font = NSFont.boldSystemFont(ofSize: 18)
        label.textColor = NSColor.black
        label.alignment = .left
        label.usesSingleLineMode = true
        label.isEditable = false
        label.isBordered = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var htmlUrlLabel: NSTextField = {
        let label = NSTextField(frame: .zero)
        label.font = NSFont.systemFont(ofSize: 12)
        label.textColor = NSColor.black
        label.alignment = .left
        label.usesSingleLineMode = true
        label.isEditable = false
        label.isBordered = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var repoLabel: NSTextField = {
        let label = NSTextField(frame: .zero)
        label.font = NSFont.boldSystemFont(ofSize: 14)
        label.textColor = NSColor.gray
        label.usesSingleLineMode = false
        label.isEditable = false
        label.isBordered = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var followerLabel: NSTextField = {
        let label = NSTextField(frame: .zero)
        label.font = NSFont.boldSystemFont(ofSize: 14)
        label.textColor = NSColor.gray
        label.isEditable = false
        label.isBordered = false
        return label
    }()
    
    private lazy var labelStackView: NSStackView = {
        let stackView = NSStackView(views: [nameLabel, htmlUrlLabel, repoLabel])
        stackView.orientation = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .left
        return stackView
    }()
    
    override func contentSize(in view: NSView) -> CGSize {
        return .zero
    }
    
    override func setupView() {
        addSubview(cardView)
        addSubview(clickView)
        cardView.addSubview(avatarImageView)
        cardView.addSubview(labelStackView)
        
        cardView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        clickView.snp.makeConstraints { (make) in
            make.edges.equalTo(cardView)
        }
        
        avatarImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(60)
        }
        
        labelStackView.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImageView.snp.right).offset(16)
            make.top.equalTo(avatarImageView)
        }
    
        clickView.onTap { [weak self] in
            guard let strongSelf = self, let htmlUrl = strongSelf.htmlUrl else { return }
            strongSelf.dispatch(action: ClickItemAction(htmlUrl: htmlUrl))
        }.disposed(by: disposeBag)
    }
    
    override func configure<Item>(item: Item, at indexPath: IndexPath) {
        guard let userItem = item as? UserItemModel else { return }
        self.htmlUrl = userItem.user.htmlUrl
        self.nameLabel.stringValue = userItem.user.name ?? userItem.user.login
        self.htmlUrlLabel.stringValue = userItem.user.htmlUrl
        self.repoLabel.stringValue =
        """
        Repo: \(userItem.user.totalRepoCount ?? 0) / Gist: \(userItem.user.totalGistCount ?? 0)
        Follower: \(userItem.user.followerCount ?? 0)
        Following: \(userItem.user.followingCount ?? 0)
        """
        if let avatarUrl = userItem.user.avatarUrl {
            self.avatarImageView.sd_setImage(with: URL(string: avatarUrl), completed: nil)
        }
    }
}
