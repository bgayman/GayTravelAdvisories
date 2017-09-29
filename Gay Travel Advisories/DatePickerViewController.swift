//
//  DatePickerViewController.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

protocol DatePickerViewControllerDelegate: class {
    func datePickerViewController(_ viewController: DatePickerViewController, didFinishWith date: Date)
}

class DatePickerViewController: UIViewController {

    @IBOutlet fileprivate weak var outlineView: UIView!
    @IBOutlet fileprivate weak var lineSeparatorView: UIView!
    @IBOutlet fileprivate weak var datePicker: UIDatePicker!
    @IBOutlet fileprivate weak var saveButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    weak var delegate: DatePickerViewControllerDelegate?
    fileprivate let minDate: Date
    
    init(delegate: DatePickerViewControllerDelegate, minDate: Date) {
        self.delegate = delegate
        self.minDate = minDate
        super.init(nibName: "\(DatePickerViewController.self)", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        saveButton.titleLabel?.font = UIFont.app_font(style: .headline, weight: UIFont.Weight.semibold)
        saveButton.setTitleColor(.white, for: .normal)
        
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.datePickerMode = .date
        datePicker.minimumDate = minDate
        
        outlineView.layer.cornerRadius = 10.0
        outlineView.layer.masksToBounds = true
        outlineView.layer.borderColor = UIColor.white.cgColor
        outlineView.layer.borderWidth = 1.0
        
        closeButton.tintColor = UIColor.app_orange
    }
    
    @IBAction func didPressSave(_ sender: UIButton) {
        delegate?.datePickerViewController(self, didFinishWith: datePicker.date)
        dismiss(animated: true)
    }
    
    @IBAction func didPressClose(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
