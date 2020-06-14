//
//  SFSafariView.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 14/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import SwiftUI
import SafariServices

struct LinkPage: Identifiable {
    let url: URL
    var id: String { url.absoluteString }
}

struct SafariView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = SFSafariViewController

    var linkPage: LinkPage

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: linkPage.url)
        safariVC.preferredControlTintColor = Theme.tintColor
        return safariVC
    }

    func updateUIViewController(_ safariViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}
