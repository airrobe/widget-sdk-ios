//
//  OrderConfirmationView.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit
import Combine

final class OrderConfirmationView: UIView, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activateContainerView: UIView!
    @IBOutlet weak var activateLabel: UILabel!
    @IBOutlet weak var activateLoading: UIActivityIndicatorView!

    var superView: UIView?
    private(set) lazy var viewModel = OrderConfirmationViewModel()
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

        titleLabel.text = Strings.orderConfirmationTitle
        descriptionLabel.text = Strings.orderConfirmationDescription

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
            string: "\(Strings.orderActivateBaseUrl)\(configuration.appId)-\(viewModel.orderId)"
        )
        guard let url = url else {
            return
        }
        Utils.openUrl(url)
    }
}

private extension OrderConfirmationView {

    func setupBindings() {
        viewModel.$isAllSet
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] allSet in
                switch allSet {
                case .initializing:
                    #if DEBUG
                    print(WidgetLoadState.initializing.rawValue)
                    #endif
                case .noCategoryMappingInfo:
                    #if DEBUG
                    print(WidgetLoadState.noCategoryMappingInfo.rawValue)
                    #endif
                case .eligible:
                    self?.addToSuperView(superView: self?.superView)
                case .notEligible:
                    self?.removeFromSuperview()
                case .paramIssue:
                    self?.removeFromSuperview()
                    #if DEBUG
                    print(WidgetLoadState.paramIssue.rawValue)
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
