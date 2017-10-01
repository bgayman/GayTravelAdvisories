//
//  TravelAdvisory.swift
//  Gay Travel Advisories
//
//  Created by Brad G. on 9/27/17.
//  Copyright © 2017 Brad G. All rights reserved.
//

import Foundation

// MARK: - TravelAdvisory
struct TravelAdvisory {
    
    let id: Int
    let area: String
    let name: String
    let iso: String
    let subname: String?
    let legalCode: LegalCode
    let prisonTerm: PrisonTerm
    let fine: Fine
    let penalty: Penalty
    let shariaLaw: ShariaLaw?
    let propagandaLaw: PropagandaLaw
    
    enum Keys: String {
        case id
        case area
        case name = "region_name"
        case iso = "iso_2"
        case subname = "region_sub"
    }
    
}

extension TravelAdvisory {
    
    init?(dictionary: JSONDictionary) {
        guard let id = dictionary[Keys.id.rawValue] as? Int,
              let area = dictionary[Keys.area.rawValue] as? String,
              let name = dictionary[Keys.name.rawValue] as? String,
              let iso = dictionary[Keys.iso.rawValue] as? String else { return nil }
        
        self.id = id
        self.area = area
        self.name = name
        self.iso = iso
        self.subname = dictionary[Keys.subname.rawValue] as? String
        self.legalCode = LegalCode(dictionary: dictionary)
        self.prisonTerm = PrisonTerm(dictionary: dictionary)
        self.fine = Fine(dictionary: dictionary)
        self.penalty = Penalty(dictionary: dictionary)
        self.shariaLaw = ShariaLaw(dictionary: dictionary)
        self.propagandaLaw = PropagandaLaw(dictionary: dictionary)
    }
    
    init(data: Data) throws {
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        guard let dictionary = object as? JSONDictionary,
              let travelAdvisory = TravelAdvisory(dictionary: dictionary) else {
            throw WebserviceError.parseError
        }
        
        self = travelAdvisory
    }
    
}

extension TravelAdvisory {
    
    // MARK: - LegalCode
    struct LegalCode {
        
        let title: String?
        let titleCitation: String?
        let titleCitation2: String?
        let body: String?
        let bodyCitation: String?
        let bodyCitation2: String?
        let bodyCitation3: String?
        let bodyCitation4: String?
        let ilgaComments: String?
        let ilgaCitation: String?
        let ilgaCitation2: String?
        let ilgaCitation3: String?
        let ilgaCitation4: String?
        let ilgaCitation5: String?
        let ilgaCitation6: String?
        let scruffComments: String?
        let isExplicitlySameSexActs: Bool?
        let isExplicitlyActsAgainstNature: Bool?
        let isAnalSexDifferentFromOtherActs: Bool?
        let isHIVAggravtingFactor: Bool?
        let isAgeOfConsentForHomosexualActsOver18: Bool?
        let isExistingLawsUsedToTargetGays: Bool?
        let isLawSubregionalVarienceOrContradiction: Bool?
        let subregionalVarienceNotes: String?
        let isLawNotSpecificallyHomophobic: Bool?
        let isLawStatusUnclear: Bool?
        let lawStatusUnclearNotes: String?
        let isPersectionNonStateAgents: Bool?
        let isCriminalizationUnderConsideration: Bool?
        let isRecentlyDecriminalized: Bool?
        
        var sameSexActsString: String? {
            return isExplicitlySameSexActs == true ? "Legal code explicitly mentioned same sex acts" : nil
        }
        
        var againstNatureString: String? {
            return isExplicitlyActsAgainstNature == true ? "Legal code explicitly mentioned acts against nature." : nil
        }
        
        var analSexString: String? {
            return isAnalSexDifferentFromOtherActs == true ? "Legal code treats anal sex different from other acts." : nil
        }
        
        var hivAggravatingString: String? {
            return isHIVAggravtingFactor == true ? "Legal code treats HIV status as aggravating factor." : nil
        }
        
        var ageOfConsentString: String? {
            return isAgeOfConsentForHomosexualActsOver18 == true ? "Legal code sets age of consent for Homosexual acts over 18." : nil
        }
        
        var existingLawString: String? {
            return isExistingLawsUsedToTargetGays == true ? "Existing legal code is used to target gays." : nil
        }
        
        var subregionalString: String? {
            return isLawSubregionalVarienceOrContradiction == true ? "Law has subregional varience and/or contradictions." : nil
        }
        
        var specificallyHomophobicString: String? {
            return isLawNotSpecificallyHomophobic == true ? "Law is not specifically homophobic." : nil
        }
        
