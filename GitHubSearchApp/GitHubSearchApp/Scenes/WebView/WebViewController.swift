//
//  WebViewController.swift
//  GitHubSearchApp
//
//  Created by burt on 2018. 10. 28..
//  Copyright © 2018년 Burt.K. All rights reserved.
//

import Cocoa
import SnapKit
import WebKit
import RxSwift
import RxCocoa

class WebViewController: NSViewController {
    
    private lazy var closeButton: NSButton = {
        let view = NSButton(frame: .zero)
        view.title = "Close"
        view.font = NSFont.boldSystemFont(ofSize: 13)
        view.bezelStyle = NSButton.BezelStyle.rounded
        return view
    }()
    
    private lazy var webView: WKWebView = {
        let view = WKWebView(frame: .zero)
        return view
    }()
    
    private let disposeBag = DisposeBag()
    private let viewModel: WebViewModel
    init(viewModel: WebViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = NSView(frame: NSRect(x: 0, y: 0, width: 800, height: 600))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(closeButton)
        view.addSubview(webView)
        
        closeButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
        webView.snp.makeConstraints { (make) in
            make.top.equalTo(closeButton.snp.bottom).offset(16)
            make.left.right.bottom.equalToSuperview()
        }
        viewModel.rx_action.accept(InitAction())
        
        viewModel
            .output
            .urlRequest
            .subscribe(onNext: { [weak self] (urlRequest) in
                guard let urlRequest = urlRequest else { return }
                self?.webView.load(urlRequest)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .close
            .filter { $0 }
            .subscribe(onNext: { [weak self] (close) in
                self?.dismiss(nil)
            })
            .disposed(by: disposeBag)
        
        closeButton
            .rx
            .clickGesture()
            .when(.ended)
            .map { _ in return CloseWebViewAction() }
            .bind(to: viewModel.rx_action)
            .disposed(by: disposeBag)
        
    }
    
}
