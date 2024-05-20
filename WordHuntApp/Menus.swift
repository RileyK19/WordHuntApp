//
//  Menus.swift
//  WordHuntApp
//
//  Created by Riley Koo on 5/21/24.
//

import SwiftUI

struct mainView: View {
    @State var startToggle = false
    @State var score = 0
    
    @State var grid: grid = WordHuntApp.grid()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = timeLimit
    
    @State private var isActive = true
    
    @State var endScreen = false
    
    @State var scoresToggle: Bool = false
    
    var body: some View {
        VStack{
            if startToggle {
                Text("Time: \(timeRemaining) s")
                    .onChange(of: startToggle) {
                        if startToggle == true {
                            isActive = true
                        } else {
                            isActive = false
                        }
                    }
                    .onReceive(timer) { time in
                        guard isActive else { return }

                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        }
                    }
                    .onChange(of: timeRemaining) {
                        if timeRemaining == 0 && startToggle {
                            self.startToggle.toggle()
                            
                            timeRemaining = timeLimit
                            
                            endScreen = true
                        }
                    }
                gridView(grid: $grid, score: $score)
            } else if endScreen {
                Text("Score: \(score)")
                scoreView(score: Score(grid, userScore: score))
                Spacer()
                    .frame(height: 20)
                Button {
                    ScoreDisplay.addScore(grid, self.score)
                    
                    grid = WordHuntApp.grid()
                    
                    endScreen = false
                    
                    score = 0
                } label: {
                    Text("Continue")
                }
            } else if scoresToggle {
                VStack {
                    ScoreDisplay.body
                    Button {
                        scoresToggle = false
                    } label: {
                        Text("Close")
                    }
                }
            } else {
                Spacer()
                Text("Word Hunt")
                    .font(.title)
                Spacer()
                Button {
                    scoresToggle = true
                } label: {
                    Text("Display Scores")
                }
                Spacer()
                Button {
                    self.startToggle.toggle()
                } label: {
                    Text("Start")
                }
                Spacer()
            }
        }
    }
}
