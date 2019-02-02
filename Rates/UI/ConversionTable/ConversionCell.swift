//
//  ConversionCell.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import UIKit

protocol CurrencyValueChangeDelegate: class {
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
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        viewModel = nil
    }
    
    func configure(with viewModel: ConversionRateViewModel) {
        self.viewModel = viewModel
        if !rateTextfield.isEditing {
            rateTextfield.text = String(format: "%.3f", viewModel.rate)
        }
        currencyCodeLabel.text = viewModel.code
        currencyImageView.image = viewModel.image
        currencyNameLabel.text = viewModel.name
        conversionDelegate = viewModel.conversionDelegate
    }
    
    func handleSelection() {
        rateTextfield.becomeFirstResponder()
    }
    
}

extension ConversionCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let swiftRange = Range(range, in: textField.text ?? "") {
            let futureString = textField.text?.replacingCharacters(in: swiftRange, with: string) ?? ""
            conversionDelegate?.text(willChangeTo: futureString, for: viewModel)
        }
        
        return true
    }
}
