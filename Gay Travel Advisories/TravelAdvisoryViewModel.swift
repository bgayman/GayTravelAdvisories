//
//  TravelAdvisoryViewModel.swift
//  Gay Travel Advisories
//
//  Created by B Gay on 9/29/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import UIKit

struct TravelAdvisoryViewModel {
    
    // MARK: - Types
    enum TravelAdvisorySections: Hashable, Equatable {
        case legalCode(text: NSAttributedString)
        case prisonTerm(text: NSAttributedString)
        case fine(text: NSAttributedString)
        case penalty(text: NSAttributedString)
        case shariaLaw(text: NSAttributedString)
        case propagandaLaw(text: NSAttributedString)
        
        var sectionTitle: String {
            switch self {
            case .legalCode:
                return "Legal Code"
            case .prisonTerm:
                return "Prison Term"
            case .fine:
                return "Fine"
            case .penalty:
                return "Penalty"
            case .shariaLaw:
                return "Sharia Law"
            case .propagandaLaw:
                return "Propaganda Law"
            }
        }
        
        var hashValue: Int {
            switch self {
            case .legalCode:
                return 0
            case .prisonTerm:
                return 1
            case .fine:
                return 2
            case .penalty:
                return 3
            case .shariaLaw:
                return 4
            case .propagandaLaw:
                return 5
            }
        }
        
        static func == (lhs: TravelAdvisoryViewModel.TravelAdvisorySections, rhs: TravelAdvisoryViewModel.TravelAdvisorySections) -> Bool {
            switch (lhs, rhs) {
            case let (.legalCode(lhsText), .legalCode(rhsText)):
                return lhsText == rhsText
            case let (.prisonTerm(lhsText), .prisonTerm(rhsText)):
                return lhsText == rhsText
            case let (.fine(lhsText), .fine(rhsText)):
                return lhsText == rhsText
            case let (.penalty(lhsText), .penalty(rhsText)):
                return lhsText == rhsText
            case let (.shariaLaw(lhsText), .shariaLaw(rhsText)):
                return lhsText == rhsText
            case let (.propagandaLaw(lhsText), .propagandaLaw(rhsText)):
                return lhsText == rhsText
            default:
                return false
            }
        }
        
    }
    
    // MARK: - Properties
    let travelAdvisory: TravelAdvisory
    
    private(set) var sections: [TravelAdvisorySections] = []
    
    // MARK: - Lifecycle
    init(travelAdvisory: TravelAdvisory) {
        self.travelAdvisory = travelAdvisory
        var sections = [TravelAdvisorySections]()
        if let attribString = attributedText(for: travelAdvisory.legalCode),
           attribString.string.isEmpty == false {
            sections.append(.legalCode(text: attribString))
        }
        if let attribString = attributedText(for: travelAdvisory.prisonTerm),
            attribString.string.isEmpty == false {
            sections.append(.prisonTerm(text: attribString))
        }
        if let attribString = attributedText(for: travelAdvisory.fine),
            attribString.string.isEmpty == false {
            sections.append(.fine(text: attribString))
        }
        if let attribString = attributedText(for: travelAdvisory.penalty),
            attribString.string.isEmpty == false {
            sections.append(.penalty(text: attribString))
        }
        if let attribString = attributedText(for: travelAdvisory.shariaLaw),
            attribString.string.isEmpty == false {
            sections.append(.shariaLaw(text: attribString))
        }
        if let attribString = attributedText(for: travelAdvisory.propagandaLaw),
            attribString.string.isEmpty == false {
            sections.append(.propagandaLaw(text: attribString))
        }
        self.sections = sections
    }
    