        var lawStatusString: String? {
            return isLawStatusUnclear == true ? "Law's status is unclear." : nil
        }
        
        var criminalizationUnderconsiderationString: String? {
            return isCriminalizationUnderConsideration == true ? "Criminalization is under consideration." : nil
        }
        
        var decriminalizedString: String? {
            return isRecentlyDecriminalized == true ? "Recently decriminalized." : nil
        }
        
        enum Keys: String {
            case title = "legal_code_title"
            case titleCitation = "legal_code_title_citation_1"
            case titleCitation2 = "legal_code_title_citation_2"
            case body = "legal_code_body"
            case bodyCitation = "legal_code_body_citation_1"
            case bodyCitation2 = "legal_code_body_citation_2"
            case bodyCitation3 = "legal_code_body_citation_3"
            case bodyCitation4 = "legal_code_body_citation_4"
            case ilgaComments = "legal_code_ilga_comments"
            case ilgaCitation = "legal_code_ilga_comments_citation_1"
            case ilgaCitation2 = "legal_code_ilga_comments_citation_2"
            case ilgaCitation3 = "legal_code_ilga_comments_citation_3"
            case ilgaCitation4 = "legal_code_ilga_comments_citation_4"
            case ilgaCitation5 = "legal_code_ilga_comments_citation_5"
            case ilgaCitation6 = "legal_code_ilga_comments_citation_6"
            case scruffComments = "legal_code_scruff_comments"
            case isExplicitlySameSexActs = "legal_code_explicitly_references_same_sex_acts"
            case isExplicitlyActsAgainstNature = "legal_code_explicitly_references_acts_against_nature"
            case isAnalSexDifferentFromOtherActs = "legal_code_differentiates_anal_sex_from_other_acts"
            case isHIVAggravtingFactor = "legal_code_indicates_hiv_as_aggravating_factor"
            case isAgeOfConsentForHomosexualActsOver18 = "legal_code_indicates_age_of_consent_homosexual_acts_over_18"
            case isExistingLawsUsedToTargetGays = "existing_laws_used_to_target_gays_but_not_anti_gay"
            case isLawSubregionalVarienceOrContradiction = "laws_subregional_variance_or_contradiction"
            case subregionalVarienceNotes = "laws_subregional_variance_or_contradiction_notes"
            case isLawNotSpecificallyHomophobic = "laws_not_specifically_homophobic"
            case isLawStatusUnclear = "laws_status_unclear"
            case lawStatusUnclearNotes = "laws_status_unclear_notes"
            case isPersectionNonStateAgents = "persecution_non_state_agents"
            case isCriminalizationUnderConsideration = "criminalization_under_consideration"
            case isRecentlyDecriminalized = "recently_decriminalized"
        }
        
        init(dictionary: JSONDictionary) {
            self.title = dictionary[Keys.title.rawValue] as? String
            self.body = dictionary[Keys.body.rawValue] as? String
            self.titleCitation = dictionary[Keys.titleCitation.rawValue] as? String
            self.titleCitation2 = dictionary[Keys.titleCitation2.rawValue] as? String
            self.bodyCitation = dictionary[Keys.bodyCitation.rawValue] as? String
            self.bodyCitation2 = dictionary[Keys.bodyCitation2.rawValue] as? String
            self.bodyCitation3 = dictionary[Keys.bodyCitation3.rawValue] as? String
            self.bodyCitation4 = dictionary[Keys.bodyCitation4.rawValue] as? String
            self.ilgaComments = dictionary[Keys.ilgaComments.rawValue] as? String
            self.ilgaCitation = dictionary[Keys.ilgaCitation.rawValue] as? String
            self.ilgaCitation2 = dictionary[Keys.ilgaCitation2.rawValue] as? String
            self.ilgaCitation3 = dictionary[Keys.ilgaCitation3.rawValue] as? String
            self.ilgaCitation4 = dictionary[Keys.ilgaCitation4.rawValue] as? String
            self.ilgaCitation5 = dictionary[Keys.ilgaCitation5.rawValue] as? String
            self.ilgaCitation6 = dictionary[Keys.ilgaCitation6.rawValue] as? String
            self.scruffComments = dictionary[Keys.scruffComments.rawValue] as? String
            self.isExplicitlySameSexActs = dictionary[Keys.isExplicitlySameSexActs.rawValue] as? Bool
            self.isExplicitlyActsAgainstNature = dictionary[Keys.isExplicitlyActsAgainstNature.rawValue] as? Bool
            self.isAnalSexDifferentFromOtherActs = dictionary[Keys.isAnalSexDifferentFromOtherActs.rawValue] as? Bool
            self.isHIVAggravtingFactor = dictionary[Keys.isHIVAggravtingFactor.rawValue] as? Bool
            self.isAgeOfConsentForHomosexualActsOver18 = dictionary[Keys.isAgeOfConsentForHomosexualActsOver18.rawValue] as? Bool
            self.isExistingLawsUsedToTargetGays = dictionary[Keys.isExistingLawsUsedToTargetGays.rawValue] as? Bool
            self.isLawSubregionalVarienceOrContradiction = dictionary[Keys.isLawSubregionalVarienceOrContradiction.rawValue] as? Bool
            self.subregionalVarienceNotes = dictionary[Keys.subregionalVarienceNotes.rawValue] as? String
            self.isLawNotSpecificallyHomophobic = dictionary[Keys.isLawNotSpecificallyHomophobic.rawValue] as? Bool
            self.isLawStatusUnclear = dictionary[Keys.isLawStatusUnclear.rawValue] as? Bool
            self.lawStatusUnclearNotes = dictionary[Keys.lawStatusUnclearNotes.rawValue] as? String
            self.isPersectionNonStateAgents = dictionary[Keys.isPersectionNonStateAgents.rawValue] as? Bool
            self.isCriminalizationUnderConsideration = dictionary[Keys.isCriminalizationUnderConsideration.rawValue] as? Bool
            self.isRecentlyDecriminalized = dictionary[Keys.isRecentlyDecriminalized.rawValue] as? Bool
        }
        
    }
}

