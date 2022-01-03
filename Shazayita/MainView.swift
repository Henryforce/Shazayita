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

            AnimatedImageButton(
                animationAmount: $viewModel.animationScale,
                systemName: viewModel.isRecognizingSong ? "waveform.circle.fill" : "waveform.circle"
            )
                .padding(.bottom, 8)
                .onTapGesture {
                    viewModel.startStopRecognition()
                }
            
            Text(viewModel.isRecognizingSong ? "Listening..." : "Start Listening")
                .font(.callout)
                .fontWeight(.medium)
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
                    .fontWeight(.bold)
                    .padding(.bottom, 0)
                
                if let subtitle = match.subtitle {
                    Text(subtitle)
                        .font(.title3)
                        .fontWeight(.light)
                        .padding(.bottom, 4)
                }
                
                Text(match.artist)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
            }
//            else {
//                Text("No match yet...")
//                    .font(.title)
//                    .padding()
//            }
        }
    }
}
