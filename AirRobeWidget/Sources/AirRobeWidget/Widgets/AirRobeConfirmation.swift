//
//  AirRobeConfirmation.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit

open class AirRobeConfirmation: UIView {
    private lazy var orderConfirmationView: OrderConfirmationView = OrderConfirmationView.loadFromNib()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func initialize() {
        initView()
    }

    private func initView() {
        orderConfirmationView.addBorder()
        orderConfirmationView.addShadow()

        orderConfirmationView.titleLabel.text = Strings.orderConfirmationTitle
        orderConfirmationView.descriptionLabel.text = Strings.orderConfirmationDescription
        orderConfirmationView.activateLabel.text = Strings.orderconrifmrationActivateText

        orderConfirmationView.activateContainerView.backgroundColor = UIColor.black
        orderConfirmationView.activateContainerView.addBorder(borderWidth: 0, cornerRadius: 20)
        orderConfirmationView.activateContainerView.addShadow()
        orderConfirmationView.activateButton.addTarget(self, action: #selector(onTapActivate), for: .touchUpInside)

        addSubview(orderConfirmationView)
        orderConfirmationView.frame = bounds
        orderConfirmationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    @objc func onTapActivate(_ sender: UIButton) {
        print("Activate")
    }
}
#endif
