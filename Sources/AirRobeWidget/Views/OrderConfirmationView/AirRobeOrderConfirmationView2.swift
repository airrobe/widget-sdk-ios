//
//  AirRobeOrderConfirmationView2.swift
//  
//
//  Created by King on 9/21/22.
//

#if canImport(UIKit)
import UIKit
import Combine

final class AirRobeOrderConfirmationView2: UIView, NibLoadable {
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activateContainerView: UIView!
    @IBOutlet weak var activateLabel: UILabel!
    @IBOutlet weak var activateLoading: UIActivityIndicatorView!

    var superView: UIView?
    private var alreadyAdded: Bool = false
    private(set) lazy var viewModel = AirRobeOrderConfirmationViewModel()
    private var subscribers: [AnyCancellable] = []

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
        addBorder(color: AirRobeBorderColor.cgColor, cornerRadius: 0)

        titleLabel.text = AirRobeStrings.orderConfirmationTitle.uppercased()
        titleLabel.textColor = AirRobeTextColor
        descriptionLabel.text = AirRobeStrings.orderConfirmationDescriptionVariant2
        descriptionLabel.textColor = AirRobeTextColor

        activateContainerView.backgroundColor = AirRobeButtonBorderColor
        activateLabel.textColor = AirRobeButtonTextColor

        activateLoading.hidesWhenStopped = true
        activateLoading.startAnimating()

        mainStackView.setCustomSpacing(4, after: titleLabel)
        
        setupBindings()
    }

    @IBAction func onTapActivate(_ sender: Any) {
        guard let configuration = configuration else {
            return
        }
        let url = URL(
            string: "\(configuration.mode == .production ? AirRobeStrings.orderActivateBaseUrl : AirRobeStrings.orderActivateSandBoxBaseUrl)\(configuration.appId)-\(viewModel.orderId)/claim"
        )
        guard let url = url else {
            return
        }
        AirRobeUtils.telemetryEvent(eventName: TelemetryEventName.confirmationClick.rawValue, pageName: PageName.thankYou.rawValue)
        AirRobeUtils.dispatchEvent(eventName: EventName.confirmationClick.rawValue, pageName: PageName.thankYou.rawValue)
        AirRobeUtils.openUrl(url)
    }
}

private extension AirRobeOrderConfirmationView2 {

    func setupBindings() {
        viewModel.$isAllSet
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] allSet in
                guard let self = self else {
                    return
                }
                switch allSet {
                case .initializing:
                    #if DEBUG
                    print(AirRobeWidgetLoadState.initializing.rawValue)
                    #endif
                case .noCategoryMappingInfo:
                    #if DEBUG
                    print(AirRobeWidgetLoadState.noCategoryMappingInfo.rawValue)
                    #endif
                case .eligible:
                    self.alreadyAdded = self.addToSuperView(superView: self.superView, alreadyAddedToTable: self.alreadyAdded)
                case .notEligible:
                    self.removeFromSuperview()
                case .paramIssue:
                    self.removeFromSuperview()
                    #if DEBUG
                    print(AirRobeWidgetLoadState.paramIssue.rawValue)
                    #endif
                }
            }).store(in: &subscribers)

        viewModel.$activateText
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] activateText in
                guard let self = self, !activateText.isEmpty else {
                    return
                }
                self.activateLoading.stopAnimating()
                self.activateLabel.text = activateText
            }).store(in: &subscribers)
    }

}
#endif
