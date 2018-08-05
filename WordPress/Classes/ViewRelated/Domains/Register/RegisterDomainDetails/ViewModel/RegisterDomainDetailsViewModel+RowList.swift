import Foundation

// MARK: - Row list

extension RegisterDomainDetailsViewModel {

    enum RowType: Equatable {
        case checkMark(Row.CheckMarkRow)
        case inlineEditable(Row.EditableKeyValueRow)
        case addAddressLine(title: String?)
    }

    static var privacyProtectionRows: [RowType] {
        return [
            .checkMark(.init(
                isSelected: true,
                title: Localized.PrivacySection.registerPrivatelyRowText
                )),
            .checkMark(.init(
                isSelected: false,
                title: Localized.PrivacySection.registerPubliclyRowText
                ))
        ]
    }

    static var nonEmptyRule: ValidationRule {
        return ValidationRule(tag: ValidationRuleTag.enableSubmit.rawValue,
                              validationBlock: ValidationBlock.nonEmpty,
                              errorMessage: nil)
    }

    static var contactInformationRows: [RowType] {
        return [
            .inlineEditable(.init(
                key: Localized.ContactInformation.firstName,
                value: nil,
                placeholder: Localized.ContactInformation.firstName,
                editingStyle: .inline,
                validationRules: [nonEmptyRule]
                )),
            .inlineEditable(.init(
                key: Localized.ContactInformation.lastName,
                value: nil,
                placeholder: Localized.ContactInformation.lastName,
                editingStyle: .inline,
                validationRules: [nonEmptyRule]
                )),
            .inlineEditable(.init(
                key: Localized.ContactInformation.organization,
                value: nil,
                placeholder: Localized.ContactInformation.organizationPlaceholder,
                editingStyle: .inline
                )),
            .inlineEditable(.init(
                key: Localized.ContactInformation.email,
                value: nil,
                placeholder: Localized.ContactInformation.email,
                editingStyle: .inline,
                validationRules: [nonEmptyRule,
                                  ValidationRule(tag: ValidationRuleTag.proceedSubmit.rawValue,
                                                 validationBlock: ValidationBlock.email,
                                                 errorMessage: Localized.ContactInformation.emailValidationError)
                ]
                )),
            .inlineEditable(.init(
                key: Localized.ContactInformation.phone,
                value: nil,
                placeholder: Localized.ContactInformation.phone,
                editingStyle: .inline,
                validationRules: [nonEmptyRule,
                                  ValidationRule(tag: ValidationRuleTag.proceedSubmit.rawValue,
                                                 validationBlock: ValidationBlock.phone,
                                                 errorMessage: Localized.ContactInformation.phoneValidationError)]
                )),
            .inlineEditable(.init(
                key: Localized.ContactInformation.country,
                value: nil,
                placeholder: Localized.ContactInformation.countryPlaceholder,
                editingStyle: .multipleChoice,
                validationRules: [nonEmptyRule]
                ))]
    }

    static func addressLine(row: Int, optional: Bool = true) -> RowType {
        return .inlineEditable(.init(
            key: String(format: Localized.Address.addressLine, "\(row + 1)"),
            value: nil,
            placeholder: Localized.Address.addressPlaceholder,
            editingStyle: .inline,
            validationRules: optional ? nil : [nonEmptyRule]
            ))
    }

    static var addressRows: [RowType] {
        return [
            addressLine(row: 0, optional: false),
            .inlineEditable(.init(
                key: Localized.Address.city,
                value: nil,
                placeholder: Localized.Address.city,
                editingStyle: .inline,
                validationRules: [nonEmptyRule]
                )),
            .inlineEditable(.init(
                key: Localized.Address.state,
                value: nil,
                placeholder: Localized.Address.statePlaceHolder,
                editingStyle: .multipleChoice,
                validationRules: [nonEmptyRule]
                )),
            .inlineEditable(.init(
                key: Localized.Address.postalCode,
                value: nil,
                placeholder: Localized.Address.postalCode,
                editingStyle: .inline,
                validationRules: [nonEmptyRule,
                                  ValidationRule(tag: ValidationRuleTag.proceedSubmit.rawValue,
                                                 validationBlock: ValidationBlock.postalCode,
                                                 errorMessage: Localized.Address.postalCodeValidationError)]
                ))
        ]
    }
}
