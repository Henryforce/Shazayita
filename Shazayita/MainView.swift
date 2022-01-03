//
//  MainView.swift
//  Shazayita
//
//  Created by Henry Javier Serrano Echeverria on 2/1/22.
//

import SwiftUI

@MainActor
struct MainView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            
            buildHeader()

            ImageButton(systemName: viewModel.isRecognizingSong ? "waveform.circle.fill" : "waveform.circle")
                .onTapGesture {
                    viewModel.startStopRecognition()
                }
            
        }.padding()
    }
    
    func buildHeader() -> some View {
        VStack {
            if let match = viewModel.latestMatch {
                
                AsyncImage(url: match.artworkURL) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200, alignment: .center)
                .cornerRadius(16)
                .padding()
                
                Text(match.title)
                    .font(.title)
                    .padding()
                
                if let subtitle = match.subtitle {
                    Text(subtitle)
                        .font(.title3)
                        .padding()
                }
                
                Text(match.artist)
                    .font(.title2)
                    .padding()
            } else {
                Text("No match yet...")
                    .font(.title)
                    .padding()
            }
        }
    }
}

struct ImageButton: View {
    
    let systemName: String
    var backgroundColor = Color.blue
    var titleColor = Color.yellow
    
    var body: some View {
        Image(systemName: systemName)
            .font(.title)
            .foregroundColor(titleColor)
            .background(backgroundColor)
            .cornerRadius(16)
    }
    
}
