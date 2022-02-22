//
//  AirRobeOrderConfirmationView.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit
import Combine

final class AirRobeOrderConfirmationView: UIView, NibLoadable {
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
        addBorder()
        addShadow()

        titleLabel.text = AirRobeStrings.orderConfirmationTitle
        descriptionLabel.text = AirRobeStrings.orderConfirmationDescription

        activateContainerView.backgroundColor = UIColor.black
        activateContainerView.addBorder(borderWidth: 0, cornerRadius: 20)
        activateContainerView.addShadow()

        activateLoading.hidesWhenStopped = true
        activateLoading.startAnimating()

        setupBindings()
    }

    @IBAction func onTapActivate(_ sender: Any) {
        guard let configuration = configuration else {
            return
        }
        let url = URL(
            string: "\(AirRobeStrings.orderActivateBaseUrl)\(configuration.appId)-\(viewModel.orderId)"
        )
        guard let url = url else {
            return
        }
        AirRobeUtils.openUrl(url)
    }
}

private extension AirRobeOrderConfirmationView {

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
