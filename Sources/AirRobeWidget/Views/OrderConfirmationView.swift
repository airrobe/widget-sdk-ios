//
//  OrderConfirmationView.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit

final class OrderConfirmationView: UIView, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activateContainerView: UIView!
    @IBOutlet weak var activateLabel: UILabel!
    @IBOutlet weak var activateButton: UIButton!
    @IBOutlet weak var activateLoading: UIActivityIndicatorView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        addBorder()
        addShadow()

        titleLabel.text = Strings.orderConfirmationTitle
        descriptionLabel.text = Strings.orderConfirmationDescription

        activateContainerView.backgroundColor = UIColor.black
        activateContainerView.addBorder(borderWidth: 0, cornerRadius: 20)
        activateContainerView.addShadow()

        activateLoading.hidesWhenStopped = true
        activateLoading.startAnimating()
    }
}
#endif
