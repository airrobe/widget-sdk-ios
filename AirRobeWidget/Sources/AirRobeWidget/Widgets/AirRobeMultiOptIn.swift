//
//  AirRobeMultiOtpIn.swift
//  
//
//  Created by King on 12/2/21.
//

#if canImport(UIKit)
import UIKit
import Combine

open class AirRobeMultiOtpIn: UIView {
    enum ExpandState {
        case opened
        case closed
    }

    private(set) lazy var viewModel = AirRobeMultiOtpInModel()
    private var subscribers: [AnyCancellable] = []
    private lazy var otpInview: OtpInView = OtpInView.loadFromNib()
    private var expandType: ExpandState = .closed

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func initialize(
        viewController: UIViewController,
        items: [String]
    ) {
        viewModel.vc = viewController
        viewModel.items = items

        setupBindings()
        if let categoryModel = CategoryModelInstance.shared.categoryModel {
            viewModel.initializeWidget(categoryModel: categoryModel)
        }
    }

    private func setupBindings() {
        CategoryModelInstance.shared.$categoryModel
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                print($0)
            }, receiveValue: { [weak self] categoryModel in
                guard let self = self, let categoryModel = categoryModel else {
                    return
                }
                self.viewModel.initializeWidget(categoryModel: categoryModel)
            }).store(in: &subscribers)

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
                    print(AirRobeOtpInModel.LoadState.initializing.rawValue)
                    #endif
                case .eligible:
                    self.initView()
                case .notEligible:
                    self.isHidden = true
                case .paramIssue:
                    self.isHidden = true
                    #if DEBUG
                    print(AirRobeOtpInModel.LoadState.paramIssue.rawValue)
                    #endif
                }
            }).store(in: &subscribers)
    }

    private func initViewWithError(error: String) {
        let errorLabel: UILabel = {
            let v = UILabel()
            v.textColor = .red
            v.font = .systemFont(ofSize: 16)
            v.text = error
            v.textAlignment = .center
            v.lineBreakMode = .byWordWrapping
            v.numberOfLines = 0
            return v
        }()
        addSubview(errorLabel)
        errorLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        errorLabel.frame = bounds
        errorLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func initView() {
        // Widget Border Style
        otpInview.mainContainerView.addBorder(cornerRadius: 0)

        // Initializing Static Texts & Links
        otpInview.titleLabel.text = UserDefaults.standard.OtpInfo ? Strings.added : Strings.add
        otpInview.descriptionLabel.text = Strings.description
        otpInview.potentialValueLabel.isHidden = true
        otpInview.potentialValueLoading.hidesWhenStopped = true

        otpInview.detailedDescriptionLabel.setLinkText(
            orgText: Strings.detailedDescription,
            linkText: Strings.learnMoreLinkText,
            tapHandler: onTapLearnMore)
        otpInview.detailedDescriptionLabel.isHidden = true
        otpInview.margin.isHidden = true
        otpInview.extraInfoLabel.setLinkText(
            orgText: Strings.extraInfo,
            linkText: Strings.extraLinkText,
            link: Strings.extraLink,
            tapHandler: onTapExtraInfoLink)

        otpInview.addToAirRobeSwitch.isOn = UserDefaults.standard.OtpInfo
        otpInview.addToAirRobeSwitch.addTarget(self, action: #selector(onTapSwitch), for: .valueChanged)
        otpInview.mainContainerExpandButton.addTarget(self, action: #selector(onTapExpand), for: .touchUpInside)

        addSubview(otpInview)
        otpInview.frame = bounds
        otpInview.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    private func onTapExtraInfoLink(_ url: URL?) {
        Utils.openUrl(url)
    }

    private func onTapLearnMore(_ url: URL?) {
        let alert = LearnMoreAlertViewController.instantiate()
        alert.modalPresentationStyle = .overCurrentContext
        alert.onDidDismiss = { [weak self] in
            guard let self = self else {
                return
            }
            self.otpInview.addToAirRobeSwitch.isOn = UserDefaults.standard.OtpInfo
        }
        viewModel.vc.present(alert, animated: true)
    }

    @objc func onTapSwitch(_ sender: UISwitch) {
        if sender.isOn {
            otpInview.titleLabel.text = Strings.added
            UserDefaults.standard.OtpInfo = true
        } else {
            otpInview.titleLabel.text = Strings.add
            UserDefaults.standard.OtpInfo = false
        }
    }

    @objc func onTapExpand(_ sender: UIButton) {
        let degree: CGFloat = {
            switch expandType {
            case .opened:
                expandType = .closed
                return 0.0
            case .closed:
                expandType = .opened
                return 1.0
            }
        }()

        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.otpInview.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi), degree, 0.0, 0.0)
            self.otpInview.detailedDescriptionLabel.isHidden.toggle()
            self.otpInview.margin.isHidden.toggle()
            self.otpInview.widgetStackView.layoutIfNeeded()
        })
    }
}
#endif
