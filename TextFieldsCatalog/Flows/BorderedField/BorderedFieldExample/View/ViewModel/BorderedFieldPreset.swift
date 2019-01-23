//
//  BorderedFieldPreset.swift
//  TextFieldsCatalog
//
//  Created by Александр Чаусов on 23/01/2019.
//  Copyright © 2019 Александр Чаусов. All rights reserved.
//

import Foundation

enum BorderedFieldPreset: CaseIterable {
    case password
    case email

    var name: String {
        switch self {
        case .password:
            return "Пароль"
        case .email:
            return "Email"
        }
    }

    var description: String {
        switch self {
        case .password:
            return "Типичный кейс для ввода пароля. Здесь должно быть подробное описание"
        case .email:
            return "Типичный кейс для поля ввода email."
        }
    }

    func apply(for textField: BorderedTextField) {
        switch self {
        case .password:
            tuneFieldForPassword(textField)
        case .email:
            tuneFieldForEmail(textField)
        }
    }
}

private extension BorderedFieldPreset {

    func tuneFieldForPassword(_ textField: BorderedTextField) {
        textField.configure(placeholder: "Пароль", maxLength: nil)
        textField.configure(correction: .no, keyboardType: .asciiCapable)
        textField.disablePasteAction()
        textField.setHint("Текст подсказки")
        textField.setReturnKeyType(.next)
        textField.setTextFieldMode(.password)

        let validator = TextFieldValidator(minLength: 8, maxLength: 20, regex: Regex.password)
        validator.shortErrorText = "Пароль слишком короткий"
        textField.validator = validator

        textField.maskFormatter = MaskTextFieldFormatter(mask: FormatterMasks.password)
    }

    func tuneFieldForEmail(_ textField: BorderedTextField) {
        textField.configure(placeholder: "Email", maxLength: nil)
        textField.configure(correction: .no, keyboardType: .emailAddress)
        textField.enablePasteAction()
        textField.setHint(" ")
        textField.setReturnKeyType(.default)
        textField.setTextFieldMode(.plain)

        let validator = TextFieldValidator(minLength: 1, maxLength: nil, regex: Regex.email)
        textField.validator = validator

        textField.maskFormatter = nil
    }

}
