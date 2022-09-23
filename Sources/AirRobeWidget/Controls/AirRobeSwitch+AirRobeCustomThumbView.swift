//
//  AirRobeSwitch+AirRobeCustomThumbView.swift
//  
//
//  Created by King on 9/23/22.
//

import UIKit

@IBDesignable
class AirRobeSwitch: UIControl {

    public var animationDelay: Double = 0
    public var animationSpriteWithDamping = CGFloat(0.7)
    public var initialSpringVelocity = CGFloat(0.5)
    public var animationOptions: AnimationOptions = [AnimationOptions.curveEaseOut, AnimationOptions.beginFromCurrentState, AnimationOptions.allowUserInteraction]

    @IBInspectable public var isOn:Bool = true

    public var animationDuration: Double = 0.5

    @IBInspectable public var padding: CGFloat = 3 {
        didSet {
            layoutSubviews()
        }
    }

    @IBInspectable public var borderColor: UIColor = .gray {
        didSet {
            setupUI()
        }
    }

    @IBInspectable public var onTintColor: UIColor = .white {
        didSet {
            setupUI()
        }
    }

    @IBInspectable public var offTintColor: UIColor = .black {
        didSet {
            setupUI()
        }
    }

    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return privateCornerRadius
        }
        set {
            if newValue > 0.5 || newValue < 0.0 {
                privateCornerRadius = 0.5
            } else {
                privateCornerRadius = newValue
            }
        }
    }

    private var privateCornerRadius: CGFloat = 0.5 {
        didSet {
            layoutSubviews()
        }
    }

    // thumb properties
    @IBInspectable public var thumbOnTintColor: UIColor = .white {
        didSet {
            setupUI()
        }
    }

    @IBInspectable public var thumbOffTintColor: UIColor = .white {
        didSet {
            setupUI()
        }
    }

    @IBInspectable public var thumbCornerRadius: CGFloat {
        get {
            return privateThumbCornerRadius
        }
        set {
            if newValue > 0.5 || newValue < 0.0 {
                privateThumbCornerRadius = 0.5
            } else {
                privateThumbCornerRadius = newValue
            }
        }
    }

    private var privateThumbCornerRadius: CGFloat = 0.5 {
        didSet {
            layoutSubviews()
        }
    }

    @IBInspectable public var thumbSize: CGSize = CGSize.zero {
        didSet {
            layoutSubviews()
        }
    }

    @IBInspectable public var thumbOnImage: UIImage? = nil {
        didSet {
            layoutSubviews()
        }
    }

    @IBInspectable public var thumbOffImage: UIImage? = nil {
        didSet {
            layoutSubviews()
        }
    }

    public var onImage: UIImage? {
        didSet {
            onImageView.image = onImage
            layoutSubviews()
        }
    }

    public var offImage:UIImage? {
        didSet {
            offImageView.image = offImage
            layoutSubviews()
        }
    }

    @IBInspectable public var thumbShadowColor: UIColor = UIColor.black {
        didSet {
            self.thumbView.layer.shadowColor = self.thumbShadowColor.cgColor
        }
    }

    @IBInspectable public var thumbShadowOffset: CGSize = CGSize(width: 0.75, height: 2) {
        didSet {
            self.thumbView.layer.shadowOffset = self.thumbShadowOffset
        }
    }

    @IBInspectable public var thumbShaddowRadius: CGFloat = 1.5 {
        didSet {
            self.thumbView.layer.shadowRadius = self.thumbShaddowRadius
        }
    }

    @IBInspectable public var thumbShaddowOppacity: Float = 0.4 {
        didSet {
            self.thumbView.layer.shadowOpacity = self.thumbShaddowOppacity
        }
    }

    // labels
    public var labelOff:UILabel = UILabel()
    public var labelOn:UILabel = UILabel()

    public var areLabelsShown: Bool = false {
        didSet {
            self.setupUI()
        }
    }

    public var thumbView = AirRobeCustomThumbView(frame: CGRect.zero)
    public var onImageView = UIImageView(frame: CGRect.zero)
    public var offImageView = UIImageView(frame: CGRect.zero)
    public var onPoint = CGPoint.zero
    public var offPoint = CGPoint.zero
    public var isAnimating = false

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
}

// MARK: Private methods
extension AirRobeSwitch {
    fileprivate func setupUI() {
        // clear self before configuration
        clear()

        clipsToBounds = false

        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 1

        // configure thumb view
        thumbView.backgroundColor = isOn ? thumbOnTintColor : thumbOffTintColor
        thumbView.isUserInteractionEnabled = false

        thumbView.layer.shadowColor = thumbShadowColor.cgColor
        thumbView.layer.shadowRadius = thumbShaddowRadius
        thumbView.layer.shadowOpacity = thumbShaddowOppacity
        thumbView.layer.shadowOffset = thumbShadowOffset

        backgroundColor = isOn ? onTintColor : offTintColor

        addSubview(thumbView)
        addSubview(onImageView)
        addSubview(offImageView)

        setupLabels()
    }

