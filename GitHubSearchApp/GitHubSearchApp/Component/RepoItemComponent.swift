//
//  RepoItemComponent.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 9. 26..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import CocoaReactComponentKit
import SDWebImage
import RxSwift

class RepoItemComponent: NSViewComponent {
    
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
        view.layer?.cornerRadius = 16
        view.layer?.masksToBounds = true
        return view
    }()
    
    private lazy var nameLabel: NSTextField = {
        let label = NSTextField(frame: .zero)
        label.font = NSFont.boldSystemFont(ofSize: 18)
        label.textColor = NSColor.black
        label.isEditable = false
        label.isBordered = false
        label.usesSingleLineMode = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var descriptionLabel: NSTextField = {
        let label = NSTextField(frame: .zero)
        label.font = NSFont.systemFont(ofSize: 14)
        label.textColor = NSColor.black
        label.isEditable = false
        label.isBordered = false
        label.usesSingleLineMode = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var htmlUrlLabel: NSTextField = {
        let label = NSTextField(frame: .zero)
        label.font = NSFont.systemFont(ofSize: 12)
        label.textColor = NSColor.black
        label.isEditable = false
        label.isBordered = false
        label.usesSingleLineMode = true
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var infoLabel: NSTextField = {
        let label = NSTextField(frame: .zero)
        label.font = NSFont.boldSystemFont(ofSize: 14)
        label.textColor = NSColor.black
        label.isEditable = false
        label.isBordered = false
        label.usesSingleLineMode = true
        return label
    }()

    private lazy var labelStackView: NSStackView = {
        let stackView = NSStackView(views: [nameLabel, descriptionLabel, htmlUrlLabel, infoLabel])
        stackView.orientation = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillProportionally
        stackView.alignment = .left
        return stackView
    }()
    
    override func contentSize(in view: NSView) -> CGSize {
        return CGSize(width: view.bounds.width, height: labelStackView.intrinsicContentSize.height)
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
            make.left.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(32)
        }
        
        labelStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.left.equalTo(avatarImageView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        clickView.onTap { [weak self] in
            guard let strongSelf = self, let htmlUrl = strongSelf.htmlUrl else { return }
            strongSelf.dispatch(action: ClickItemAction(htmlUrl: htmlUrl))
        }.disposed(by: disposeBag)
    }
    
    override func configure<Item>(item: Item, at indexPath: IndexPath) {
        guard let repoItem = item as? RepoItemModel else { return }
        self.htmlUrl = repoItem.repo.htmlUrl
        self.nameLabel.stringValue = repoItem.repo.name
        self.descriptionLabel.stringValue = repoItem.repo.description?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        self.htmlUrlLabel.stringValue = repoItem.repo.htmlUrl
        self.infoLabel.stringValue = "\(repoItem.repo.language ?? "Unknown") ⭐️\(repoItem.repo.starCount) 🐙\(repoItem.repo.forkCount) 🤩\(repoItem.repo.watcherCount)"
        if let avatarUrl = repoItem.repo.owner.avatarUrl {
            self.avatarImageView.sd_setImage(with: URL(string: avatarUrl), completed: nil)
        }
    }
}
