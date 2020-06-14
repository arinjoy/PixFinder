//
//  DetailsTextualInfoView.swift
//  PixFinder
//
//  Created by Arinjoy Biswas on 15/6/20.
//  Copyright © 2020 Arinjoy Biswas. All rights reserved.
//

import SwiftUI
import Combine

extension PhotoViewModel {
    var viewsCountText: String {
        self.views + StringKeys.PixFinder.viewsCountSuffix.localized()
    }

    var likesCountText: String {
        self.likes + StringKeys.PixFinder.likesCountSuffix.localized()
    }
    
    var commentsCountText: String {
        self.comments + StringKeys.PixFinder.commentsCountSuffix.localized()
    }
    
    var favouritesCountText: String {
        self.favourites + StringKeys.PixFinder.favouritesCountSuffix.localized()
    }
    
    var downloadsCountText: String {
        self.downloads + StringKeys.PixFinder.downloadsCountSuffix.localized()
    }
}

struct DetailsTextualInfoView: View {
    
    @State var safariLinkPage: LinkPage?

    private let viewModel: PhotoViewModel

    init(_ viewModel: PhotoViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            
            Text(StringKeys.PixFinder.userNamePrefix.localized() + viewModel.postedByUser.name)
                   .lineLimit(1)
                   .font(Font(Theme.headingFont))
            
            Text(StringKeys.PixFinder.tagsPrefix.localized() + viewModel.tags)
                   .lineLimit(2)
                   .font(Font(Theme.titleFont))
               
            HStack(spacing: 12) {
                Image("eye")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(width: 36, height: 36)
                Text(viewModel.viewsCountText)
                    .font(Font(Theme.bodyFont))
            }
            .accessibilityElement()
            .accessibility(label: Text(viewModel.viewsCountText))
               
            HStack(spacing: 24) {
                HStack(spacing: 12) {
                   Image("like-up")
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(width: 32, height: 32)
                   Text(viewModel.likesCountText)
                       .font(Font(Theme.bodyFont))
                }
                .accessibilityElement()
                .accessibility(label: Text(viewModel.likesCountText))
                   
               HStack(spacing: 12) {
                   Image("speech-bubble")
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(width: 28)
                   Text(viewModel.commentsCountText)
                       .font(Font(Theme.bodyFont))
                }
                .accessibilityElement()
                .accessibility(label: Text(viewModel.commentsCountText))
            }
               
            HStack(spacing: 24) {
                HStack(spacing: 12) {
                    Image("heart-love")
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(width: 30, height: 30)
                    Text(viewModel.favouritesCountText)
                       .font(Font(Theme.bodyFont))
                }
                .accessibilityElement()
                .accessibility(label: Text(viewModel.favouritesCountText))
                
                HStack(spacing: 12) {
                   Image("download")
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                       .frame(width: 30, height: 30)
                   Text(viewModel.downloadsCountText)
                       .font(Font(Theme.bodyFont))
                }
                .accessibilityElement()
                .accessibility(label: Text(viewModel.downloadsCountText))
            }
            
            Button(action: {
                self.safariLinkPage = LinkPage(url: self.viewModel.pageUrl)
            }) {
                Text(StringKeys.PixFinder.gotoWebActionTitle.localized())
                    .font(Font(Theme.headingFont))
                    .foregroundColor(Color(Theme.tintColor))
                    .padding([.top, .bottom], 5)
                    .padding([.leading, .trailing], 10)
                    .background(Color(Theme.tertiaryBackgroundColor))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(Theme.tertiaryBackgroundColor),
                                    lineWidth: 1)
                     )
                    .shadow(color: Color(Theme.tertiaryBackgroundColor),
                                    radius: 8, x: 0, y: 0)
            }
            .sheet(item: $safariLinkPage) { linkPage in
                SafariView(linkPage: linkPage)
            }
            
            Spacer()
        }
        .foregroundColor(Color(Theme.primaryTextColor))
        .padding(20)
    }
}

// MARK: - Xcode Previews

#if DEBUG
struct DetailsTextualInfoView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DetailsTextualInfoView(PhotoDetailsView_Preview_Helpers.photoViewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
                .previewDisplayName("iPhone SE")

           DetailsTextualInfoView(PhotoDetailsView_Preview_Helpers.photoViewModel)
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone 11 Pro Max")
        }
    }
}
#endif
