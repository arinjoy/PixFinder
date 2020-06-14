//
//  PhotoDetailsView.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 14/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import SwiftUI
import Combine

struct PhotoDetailsView: View {

    let imageURL: String?
    let title: String?

    var body: some View {
        NavigationView {
            PhotoDetailsContainerView(imageURL: imageURL ?? "")
        }
        .navigationBarTitle(Text(title ?? ""), displayMode: .inline)
    }
}

struct PhotoDetailsContainerView: View {
    
    @ObservedObject var remoteImageURL: RemoteImageURL

    init(imageURL: String) {
        remoteImageURL = RemoteImageURL(imageURL: imageURL)
    }

    var body: some View {
        Image(uiImage: remoteImageURL.data.isEmpty ?
                UIImage(named: "photo-frame")! : UIImage(data: remoteImageURL.data)!)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

class RemoteImageURL: ObservableObject {
    
    var didChange = PassthroughSubject<Data, Never>()
    
    @Published var data = Data() {
        didSet {
            update()
        }
    }
    
    func update() {
        didChange.send(data)
    }
    
    init(imageURL: String) {
        
        guard let url = URL(string: imageURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.data = data
            }
            
        }.resume()
    }
}

// MARK: - PreviewProvider

struct PhotoDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        PhotoDetailsView(
            imageURL: "https://cdn.pixabay.com/photo/2015/12/01/20/28/fall-1072821_960_720.jpg",
            title: "From Preview")
    }
}
