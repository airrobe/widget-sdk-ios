//
//  ExpandableView.swift
//  
//
//  Created by King on 11/21/21.
//

import Foundation
import UIKit

public enum ExpandState {
    case opened
    case closed
}

public enum SwitchState {
    case added
    case notAdded
}
open class ExpandableView: UIView {
    open var rightMargin: CGFloat = 16
    open var highlightAnimation = HighlightAnimation.animated
    open var arrowImageView: UIImageView!
    private var expandType: ExpandState = .closed
    private var switchState: SwitchState = .notAdded

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView() {
        let widgetMainContainer = UIStackView()
        let widgetMainContainerConstraints = [
            widgetMainContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            widgetMainContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            widgetMainContainer.topAnchor.constraint(equalTo: topAnchor)
        ]
        widgetMainContainer.axis = .vertical
        addSubview(widgetMainContainer)

        let titleContainerView = UIView()
        let addToAirRobeSwitch = UISwitch()
        let addToAirRobeSwitchConstraints = [
            addToAirRobeSwitch.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: 10),
            addToAirRobeSwitch.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor)
        ]
        addToAirRobeSwitch.isOn = false
        addToAirRobeSwitch.addTarget(self, action: #selector(onTapSwitch), for: .valueChanged)
        titleContainerView.addSubview(addToAirRobeSwitch)

        arrowImageView = UIImageView()
        let arrowImageViewContraints = [
            arrowImageView.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: 10),
            arrowImageView.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor)
        ]
        arrowImageView.image = UIImage(named: "arrowDown", in: Bundle(for: ExpandableView.self), compatibleWith: nil)
        titleContainerView.addSubview(arrowImageView)

        let titleLabel = UILabel()
        let titleLabelConstraints = [
          titleLabel.leadingAnchor.constraint(equalTo: addToAirRobeSwitch.trailingAnchor, constant: 10),
          titleLabel.topAnchor.constraint(equalTo: titleContainerView.topAnchor, constant: 5)
        ]
        titleLabel.text = "Add to AirRobe"
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 18)
        titleContainerView.addSubview(titleLabel)

        let logoImageView = UIImageView()
        let logoImageViewContraints = [
            logoImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 5),
            logoImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ]
        logoImageView.image = UIImage(named: "logo")
        titleContainerView.addSubview(logoImageView)

        let descriptionLabel = UILabel()
        let descriptionLabelContraints = [
            descriptionLabel.leadingAnchor.constraint(equalTo: addToAirRobeSwitch.trailingAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor, constant: 5)
        ]
        descriptionLabel.text = "Wear now, re-sell later."
        descriptionLabel.textColor = .black
        descriptionLabel.font = .systemFont(ofSize: 16)
        titleContainerView.addSubview(descriptionLabel)

        let potentialValueLabel = UILabel()
        let potentialValueLabelContraints = [
            potentialValueLabel.leadingAnchor.constraint(equalTo: descriptionLabel.trailingAnchor, constant: 5),
            potentialValueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            potentialValueLabel.bottomAnchor.constraint(equalTo: titleContainerView.bottomAnchor, constant: 5),
            potentialValueLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: 5)
        ]
        potentialValueLabel.text = "Potential value: $56"
        potentialValueLabel.textColor = .black
        potentialValueLabel.font = .boldSystemFont(ofSize: 16)
        titleContainerView.addSubview(potentialValueLabel)

        widgetMainContainer.addArrangedSubview(titleContainerView)

        let detailedDescriptionLabel = UILabel()

        detailedDescriptionLabel.text = "We’ve partnered with AirRobe to enable you to join the circular fashion movement. Re-sell or rent your purchases on AirRobe’s marketplace – all with one simple click. Together, we can do our part to keep fashion out of landfill. Learn more."
        detailedDescriptionLabel.textColor = .black
        detailedDescriptionLabel.font = .systemFont(ofSize: 16)
        widgetMainContainer.addArrangedSubview(detailedDescriptionLabel)

        let extraInfoLabel = UILabel()
        let extraInfoLabelConstraints = [
            extraInfoLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            extraInfoLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            extraInfoLabel.topAnchor.constraint(equalTo: widgetMainContainer.bottomAnchor, constant: 10),
            extraInfoLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        extraInfoLabel.text = "By opting in you agree to THE ICONIC’s Privacy Policy and consent for us to share your details with AirRobe."
        extraInfoLabel.textColor = .black
        extraInfoLabel.font = .systemFont(ofSize: 16)
        addSubview(extraInfoLabel)

        NSLayoutConstraint.activate(widgetMainContainerConstraints)
        NSLayoutConstraint.activate(extraInfoLabelConstraints)
        NSLayoutConstraint.activate(addToAirRobeSwitchConstraints)
        NSLayoutConstraint.activate(logoImageViewContraints)
        NSLayoutConstraint.activate(arrowImageViewContraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelContraints)
        NSLayoutConstraint.activate(potentialValueLabelContraints)
    }

    @objc func onTapSwitch(_ selector: UISwitch) {
        if selector.isOn {
            switchState = .added
        } else {
            switchState = .notAdded
        }
    }

    func open() {
        expandType = .opened
        if highlightAnimation == .animated {
            UIView.animate(withDuration: 0.3) {[weak self] in
                guard let self = self else {
                    return
                }
                self.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), 1.0, 0.0, 0.0)
            }
        }
    }

    func close() {
        expandType = .closed
        if highlightAnimation == .animated {
            UIView.animate(withDuration: 0.3) {[weak self] in
                guard let self = self else {
                    return
                }
                self.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), 0.0, 0.0, 0.0)
            }
        }
    }

    open func isExpanded() -> ExpandState {
        return expandType
    }
}

public enum HighlightAnimation {
    case animated
    case none
}
