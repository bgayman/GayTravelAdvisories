//
//  AddTripViewController.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/28/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

protocol AddTripViewControllerDelegate: class {
    func addTripViewController(_ viewController: AddTripViewController, didFinishWith trip: Trip)
}

class AddTripViewController: UIViewController {
    
    enum DateSelectionState {
        case departureDate
        case returnDate
    }

    @IBOutlet fileprivate weak var destinationLabel: UILabel!
    @IBOutlet fileprivate weak var destinationTextField: UITextField!
    @IBOutlet fileprivate weak var departureLabel: UILabel!
    @IBOutlet fileprivate weak var departureTextField: UITextField!
    @IBOutlet fileprivate weak var returnLabel: UILabel!
    @IBOutlet fileprivate weak var returnTextField: UITextField!
    
    @objc static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    weak var delegate: AddTripViewControllerDelegate?
    var country: Country?
    @objc var departureDate: Date?
    @objc var returnDate: Date?
    var dateSelectionState = DateSelectionState.departureDate
    var trip: Trip? {
        guard let country = self.country,
              let departureDate = self.departureDate,
            let returnDate = self.returnDate else { return nil }
        return Trip(country: country, departureDate: departureDate, returnDate: returnDate)
    }
    
    lazy fileprivate var saveBarButtonItem: UIBarButtonItem = {
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.didPressSave(_:)))
        saveBarButtonItem.isEnabled = false
        return saveBarButtonItem
    }()
    
    lazy fileprivate var cancelBarButtonItem: UIBarButtonItem = {
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.didPressCancel(_:)))
        return cancelBarButtonItem
    }()
    
    init(delegate: AddTripViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: "\(AddTripViewController.self)", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.tintColor = .app_orange
        view.backgroundColor = .app_black
        
        navigationItem.rightBarButtonItem = saveBarButtonItem
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        [returnTextField, departureTextField, destinationTextField].forEach(style)

        destinationLabel.textColor = .white
        destinationLabel.font = UIFont.app_font(style: .title1, weight: UIFont.Weight.heavy)

        destinationTextField.attributedPlaceholder = NSAttributedString(string: "Country", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 0.9, alpha: 0.9)])
        
        departureLabel.textColor = .white
        departureLabel.font = UIFont.app_font(style: .title1, weight: UIFont.Weight.heavy)

        departureTextField.attributedPlaceholder = NSAttributedString(string: "Date", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 0.9, alpha: 0.9)])
        
        returnLabel.textColor = .white
        returnLabel.font = UIFont.app_font(style: .title1, weight: UIFont.Weight.heavy)

        returnTextField.attributedPlaceholder = NSAttributedString(string: "Date", attributes: [NSAttributedStringKey.foregroundColor: UIColor(white: 0.9, alpha: 0.9)])
    }
    
    fileprivate func style(_ textField: UITextField) {
        textField.font = UIFont.app_font(style: .title2, weight: UIFont.Weight.black)
        textField.textColor = UIColor.app_purple
        textField.backgroundColor = .clear
        textField.borderStyle = .none
    }
    
    fileprivate func updateUI() {
        destinationTextField.text = country?.displayName
        if let departureDate = self.departureDate {
            departureTextField.text = AddTripViewController.dateFormatter.string(from: departureDate)
        }
        if let returnDate = self.returnDate {
            returnTextField.text = AddTripViewController.dateFormatter.string(from: returnDate)
        }
        saveBarButtonItem.isEnabled = trip != nil
    }
    
    @IBAction fileprivate func didPressDestination(_ sender: UIButton) {
        let countryPickerViewController = CountryPickerViewController(delegate: self)
        let navigationController = UINavigationController(rootViewController: countryPickerViewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        present(navigationController, animated: true)
    }
    
    @IBAction fileprivate func didPressDeparture(_ sender: UIButton) {
        dateSelectionState = .departureDate
        let datePickerViewController = DatePickerViewController(delegate: self, minDate: Date())
        datePickerViewController.modalPresentationStyle = .overCurrentContext
        datePickerViewController.modalTransitionStyle = .crossDissolve
        present(datePickerViewController, animated: true)
    }
    
    @IBAction fileprivate func didPressReturn(_ sender: UIButton) {
        guard let departureDate = self.departureDate else {
            returnTextField.shakeNo()
            return
        }
        dateSelectionState = .returnDate
        let datePickerViewController = DatePickerViewController(delegate: self, minDate: departureDate)
        datePickerViewController.modalPresentationStyle = .overCurrentContext
        datePickerViewController.modalTransitionStyle = .crossDissolve
        present(datePickerViewController, animated: true)
    }
    
    @objc
    fileprivate func didPressSave(_ sender: UIBarButtonItem) {
        guard let trip = self.trip else { return }
        delegate?.addTripViewController(self, didFinishWith: trip)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        dismiss(animated: true)
    }
    
    @objc
    fileprivate func didPressCancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension AddTripViewController: DatePickerViewControllerDelegate {
    @objc func datePickerViewController(_ viewController: DatePickerViewController, didFinishWith date: Date) {
        switch dateSelectionState {
        case .departureDate:
            departureDate = date
        case .returnDate:
            returnDate = date
        }
        updateUI()
    }
}

extension AddTripViewController: CountryPickerViewControllerDelegate {
    func countryPickerViewController(_ viewController: CountryPickerViewController, didFinishWith country: Country) {
        self.country = country
        updateUI()
    }
}
