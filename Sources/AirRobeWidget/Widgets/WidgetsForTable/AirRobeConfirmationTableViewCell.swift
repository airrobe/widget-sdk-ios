//
//  AirRobeConfirmationTableViewCell.swift
//  
//
//  Created by King on 2/17/22.
//

#if canImport(UIKit)
import UIKit
import Combine

open class AirRobeConfirmationTableViewCell: UITableViewCell {
    @IBOutlet weak var mainContainerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activateContainerView: UIView!
    @IBOutlet weak var activateLabel: UILabel!
    @IBOutlet weak var activateLoading: UIActivityIndicatorView!

    public static var reuseIdentifier: String { return "AirRobeConfirmationTableViewCell" }
    public static var nib: UINib { return UINib(nibName: "AirRobeConfirmationTableViewCell", bundle: .module) }
    private(set) lazy var viewModel = AirRobeOrderConfirmationViewModel()
    private var subscribers: [AnyCancellable] = []

    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    /// initalizing AirRobeConfirmationTableViewCell
    /// - Parameters:
    ///   - orderId: string value of order Id generated from purchase
    ///   - email: email address that used for the purchase
    ///   - fraudRisk: fraud status for the confirmation widget
    public func initialize(
        orderId: String,
        email: String,
        fraudRisk: Bool = false
    ) {
        viewModel.orderId = orderId
        viewModel.email = email
        viewModel.fraudRisk = fraudRisk
        viewModel.initializeConfirmationWidget()
    }

    private func commonInit() {
        mainContainerView.addBorder()
        mainContainerView.addShadow()

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

private extension AirRobeConfirmationTableViewCell {

    func setupBindings() {
        viewModel.$isAllSet
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] allSet in
                switch allSet {
                case .initializing:
                    self?.isCellHidden(hidden: true)
                    #if DEBUG
                    print(AirRobeWidgetLoadState.initializing.rawValue)
                    #endif
                case .noCategoryMappingInfo:
                    self?.isCellHidden(hidden: true)
                    #if DEBUG
                    print(AirRobeWidgetLoadState.noCategoryMappingInfo.rawValue)
                    #endif
                case .eligible:
                    self?.isCellHidden(hidden: false)
                case .notEligible:
                    self?.isCellHidden(hidden: true)
                case .paramIssue:
                    self?.isCellHidden(hidden: true)
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

    func isCellHidden(hidden: Bool) {
        guard superview != nil, let tableView = superview as? UITableView else {
            return
        }
        tableView.beginUpdates()
        mainContainerView.isHidden = hidden
        tableView.endUpdates()
    }
}
#endif
