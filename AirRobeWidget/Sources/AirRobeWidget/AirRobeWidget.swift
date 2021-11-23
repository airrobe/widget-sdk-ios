//
//  ExpandableView.swift
//
//
//  Created by King on 11/22/21.
//

#if canImport(UIKit)
import UIKit

public enum ExpandState {
    case opened
    case closed
}

public enum SwitchState {
    case added
    case notAdded
}

open class AirRobeWidget: UIView {
    private lazy var widgetOnShop: WidgetOnShop = WidgetOnShop.loadFromNib()
    private var expandType: ExpandState = .closed
    private var switchState: SwitchState = .notAdded
    private var highlightAnimation = HighlightAnimation.animated

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    func initView() {
        addSubview(widgetOnShop)
        widgetOnShop.frame = self.bounds
        widgetOnShop.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        widgetOnShop.mainContainerView.layer.borderColor = UIColor.black.cgColor
        widgetOnShop.mainContainerView.layer.borderWidth = 1
    }

    @objc func onTapSwitch(_ selector: UISwitch) {
        if selector.isOn {
            switchState = .added
        } else {
            switchState = .notAdded
        }
    }

//    func open() {
//        expandType = .opened
//        if highlightAnimation == .animated {
//            UIView.animate(withDuration: 0.3) {[weak self] in
//                guard let self = self else {
//                    return
//                }
//                self.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), 1.0, 0.0, 0.0)
//            }
//        }
//    }
//
//    func close() {
//        expandType = .closed
//        if highlightAnimation == .animated {
//            UIView.animate(withDuration: 0.3) {[weak self] in
//                guard let self = self else {
//                    return
//                }
//                self.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), 0.0, 0.0, 0.0)
//            }
//        }
//    }
//
//    open func isExpanded() -> ExpandState {
//        return expandType
//    }
}

public enum HighlightAnimation {
    case animated
    case none
}
#endif