    private func clear() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }

    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        animate()
        return true
    }

    func setOn(on:Bool, animated:Bool) {
        switch animated {
        case true:
            animate(on: on)
        case false:
            isOn = on
            setupViewsOnAction()
            completeAction()
        }
    }

    fileprivate func animate(on:Bool? = nil) {
        isOn = on ?? !isOn
        isAnimating = true

        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [AnimationOptions.curveEaseOut, AnimationOptions.beginFromCurrentState, AnimationOptions.allowUserInteraction], animations: {
            self.setupViewsOnAction()
        }, completion: { _ in
            self.completeAction()
        })
    }

    private func setupViewsOnAction() {
        thumbView.frame.origin.x = isOn ? onPoint.x : offPoint.x
        thumbView.backgroundColor = isOn ? thumbOnTintColor : thumbOffTintColor
        backgroundColor = isOn ? onTintColor : offTintColor
        setOnOffImageFrame()
    }

    private func completeAction() {
        isAnimating = false
        sendActions(for: UIControl.Event.valueChanged)
    }
}

// Mark: Public methods
extension AirRobeSwitch {
    public override func layoutSubviews() {
        super.layoutSubviews()

        if !isAnimating {
            layer.cornerRadius = bounds.size.height * cornerRadius
            backgroundColor = isOn ? onTintColor : offTintColor

            // thumb managment
            // get thumb size, if none set, use one from bounds
            let thumbSize = thumbSize != CGSize.zero ? thumbSize : CGSize(width: bounds.size.height - 5, height: bounds.height - 5)
            let yPostition = (bounds.size.height - thumbSize.height) / 2

            onPoint = CGPoint(x: bounds.size.width - thumbSize.width - padding, y: yPostition)
            offPoint = CGPoint(x: padding, y: yPostition)

            thumbView.frame = CGRect(origin: isOn ? onPoint : offPoint, size: thumbSize)
            thumbView.layer.cornerRadius = thumbSize.height * thumbCornerRadius
            thumbView.backgroundColor = isOn ? thumbOnTintColor : thumbOffTintColor
            thumbView.thumbImageView.image = isOn ? thumbOnImage?.withTintColor(thumbOffTintColor) : thumbOffImage?.withTintColor(thumbOnTintColor)

            //label frame
            if areLabelsShown {
                let labelWidth = bounds.width / 2 - padding * 2
                labelOn.frame = CGRect(x: 0, y: 0, width: labelWidth, height: frame.height)
                labelOff.frame = CGRect(x: frame.width - labelWidth, y: 0, width: labelWidth, height: frame.height)
            }

            // on/off images
            //set to preserve aspect ratio of image in thumbView
            guard onImage != nil && offImage != nil else {
                return
            }

            let frameSize = thumbSize.width > thumbSize.height ? thumbSize.height * 0.7 : thumbSize.width * 0.7
            let onOffImageSize = CGSize(width: frameSize, height: frameSize)

            onImageView.frame.size = onOffImageSize
            offImageView.frame.size = onOffImageSize

            onImageView.center = CGPoint(x: onPoint.x + thumbView.frame.size.width / 2, y: thumbView.center.y)
            offImageView.center = CGPoint(x: offPoint.x + thumbView.frame.size.width / 2, y: thumbView.center.y)

            onImageView.alpha = isOn ? 1.0 : 0.0
            offImageView.alpha = isOn ? 0.0 : 1.0
        }
    }
}

//Mark: Labels frame
extension AirRobeSwitch {
    fileprivate func setupLabels() {
        guard areLabelsShown else {
            labelOff.alpha = 0
            labelOn.alpha = 0
            return
        }

        labelOff.alpha = 1
        labelOn.alpha = 1

        let labelWidth = bounds.width / 2 - padding * 2
        labelOn.frame = CGRect(x: 0, y: 0, width: labelWidth, height: frame.height)
        labelOff.frame = CGRect(x: frame.width - labelWidth, y: 0, width: labelWidth, height: frame.height)
        labelOn.font = UIFont.boldSystemFont(ofSize: 12)
        labelOff.font = UIFont.boldSystemFont(ofSize: 12)
        labelOn.textColor = UIColor.white
        labelOff.textColor = UIColor.white

        labelOff.sizeToFit()
        labelOff.text = "Off"
        labelOn.text = "On"
        labelOff.textAlignment = .center
        labelOn.textAlignment = .center

        insertSubview(labelOff, belowSubview: thumbView)
        insertSubview(labelOn, belowSubview: thumbView)
    }
}

//Mark: Animating on/off images
extension AirRobeSwitch {
    fileprivate func setOnOffImageFrame() {
        thumbView.thumbImageView.image = isOn ? thumbOnImage : thumbOffImage

        guard onImage != nil && offImage != nil else {
            return
        }

        onImageView.center.x = isOn ? onPoint.x + thumbView.frame.size.width / 2 : frame.width
        offImageView.center.x = !isOn ? offPoint.x + thumbView.frame.size.width / 2 : 0
        onImageView.alpha = isOn ? 1.0 : 0.0
        offImageView.alpha = isOn ? 0.0 : 1.0
    }
}

final class AirRobeCustomThumbView: UIView {
    fileprivate(set) var thumbImageView = UIImageView(frame: CGRect.zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(thumbImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubview(thumbImageView)
    }
}

extension AirRobeCustomThumbView {
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbImageView.frame = CGRect(x: 6, y: 6, width: frame.width - 12, height: frame.height - 12)
        thumbImageView.layer.cornerRadius = layer.cornerRadius
        thumbImageView.clipsToBounds = clipsToBounds
    }
}