    // MARK: - Helpers
    private func attributedText(for legalCode: TravelAdvisory.LegalCode?) -> NSAttributedString? {
        guard let legalCode = legalCode else { return nil }
        let string = [legalCode.title,
                      legalCode.body,
                      legalCode.ilgaComments,
                      legalCode.scruffComments,
                      legalCode.sameSexActsString,
                      legalCode.againstNatureString,
                      legalCode.analSexString,
                      legalCode.hivAggravatingString,
                      legalCode.ageOfConsentString,
                      legalCode.existingLawString,
                      legalCode.subregionalString,
                      legalCode.specificallyHomophobicString,
                      legalCode.lawStatusString,
                      legalCode.criminalizationUnderconsiderationString,
                      legalCode.decriminalizedString,
                      legalCode.titleCitation,
                      legalCode.titleCitation2,
                      legalCode.bodyCitation,
                      legalCode.bodyCitation2,
                      legalCode.bodyCitation3,
                      legalCode.bodyCitation4,
                      legalCode.ilgaCitation,
                      legalCode.ilgaCitation2,
                      legalCode.ilgaCitation3,
                      legalCode.ilgaCitation4,
                      legalCode.ilgaCitation5,
                      legalCode.ilgaCitation6]
            .flatMap { $0 }
            .filter { $0.isEmpty == false }
            .joined(separator: "\n\n")
        
        let textString = [legalCode.title,
                          legalCode.body,
                          legalCode.ilgaComments,
                          legalCode.scruffComments]
            .flatMap { $0 }
            .filter { $0.isEmpty == false }
            .joined(separator: "\n\n")
        
        let warningText = [legalCode.sameSexActsString,
                           legalCode.againstNatureString,
                           legalCode.analSexString,
                           legalCode.hivAggravatingString,
                           legalCode.ageOfConsentString,
                           legalCode.existingLawString,
                           legalCode.subregionalString,
                           legalCode.specificallyHomophobicString,
                           legalCode.lawStatusString,
                           legalCode.criminalizationUnderconsiderationString,
                           legalCode.decriminalizedString]
            .flatMap { $0 }
            .filter { $0.isEmpty == false }
            .joined(separator: "\n\n")
        
        let citationString = [legalCode.titleCitation,
                              legalCode.titleCitation2,
                              legalCode.bodyCitation,
                              legalCode.bodyCitation2,
                              legalCode.bodyCitation3,
                              legalCode.bodyCitation4,
                              legalCode.ilgaCitation,
                              legalCode.ilgaCitation2,
                              legalCode.ilgaCitation3,
                              legalCode.ilgaCitation4,
                              legalCode.ilgaCitation5,
                              legalCode.ilgaCitation6]
            .flatMap { $0 }
            .filter { $0.isEmpty == false }
            .joined(separator: "\n\n")
        
        let attribString = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.font: UIFont.app_font(style: .body, weight: .medium), NSAttributedStringKey.foregroundColor: UIColor.white])
        
        let textRange = (string as NSString).range(of: textString)
        let warningRange = (string as NSString).range(of: warningText)
        let citationRange = (string as NSString).range(of: citationString)
        
        attribString.addAttributes([NSAttributedStringKey.font: UIFont.app_font(style: .headline, weight: .semibold)], range: textRange)
        attribString.addAttributes([NSAttributedStringKey.font: UIFont.app_font(style: .headline, weight: .semibold), NSAttributedStringKey.foregroundColor: UIColor.app_pink], range: warningRange)
        attribString.addAttributes([NSAttributedStringKey.font: UIFont.app_font(style: .caption1, weight: .light)], range: citationRange)
        
        return attribString
        
    }
    
    private func attributedText(for prisonTerm: TravelAdvisory.PrisonTerm?) -> NSAttributedString? {
        guard let prisonTerm = prisonTerm else { return nil }
        let string = [prisonTerm.lengthString,
                      prisonTerm.notes,
                      prisonTerm.mandatoryString,
                      prisonTerm.lifeString,
                      prisonTerm.specifiedString]
            .flatMap { $0 }
            .filter { $0.isEmpty == false }
            .joined(separator: "\n\n")
        
        let attribString = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.font: UIFont.app_font(style: .body, weight: .medium), NSAttributedStringKey.foregroundColor: UIColor.white])
        return attribString
    }
    
    private func attributedText(for fine: TravelAdvisory.Fine?) -> NSAttributedString? {
        guard let fine = fine else { return nil }
        let string = [fine.amountString,
                      fine.notes,
                      fine.mandatoryString,
                      fine.specifiedString]
            .flatMap { $0 }
            .filter { $0.isEmpty == false }
            .joined(separator: "\n\n")
        
        let attribString = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.font: UIFont.app_font(style: .body, weight: .medium), NSAttributedStringKey.foregroundColor: UIColor.white])
        return attribString
    }
    
    private func attributedText(for penalty: TravelAdvisory.Penalty?) -> NSAttributedString? {
        guard let penalty = penalty else { return nil }
        let string = [penalty.deathString,
                      penalty.deathNotes,
                      penalty.corporalString,
                      penalty.corporalPunishmentNotes,
                      penalty.hardLaborString,
                      penalty.hardLaborNotes,
                      penalty.banishmentString]
            .flatMap { $0 }
            .filter { $0.isEmpty == false }
            .joined(separator: "\n\n")
        
        let attribString = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.font: UIFont.app_font(style: .body, weight: .medium), NSAttributedStringKey.foregroundColor: UIColor.white])
        return attribString
    }
    
    private func attributedText(for shariaLaw: TravelAdvisory.ShariaLaw?) -> NSAttributedString? {
        guard let shariaLaw = shariaLaw else { return nil }
        let string = [shariaLaw.shariaLawString,
                      shariaLaw.shariaLawNotes]
            .flatMap { $0 }
            .filter { $0.isEmpty == false }
            .joined(separator: "\n\n")
        
        let attribString = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.font: UIFont.app_font(style: .body, weight: .medium), NSAttributedStringKey.foregroundColor: UIColor.white])
        return attribString
    }
    
    private func attributedText(for propagandaLaw: TravelAdvisory.PropagandaLaw?) -> NSAttributedString? {
        guard let propagandaLaw = propagandaLaw else { return nil }
        let string = [propagandaLaw.title,
                      propagandaLaw.body,
                      propagandaLaw.ilgaComments,
                      propagandaLaw.titleCitation,
                      propagandaLaw.bodyCitation]
            .flatMap { $0 }
            .filter { $0.isEmpty == false }
            .joined(separator: "\n\n")
        
        let attribString = NSMutableAttributedString(string: string, attributes: [NSAttributedStringKey.font: UIFont.app_font(style: .body, weight: .medium), NSAttributedStringKey.foregroundColor: UIColor.white])
        return attribString
    }
}
