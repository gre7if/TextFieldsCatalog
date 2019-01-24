//
//  MainPresenter.swift
//  TextFieldsCatalog
//
//  Created by Alexander Chausov on 23/01/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

final class MainPresenter: MainModuleOutput {

    // MARK: - MainModuleOutput

    var onFieldOpen: TextFieldTypeClosure?

    // MARK: - Properties

    weak var view: MainViewInput?

}

// MARK: - MainModuleInput

extension MainPresenter: MainModuleInput {
}

// MARK: - MainViewOutput

extension MainPresenter: MainViewOutput {

    func viewLoaded() {
        var models = TextFieldType.allCases.map { MainModuleViewModel.field($0) }
        models.insert(.message(L10n.Main.Main.message), at: 0)
        view?.setupInitialState(with: models, title: L10n.Main.Main.title)
    }

    func openField(with type: TextFieldType) {
        onFieldOpen?(type)
    }

}