extension TravelAdvisory {
    
    // MARK: - PrisonTerm
    struct PrisonTerm {
        
        let minLength: Double?
        let maxLength: Double?
        let notes: String?
        let isNotSpecified: Bool?
        let isYears: Bool?
        let isLife: Bool?
        let isMandatory: Bool?
        
        var lengthString: String? {
            let min = minLength == nil ? nil : "\(minLength!)"
            let max = maxLength == nil ? nil : "\(maxLength!)"
            let years = isYears == true ? "years" : nil
            var lengthString = [min, max].flatMap { $0 }.joined(separator: "-")
            lengthString = [lengthString, years].flatMap { $0 }.joined(separator: " ")
            return lengthString
        }
        
        var mandatoryString: String? {
            return isMandatory == true ? "Prison term is mandatory." : nil
        }
        
        var specifiedString: String? {
            return isNotSpecified == true ? "Prison term is not specified." : nil
        }
        
        var lifeString: String? {
            return isLife == true ? "Prison term is for life." : nil
        }
        
        enum Keys: String {
            case minLength = "prison_term_min_length"
            case maxLength = "prison_term_max_length"
            case notes = "prison_term_notes"
            case isNotSpecified = "prison_term_not_specified"
            case isYears = "prison_term_years"
            case isLife = "prison_term_life"
            case isMandatory = "prison_term_mandatory"
        }
        
        init(dictionary: JSONDictionary) {
            self.minLength = dictionary[Keys.minLength.rawValue] as? Double
            self.maxLength = dictionary[Keys.maxLength.rawValue] as? Double
            self.notes = dictionary[Keys.notes.rawValue] as? String
            self.isNotSpecified = dictionary[Keys.isNotSpecified.rawValue] as? Bool
            self.isYears = dictionary[Keys.isYears.rawValue] as? Bool
            self.isLife = dictionary[Keys.isLife.rawValue] as? Bool
            self.isMandatory = dictionary[Keys.isMandatory.rawValue] as? Bool
        }
        
    }
}

extension TravelAdvisory {
    
    // MARK: - Fine
    struct Fine {
        
        let minAmount: Int?
        let maxAmount: Int?
        let currency: String?
        let notes: String?
        let isNotSpecified: Bool?
        let isAmount: Bool?
        let isMandatory: Bool?
        
        var amountString: String? {
            let min = minAmount == nil ? nil : "\(minAmount!)"
            let max = maxAmount == nil ? nil : "\(maxAmount!)"
            let curr = currency == nil ? nil : currency!
            var lengthString = [min, max].flatMap { $0 }.joined(separator: "-")
            lengthString = [lengthString, curr].flatMap { $0 }.joined(separator: " ")
            return lengthString
        }
        
        var mandatoryString: String? {
            return isMandatory == true ? "Fine is mandatory." : nil
        }
        
        var specifiedString: String? {
            return isNotSpecified == true ? "Fine is not specified." : nil
        }
        
        enum Keys: String {
            case minAmount = "fine_min_amount"
            case maxAmount = "fine_max_amount"
            case currency = "fine_currency"
            case notes = "fine_notes"
            case isNotSpecified = "fine_not_specified"
            case isAmount = "fine_amount"
            case isMandatory = "fine_mandatory"
        }
        
