//
//  ContentView.swift
//  MultiMagic
//
//  Created by Antarcticaman on 25/6/2564 BE.
//

import SwiftUI

enum GameState {
    case play
    case setting
    case result
}

struct ContentView: View {
    
    @State private var numberOfQuestions = 5
    @State private var selectedTableNumber = 1
    @State private var randomMultiplyNumber = Int.random(in: 0...12)
    
    @State private var gameState: GameState = .setting
    @State private var bgColor = [Color.gray, Color.white]
    
    @State private var questionNumber = 0
    @State private var answer = ""
    @State private var showResultLabel = false
    @State private var resultLabel = "Correct!"
    @State private var resultMessage = ""
    @State private var shuffle = Bool.random()
    
    @State private var scores = 0
    var correctAnswer: Int {
        let result = selectedTableNumber * randomMultiplyNumber
        return result
    }
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: bgColor), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            if gameState == .setting {
                VStack(spacing: 40) {
                    VStack(alignment: .leading) {
                        Text("Question Example")
                            .foregroundColor(.white)
                            .font(.subheadline)
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(height: 100)
                                .cornerRadius(20)
                            
                            HStack(spacing: 20) {
                                Text("\(selectedTableNumber)")
                                    .font(.largeTitle)
                                    .fontWeight(.medium)
                                    .foregroundColor(.blue)
                                Text("x")
                                Text("2")
                                Text("=")
                                Text("?? 🤔")
                            }
                            .font(.title)
                        }
                    }
                    
                    Header(title: "Select Table")
                    
                    VStack(spacing: 20) {
                        NumberButtons(from: 1, to: 4, action: selectTable, selectedNumber: selectedTableNumber)
                        NumberButtons(from: 5, to: 8, action: selectTable, selectedNumber: selectedTableNumber)
                        NumberButtons(from: 9, to: 12, action: selectTable,  selectedNumber: selectedTableNumber)
                    }
                    
                    Stepper(value: $numberOfQuestions, in: 5...20, step: 5) {
                        Text("\(numberOfQuestions) Questions" )
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .frame(width: 300, height:50)
                    .background(Color.white)
                    .cornerRadius(20)
                    
                    
                    PlayButton(title: "Start Game", action: playGame, color: .white, backgroundColor: .blue)
                    
                }
                .frame(width: 300, height: 640)
                .transition(.asymmetric(insertion: .slide, removal: .slide))
            }
            
            if gameState == .play {
                VStack(spacing: 30) {
                    
                    Text("Level \(selectedTableNumber)")
                    Spacer()
                    
                    if showResultLabel {
                            Text("\(resultLabel)")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Question #\(questionNumber)")
                        
                        ZStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(height: 100)
                                .cornerRadius(20)
                            if shuffle {
                                HStack(spacing: 20) {
                                    Text("\(selectedTableNumber)")
                                        .font(.largeTitle)
                                        .fontWeight(.medium)
                                        .foregroundColor(.blue)
                                    Text("x")
                                    Text("\(randomMultiplyNumber)")
                                    Text("=")
                                    Text("??")
                                }
                                .font(.title)
                            } else {
                                HStack(spacing: 20) {
                                    Text("\(randomMultiplyNumber)")
                                    Text("x")
                                    Text("\(selectedTableNumber)")
                                        .font(.largeTitle)
                                        .fontWeight(.medium)
                                        .foregroundColor(.blue)
                                    Text("=")
                                    Text("??")
                                }
                                .font(.title)
                            }
                        }
                        
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Answer")
                           
                        ZStack {
                            
                            if !showResultLabel {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white)
                                    .frame(height: 50)
                                
                                TextField("Enter your answer", text: $answer, onCommit: checkAnswer)
                                    .padding()
                                    .keyboardType(.decimalPad)
                                    .multilineTextAlignment(.center)
                            } else {
                                Text("The correct answer is \(correctAnswer)")
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    
                            }
                        }
                        if showResultLabel {
                            PlayButton(title: "Next", action: playGame, color: .blue)
                        } else {
                            PlayButton(title: "Done", action: checkAnswer, color: !answer.isEmpty ? .red : .gray, backgroundColor: answer.isEmpty ? Color.init(hue: 0.4, saturation: 0.0, brightness: 0.37) : Color.white)
                                .disabled(answer.isEmpty)
                        }
                    }
                    Spacer()
                }
                .frame(width: 300, height: 640)
