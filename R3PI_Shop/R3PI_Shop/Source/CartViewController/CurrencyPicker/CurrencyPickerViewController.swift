//
//  CurrencyPickerViewController.swift
//  R3PI_Shop
//
//  Created by Anatoli Benke on 1/7/2017.
//  Copyright © 2017 Private. All rights reserved.
//


import UIKit

@objc protocol CurrencyPickerViewControllerDelegate: class {
    func didDidSelectCurrency(currency: String)
}

class CurrencyPickerViewController: UIViewController {
    
    //==========================================================================
    //MARK:- Constants
    //==========================================================================
    
    struct Constants {
        static let StoryBoardIdentifier                     = "Main"
        static let CurrencyPickerViewControllerIdentifier   = "CurrencyPickerViewController"
        
        static let Height: CGFloat = 216.0
    }
    
    //==========================================================================
    //MARK:- Outlets
    //==========================================================================
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    //==========================================================================
    //MARK:- DataSource
    //==========================================================================
    
    var dataSource: [String]?
    
    //==========================================================================
    //MARK:- Variables
    //==========================================================================
    
    weak var delegate: CurrencyPickerViewControllerDelegate?
    
    //==========================================================================
    //MARK:- ViewController Methods
    //==========================================================================
    
    class func newInstance(with dataSource: [String], delegate: CurrencyPickerViewControllerDelegate) -> CurrencyPickerViewController {
        let controller = UIStoryboard(name: Constants.StoryBoardIdentifier, bundle: nil).instantiateViewController(withIdentifier: Constants.CurrencyPickerViewControllerIdentifier) as! CurrencyPickerViewController
        
        controller.delegate = delegate
        controller.dataSource = dataSource
        
        return controller
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
    }
    
    func preselect(currency: String, animated: Bool = false) {
        if let index = self.dataSource?.index(of: currency) {
            self.pickerView.selectRow(index, inComponent: 0, animated: animated)
        }
    }
}

//==========================================================================
//MARK:- UIPickerViewDataSource
//==========================================================================

extension CurrencyPickerViewController : UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
}

//==========================================================================
//MARK:- UIPickerViewDelegate
//==========================================================================

extension CurrencyPickerViewController : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataSource?[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let value = dataSource?[row] {
            self.delegate?.didDidSelectCurrency(currency: value)
        }
    }

}

