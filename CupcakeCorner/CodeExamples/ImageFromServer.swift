//
//  ImageFromServer.swift
//  CupcakeCorner
//  https://youtu.be/9PWtn1kj9Yo
//  Created by Uri on 7/3/26.
//

import SwiftUI

struct ImageFromServer: View {
    var body: some View {
        asyncImageSwitch
    }
}

#Preview {
    ImageFromServer()
}

extension ImageFromServer {

    private var basicAsyncImage: some View {
        // the higher the scale, the smaller the picture
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png"), scale: 3)
    }

    private var asyncImageWithClosure: some View {
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            Color.red
        }
        .frame(width: 200, height: 200)
    }

    private var asyncImageIfLet: some View {
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                Text("There was an error loading the image.")
            } else {
                ProgressView()
            }
        }
        .frame(width: 200, height: 200)
    }

    private var asyncImageSwitch: some View {
        AsyncImage(url: URL(string: "https://hws.dev/img/logo.png")) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure(let error):
                Text(error.localizedDescription)
            case .empty:
                ProgressView()
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 200, height: 200)
    }
}

/*
 We can't directly apply .resizable or frame(w, h) to AsyncImage -> basicAsync
 We need to apply the modifiers to the final image -> asyncImageWithClosure
 */
