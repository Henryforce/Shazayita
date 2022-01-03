//
//  ViewController.swift
//  Shazayita
//
//  Created by Henry Javier Serrano Echeverria on 2/1/22.
//

import UIKit
import SwiftUI

@MainActor
final class ViewController: UIViewController {

    private lazy var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupMainView()
    }

    private func setupMainView() {
        let mainView = MainView(viewModel: viewModel)
        let controller = UIHostingController(rootView: mainView)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

}
