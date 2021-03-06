//
//  ConversionCell.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import UIKit

protocol CurrencyValueChangeDelegate: class {
    func transitionStarted()
    func transitionEnded()
    func text(willChangeTo newText: String, for currencyViewModel: ConversionRateViewModel?)
}

class ConversionCell: UITableViewCell {

    @IBOutlet weak var rateTextfield: UITextField!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyImageView: UIImageView!
    
    var viewModel: ConversionRateViewModel?
    weak var conversionDelegate: CurrencyValueChangeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rateTextfield.delegate = self
    }

    override func prepareForReuse() {
        super.prepareForReuse()
//        viewModel = nil
    }
    
    func configure(with viewModel: ConversionRateViewModel) {
        if !rateTextfield.isEditing {
            rateTextfield.text = viewModel.rate
//            if viewModel.rate > 0 {
//                rateTextfield.text = String(format: "%.3f", viewModel.rate)
//            } else {
//                rateTextfield.text = ""
//            }
        }
        if self.viewModel != viewModel {
            currencyCodeLabel.text = viewModel.code
            currencyImageView.image = viewModel.image
            currencyNameLabel.text = viewModel.name
            conversionDelegate = viewModel.conversionDelegate
            self.viewModel = viewModel
        }
    }
    
    func handleSelection() {
        rateTextfield.becomeFirstResponder()
    }
    
    // Pass handling to superviews == select cell, not textfield itself
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if super.hitTest(point, with: event) == rateTextfield {
            return self
        }
        return super.hitTest(point, with: event)
    }
}

extension ConversionCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        conversionDelegate?.transitionEnded()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        conversionDelegate?.transitionStarted()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let swiftRange = Range(range, in: textField.text ?? "") {
            let futureString = textField.text?.replacingCharacters(in: swiftRange, with: string) ?? ""
            if futureString == "." {
                textField.text = "0."
                conversionDelegate?.text(willChangeTo: "0", for: viewModel)
                return false
            }
            conversionDelegate?.text(willChangeTo: futureString, for: viewModel)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        conversionDelegate?.transitionEnded()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        conversionDelegate?.transitionStarted()
        return true
    }
}
