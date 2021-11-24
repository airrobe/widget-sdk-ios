//
//  WidgetOnShop.swift
//  
//
//  Created by King on 11/24/21.
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

open class WidgetOnShop: UIView {
    private lazy var widgetOnShop: OnShopView = OnShopView.loadFromNib()
    private var expandType: ExpandState = .closed
    private var switchState: SwitchState = .notAdded

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    func initView() {
        // Widget Border Style
        widgetOnShop.mainContainerView.layer.borderColor = UIColor.black.cgColor
        widgetOnShop.mainContainerView.layer.borderWidth = 1

        // Initializing Static Texts & Links
        widgetOnShop.titleLabel.text = Strings.add
        widgetOnShop.descriptionLabel.text = Strings.description
        widgetOnShop.potentialValueLabel.text = Strings.potentialValue

        widgetOnShop.detailedDescriptionLabel.setLinkText(
            orgText: Strings.detailedDescription,
            linkText: Strings.learnMoreLinkText,
            link: Strings.learnMoreLinkText)
        widgetOnShop.detailedDescriptionLabel.isHidden = true
        widgetOnShop.margin.isHidden = true
        widgetOnShop.extraInfoLabel.setLinkText(
            orgText: Strings.extraInfo,
            linkText: Strings.extraLinkText,
            link: Strings.extraLink)

        widgetOnShop.addToAirRobeSwitch.isOn = false
        widgetOnShop.addToAirRobeSwitch.addTarget(self, action: #selector(onTapSwitch), for: .valueChanged)

        widgetOnShop.mainContainerExpandButton.setTitle("", for: .normal)
        widgetOnShop.mainContainerExpandButton.addTarget(self, action: #selector(onTapExpand), for: .touchUpInside)

        addSubview(widgetOnShop)
        widgetOnShop.frame = self.bounds
        widgetOnShop.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    @objc func onTapSwitch(_ sender: UISwitch) {
        if sender.isOn {
            switchState = .added
            widgetOnShop.titleLabel.text = Strings.added
        } else {
            switchState = .notAdded
            widgetOnShop.titleLabel.text = Strings.add
        }
    }

    @objc func onTapExpand(_ sender: UIButton) {
        var degree = 0.0
        switch expandType {
        case .opened:
            expandType = .closed
            degree = 0.0
        case .closed:
            expandType = .opened
            degree = 1.0
        }

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.widgetOnShop.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), degree, 0.0, 0.0)
            self.widgetOnShop.detailedDescriptionLabel.isHidden.toggle()
            self.widgetOnShop.margin.isHidden.toggle()
            self.widgetOnShop.widgetStackView.layoutIfNeeded()
        })
    }

    open func isExpanded() -> ExpandState {
        return expandType
    }
}
#endif
