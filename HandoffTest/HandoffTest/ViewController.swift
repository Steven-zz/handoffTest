//
//  ViewController.swift
//  HandoffTest
//
//  Created by Steven Muliamin on 28/10/19.
//  Copyright © 2019 Steven Muliamin. All rights reserved.
//

import AsyncDisplayKit

internal class ViewController: ASViewController<ASDisplayNode> {
    
    private let textFieldNode = ASEditableTextNode()
    private let labelNode = ASTextNode()

    internal init(withText text: String? = nil) {
        let rootNode = ASDisplayNode()
        rootNode.backgroundColor = .white
        rootNode.automaticallyManagesSubnodes = true
        super.init(node: rootNode)
        
        textFieldNode.attributedText = NSAttributedString(string: text ?? "")
        textFieldNode.style.minWidth = ASDimension(unit: .points, value: 200)
        textFieldNode.style.height = ASDimension(unit: .points, value: 50)
        textFieldNode.borderColor = UIColor.black.cgColor
        textFieldNode.borderWidth = 1
        textFieldNode.delegate = self
        
        labelNode.attributedText = NSAttributedString(string: text ?? "")
        labelNode.style.minWidth = ASDimension(unit: .points, value: 200)
        labelNode.style.height = ASDimension(unit: .points, value: 50)
        labelNode.borderColor = UIColor.black.cgColor
        labelNode.borderWidth = 1
        
        rootNode.layoutSpecBlock = { [weak self] _,_ -> ASLayoutSpec in
            guard let self = self else { return ASLayoutSpec() }
            return ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .spaceAround, alignItems: .center, children: [self.textFieldNode, self.labelNode])
        }
    }
    
    override func viewDidLoad() {
        startUserActivity()
    }
    
    // 1.
    internal func startUserActivity() {
        let activity = NSUserActivity(activityType: HandoffActivity.test)
        activity.title = "Testing 123"
        activity.userInfo = [HandoffActivity.key: "hello world"]
        userActivity = activity
        userActivity?.becomeCurrent()
    }
    
    // 2.
    override func updateUserActivityState(_ activity: NSUserActivity) {
        activity.addUserInfoEntries(from: [HandoffActivity.key: "updated hello world"])
        super.updateUserActivityState(activity)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ViewController: ASEditableTextNodeDelegate {
    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode) {
        if let text = editableTextNode.attributedText?.string {
            labelNode.attributedText = NSAttributedString(string: text)
        } else {
            labelNode.attributedText = NSAttributedString(string: "")
        }
    }
}

