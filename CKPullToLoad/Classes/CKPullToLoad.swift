//
//  CKPullToLoad.swift
//  CKPullToLoad
//
//  Created by Cezary Kopacz on 01.03.2019.
//  Copyright © 2019 CezaryKopacz. All rights reserved.
//

import UIKit

public protocol CKPullToLoadDelegate: class {
    /// sends the trigger when the view is in the pull state
    func ckPullToLoadPullContent()
}

/// footer view state
public enum FooterState {
    case pull
    case release
}

public protocol CKPullToLoadFooter {
    func setHeight(_ height: CGFloat)
    var pullText: String { get }
    var releaseText: String { get }
    var state: FooterState { get set }
}

/// implement this protocol to create custom footer
public protocol CKPullToLoadFooterBase: CKPullToLoadFooter { }

public extension CKPullToLoadFooterBase where Self: UIView {
    /// default text when the view is in the .pull state, override if needed
    var pullText: String { return "PULL TO FETCH" }
    /// default text when the view is in the .fetch state, override if needed
    var releaseText: String { return "RELEASE TO FETCH" }
    
    func setOffset(_ offset: CGFloat) {
        self.setHeight(self.frame.size.height/2 + offset)
    }
}

public class CKPullToLoad: NSObject {
    private let tableView: UITableView
    weak var delegate: CKPullToLoadDelegate?
  
    private var contentOffsetKey = "contentOffset"
 
    var footerView: (CKPullToLoadFooterBase & UIView)?
    
    private lazy var defaultFooterView: CKPullToLoadFooterView = {
        let view: CKPullToLoadFooterView = UIView.fromNib()
        return view
    }()
    
    public init(tableView: UITableView, footerView: (CKPullToLoadFooterBase & UIView)?, delegate: CKPullToLoadDelegate?) {
        self.tableView = tableView
        super.init()
        self.delegate = delegate
        self.footerView = footerView ?? self.defaultFooterView
        self.tableView.tableFooterView = self.footerView
        self.subscribeEvents()
        self.footerView?.state = .pull
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: self.contentOffsetKey)
    }
    
    private func subscribeEvents() {
        self.tableView.addObserver(self, forKeyPath: self.contentOffsetKey, options: .new, context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView,
            obj == self.tableView && keyPath == self.contentOffsetKey {
            let offset = self.tableView.contentSize.height - self.tableView.contentOffset.y - self.tableView.frame.height
            
            guard offset < 0 else {
                return
            }
            
            self.updateFooterView(offset: abs(offset))
            
            guard let footerHeight = self.footerView?.frame.height else { return }
            
            guard footerHeight/2 + abs(offset) > footerHeight else {
                if self.footerView?.state == .release && self.tableView.isDragging {
                    self.footerView?.state = .pull
                }
                return
            }
            
            if self.tableView.isDragging {
                if self.footerView?.state != .release {
                    self.footerView?.state = .release
                }
            } else if self.footerView?.state != .pull {
                self.footerView?.state = .pull
                // time to pull that content!
                self.pull()
            }
        }
    }

    private func pull() {
        self.delegate?.ckPullToLoadPullContent()
    }
    
    private func updateFooterView(offset: CGFloat) {
        self.footerView?.setOffset(offset)
    }
}
