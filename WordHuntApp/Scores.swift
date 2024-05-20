//
//  Scores.swift
//  WordHuntApp
//
//  Created by Riley Koo on 5/22/24.
//

import SwiftUI

struct ScoreDisplay: Codable {
    @State static var highScore: Score = Score()
    @State static var scoreMem: [Score] = []
    @State static var averageScore: Score = Score()
    static func addScore(_ grid: grid, _ userScore: Int) {
        let tmp = Score(grid, userScore: userScore)
        scoreMem.append(tmp)
        highScore = highScore > tmp ? highScore : tmp
    }
    static func calcAvg() {
        if scoreMem.count == 0 {
            averageScore = Score()
            return
        }
        let tmp = Score()
        for x in 0..<scoreMem.count {
            tmp.maxScore += scoreMem[x].maxScore
            tmp.userScore += scoreMem[x].userScore
            tmp.percentage += scoreMem[x].percentage
        }
        tmp.maxScore /= scoreMem.count
        tmp.userScore /= scoreMem.count
        tmp.percentage /= Float(scoreMem.count)
        
        averageScore = tmp
    }
    static var body: some View {
        VStack {
            Text("High score:")
            scoreView(score: highScore)
            Spacer()
                .frame(height: 20)
            Text("Average score:")
            scoreView(score: averageScore)
            Spacer()
                .frame(height: 20)
            ScrollView {
                ForEach(Array(0..<scoreMem.count), id:\.self) { x in
                    scoreView(score: scoreMem[x])
                }
            }
        }
        .onAppear {
            calcAvg()
        }
    }
}
struct scoreView: View {
    var score: Score
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 15)
            HStack {
                Spacer()
                    .frame(width: 15)
                Text("Score: \(score.userScore)")
                Spacer()
                Text("Max Score: \(score.maxScore)")
                Spacer()
                    .frame(width: 15)
            }
            Spacer()
                .frame(height: 20)
            HStack {
                Spacer()
                    .frame(width: 15)
                Text("Percentage: \(score.percentage)")
                Spacer()
                    .frame(width: 15)
            }
            Spacer()
                .frame(height: 15)
        }
        .background(
            RoundedRectangle(cornerRadius: 35)
                .foregroundStyle(.gray)
        )
        .padding()
    }
}

class Score: Codable {
    var maxScore: Int
    var userScore: Int
    var percentage: Float
    init() {
        self.maxScore = 0; self.userScore = 0; self.percentage = 0
    }
    init(_ grid: grid, userScore: Int) {
        self.maxScore = 0; self.userScore = 0; self.percentage = 0
        
        maxScore = scoreCalculations.maxScore(grid)
        self.userScore = userScore
        percentage = maxScore == 0 ? 0 : Float(self.userScore) / Float(maxScore)
    }
    static func > (lhs: Score, rhs: Score) -> Bool {
        return lhs.userScore > rhs.userScore
    }
    static func < (lhs: Score, rhs: Score) -> Bool {
        return lhs.userScore < rhs.userScore
    }
}

class scoreCalculations {
    static func maxScore(_ grid: grid) -> Int {
        var ret = 0
        let visit = [
            false, false, false, false, false,
            false, false, false, false, false,
            false, false, false, false, false,
            false, false, false, false, false,
            false, false, false, false, false
        ]
        for x in 0..<gridSize {
            for y in 0..<gridSize {
                let tmpS = dfs(grid, x: x, y: y, visit)
                ret += calcMaxScoreFromString(tmpS)
            }
        }
        return ret
    }
    
    private static func dfs(_ grid: grid, x: Int, y: Int, _ visit: [Bool]) -> String {
        //incorrect ...
        
        var visitted = visit
        visitted[x + gridSize*y] = true
        
        if !visitted.contains(false) {
            return "\(grid.boxes[x + gridSize*y].letter)"
        }
        
        var ret = ""
        if x + 1 < gridSize && !visitted[x + 1 + gridSize*y] {
            visitted[x + 1 + gridSize*y] = true
            ret += dfs(grid, x: x + 1, y: y, visitted)
            visitted[x + 1 + gridSize*y] = false
        }
        
        if x - 1 > -1 && !visitted[x - 1 + gridSize*y] {
            visitted[x - 1 + gridSize*y] = true
            ret += dfs(grid, x: x - 1, y: y, visitted)
            visitted[x - 1 + gridSize*y] = false
        }
        
        if y + 1 < gridSize && !visitted[x + gridSize*y + gridSize] {
            visitted[x + gridSize*y + gridSize] = true
            ret += dfs(grid, x: x, y: y + 1, visitted)
            visitted[x + gridSize*y + gridSize] = false
        }
        
        if y - 1 > -1 && !visitted[x + gridSize*y - gridSize] {
            visitted[x + gridSize*y - gridSize] = true
            ret += dfs(grid, x: x, y: y - 1, visitted)
            visitted[x + gridSize*y - gridSize] = false
        }
        
        return ret
    }
    
    private static func calcMaxScoreFromString(_ s: String) -> Int {
        if s.count < 4 {
            return isReal(word: s) ? calcScore(s.count) : 0
        }
        var ret = 0
        if isReal(word: s) {
            ret += calcScore(s.count)
        }
        ret += calcMaxScoreFromString(exclLast(s)) + calcMaxScoreFromString(exclFirst(s))
        return ret
    }
    
    private static func exclLast(_ s: String) -> String {
        var tmp = s
        tmp.remove(at: tmp.lastIndex(where: { _ in
            return true
        })!)
        return tmp
    }
    private static  func exclFirst(_ s: String) -> String {
        var tmp = s
        tmp.remove(at: tmp.firstIndex(where: { _ in
            return true
        })!)
        return tmp
    }
}
