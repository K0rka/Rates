//
//  ConversionCell.swift
//  Rates
//
//  Created by Catherine Korovkina on 2/2/2562 BE.
//  Copyright © 2562 snm. All rights reserved.
//

import UIKit

class ConversionCell: UITableViewCell {

    @IBOutlet weak var rateTextfield: UITextField!
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var currencyCodeLabel: UILabel!
    @IBOutlet weak var currencyImageView: UIImageView!
    
    weak var conversionDelegate: UITextFieldDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with viewModel: ConversionRateViewModel) {
        
    }
    
    func handleSelection() {
        rateTextfield.becomeFirstResponder()
    }
    
}