        init(dictionary: JSONDictionary) {
            self.minAmount = dictionary[Keys.minAmount.rawValue] as? Int
            self.maxAmount = dictionary[Keys.maxAmount.rawValue] as? Int
            self.currency = dictionary[Keys.currency.rawValue] as? String
            self.notes = dictionary[Keys.notes.rawValue] as? String
            self.isNotSpecified = dictionary[Keys.isNotSpecified.rawValue] as? Bool
            self.isAmount = dictionary[Keys.isAmount.rawValue] as? Bool
            self.isMandatory = dictionary[Keys.isMandatory.rawValue] as? Bool
        }
    }
}

extension TravelAdvisory {
    
    // MARK: - Penalty
    struct Penalty {
        
        let isDeath: Bool?
        let deathNotes: String?
        let isCorporalPunishment: Bool?
        let corporalPunishmentNotes: String?
        let isHardLabor: Bool?
        let hardLaborNotes: String?
        let isBanishment: Bool?
        
        var deathString: String? {
            return isDeath == true ? "Penalty is death." : nil
        }
        
        var corporalString: String? {
            return isCorporalPunishment == true ? "Penalty is corporal punishment." : nil
        }
        
        var hardLaborString: String? {
            return isHardLabor == true ? "Penalty is hard labor." : nil
        }
        
        var banishmentString: String? {
            return isBanishment == true ? "Penalty is banishment." : nil
        }
        
        enum Keys: String {
            case isDeath = "penalty_death"
            case deathNotes = "penalty_death_notes"
            case isCorporalPunishment = "penalty_corporal_punishment"
            case corporalPunishmentNotes = "penalty_corporal_punishment_notes"
            case isHardLabor = "penalty_hard_labor"
            case hardLaborNotes = "penalty_hard_labor_notes"
            case isBanishment = "penalty_banishment"
        }
        
        init(dictionary: JSONDictionary) {
            self.isDeath = dictionary[Keys.isDeath.rawValue] as? Bool
            self.deathNotes = dictionary[Keys.deathNotes.rawValue] as? String
            self.isCorporalPunishment = dictionary[Keys.isCorporalPunishment.rawValue] as? Bool
            self.corporalPunishmentNotes = dictionary[Keys.corporalPunishmentNotes.rawValue] as? String
            self.isHardLabor = dictionary[Keys.isHardLabor.rawValue] as? Bool
            self.hardLaborNotes = dictionary[Keys.hardLaborNotes.rawValue] as? String
            self.isBanishment = dictionary[Keys.isBanishment.rawValue] as? Bool
        }
        
    }
}

extension TravelAdvisory {
    
    // MARK: - ShariaLaw
    struct ShariaLaw {
        
        let isShariaLaw: Bool
        let shariaLawNotes: String?
        
        enum Keys: String {
            case isShariaLaw = "islamic_sharia_law"
            case shariaLawNotes = "islamic_sharia_law_notes"
        }
        
        var shariaLawString: String? {
            return isShariaLaw == true ? "Law is part of Islamic Sharia Law." : nil
        }
        
        init?(dictionary: JSONDictionary) {
            guard let isShariaLaw = dictionary[Keys.isShariaLaw.rawValue] as? Bool else { return nil }
            self.isShariaLaw = isShariaLaw
            self.shariaLawNotes = dictionary[Keys.shariaLawNotes.rawValue] as? String
        }
    }
}

extension TravelAdvisory {
    
    // MARK: - PropagandaLaw
    struct PropagandaLaw {
        
        let isPropagandaLawUnderConsideration: Bool?
        let title: String?
        let titleCitation: String?
        let body: String?
        let bodyCitation: String?
        let ilgaComments: String?
        
        enum Keys: String {
            case isPropagandaLawUnderConsideration = "propaganda_law_under_consideration"
            case title = "propaganda_law_title"
            case titleCitation = "propaganda_law_title_citation_1"
            case body = "propaganda_law_body"
            case bodyCitation = "propaganda_law_body_citation_1"
            case ilgaComments = "propaganda_law_ilga_comments"
        }
        
        init(dictionary: JSONDictionary) {
            self.title = dictionary[Keys.title.rawValue] as? String
            self.isPropagandaLawUnderConsideration = dictionary[Keys.isPropagandaLawUnderConsideration.rawValue] as? Bool
            self.titleCitation = dictionary[Keys.titleCitation.rawValue] as? String
            self.body = dictionary[Keys.body.rawValue] as? String
            self.bodyCitation = dictionary[Keys.bodyCitation.rawValue] as? String
            self.ilgaComments = dictionary[Keys.ilgaComments.rawValue] as? String
        }
    }
    
}