//                .transition(.scale)
            }
            
            if gameState == .result {
                VStack(spacing: 15) {
                    Text("Result")
                        .font(.title)
                        .foregroundColor(.white)
                    Spacer()
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white)
                            .frame(height: 300)
                        VStack(spacing: 30) {
                            
                            Text("\(resultMessage)")
                                .font(.title)
                                .multilineTextAlignment(.center)
                               
                            
                            Text(" \(scores) / \(numberOfQuestions)")
                                .font(.largeTitle)
                        }
                    }
                        
                  
                    Spacer()
                    PlayButton(title: "Next Level", action: playNextLevel, color: .white, backgroundColor: .green)
                    HStack(spacing: 20) {
                        
                        PlayButton(title: "Try Again", action: replay, width: 140, font: .body, color: .black)
                        PlayButton(title: "Select Level", action: setGame, width: 140, font: .body, color: .white, backgroundColor: .gray)
                    }
                }
                .frame(width: 300, height: 640)
            }
        }
    }
    
    func checkAnswer() {
        showResultLabel = true
        if Int(answer) ?? 0 == correctAnswer {
            self.bgColor = [Color.green, Color.gray]
            resultLabel = "🎉Correct!🎉"
            scores += 1
        } else {
            resultLabel = "👏Sorry, Worng.."
            self.bgColor = [Color.red, Color.gray]
        }
        
        
        
    }
    
    func selectTable(number: Int) {
        selectedTableNumber = number
    }
    
    func playGame() {
        if questionNumber == numberOfQuestions {
            gameResult()
            return
        }
        gameState = .play
        questionNumber += 1
        shuffle = Bool.random()
        showResultLabel = false
        
        answer = ""
        self.bgColor = [Color.white, Color.gray]
        randomMultiplyNumber = Int.random(in: 0...15)
    }
    
    func setGame() {
        gameState = .setting
        questionNumber = 0
        scores = 0
        self.bgColor = [Color.gray, Color.white]
    }
    
    func playNextLevel() {
        selectedTableNumber += 1
        questionNumber = 0
        scores = 0
        self.playGame()
    }
    
    func replay() {
        gameState = .play
        questionNumber = 0
        scores = 0
        playGame()
        self.bgColor = [Color.white, Color.gray]
    }
    
    func gameResult() {
        gameState = .result
        self.bgColor = [Color.gray, Color.white]
        
        switch Double(scores) {
        case Double(numberOfQuestions):
            resultMessage = """
                                Congratulations!✨
                                You made it perfectly.
                                """
        case Double(numberOfQuestions) * 0.7 ..< Double(numberOfQuestions):
            resultMessage = """
                                Well Done!👍
                                You doing so good.
                                """
        case Double(numberOfQuestions) * 0.5 ... Double(numberOfQuestions) + 0.7:
            resultMessage = """
                                Nice!🙌
                                So far so good.
                                """
        case 0.0..<Double(numberOfQuestions) * 0.5:
            resultMessage = """
                                It's okay🤝
                                Let's try this again!
                                """
        default: return
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct NumberButtons : View {
    let from: Int
    let to: Int
    let action: (Int) -> Void
    let selectedNumber: Int
    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(from..<to+1) { number in
                    if number == selectedNumber {
                        Button("\(number)") {
                            self.action(number)
                        }
                        .frame(width:60, height: 60)
                        .font(.title)
                        .background(Color.green)
                        .clipShape(Circle())
//                        .shadow(color: .green, radius: 8)
                        .foregroundColor(.white)
                        .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2))
                        
                        
                    } else {
                        
                        Button("\(number)") {
                            self.action(number)
                        }
                        .frame(width:60, height: 60)
                        .font(.title)
                        .background(Color.white)
                        .clipShape(Circle())
//                        .shadow(color: .green, radius: 3)
                        .foregroundColor(.gray)
                    }
            }
        }
    }
}

struct PlayButton : View {
    let title: String
    let action: () -> Void
    var width: CGFloat = 300
    var font: Font = .title
    var color: Color = .blue
    var backgroundColor: Color = .white
    
    var body: some View {
        Button(action: {
            withAnimation {
                self.action()
            }
        }) {
            Text(title)
                .frame(width: width, height: 50)
                .font(font)
                .foregroundColor(color)
                .background(backgroundColor)
                .cornerRadius(20)
//                .shadow(color: .gray, radius: 2)
            
        }
    }
}

struct Header : View {
    let title: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(width: 300, height: 30)
                .cornerRadius(20)
            
            Text(title)
                .font(.body)
                .foregroundColor(.gray)
        }
    }
}
