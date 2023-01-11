//
//  FeedExpenseCell.swift
//  Prototype
//
//  Created by m00nbek Melikulov on 1/11/23.
//

import UIKit

final class FeedExpenseCell: UITableViewCell {
    @IBOutlet private(set) var containerView: UIView!
    @IBOutlet private(set) var stackView: UIStackView!
    @IBOutlet private(set) var title: UILabel!
    @IBOutlet private(set) var cost: UILabel!
    @IBOutlet private(set) var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stackView.alpha = 0
        containerView.startShimmering()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        stackView.alpha = 0
        containerView.startShimmering()
    }
    
    func fadeIn() {
        UIView.animate(withDuration: 0.25, delay: 1.0, animations: {
            self.stackView.alpha = 1
        }) { completed in
            if completed {
                self.containerView.stopShimmering()
            }
        }
    }
}

private extension UIView {
    private var shimmerAnimationKey: String {
        return "shimmer"
    }
    
    func startShimmering() {
        let white = UIColor.white.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.7).cgColor
        let width = bounds.width
        let height = bounds.height
        
        let gradient = CAGradientLayer()
        gradient.colors = [alpha, white, alpha]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.6)
        gradient.locations = [0.4, 0.5, 0.6]
        gradient.frame = CGRect(x: -width, y: 0, width: width*3, height: height)
        layer.mask = gradient
        
        let animation = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.locations))
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]
        animation.duration = 1
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: shimmerAnimationKey)
    }
    
    func stopShimmering() {
        layer.mask = nil
    }
}
