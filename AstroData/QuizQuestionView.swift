import SwiftUI
import URLImage

struct QuizQuestionView: View {
    
    @State private var questions: [QuizQuestion] = []
    @State private var currentQuestionIndex = 0
    @State private var userScore = 0
    @State private var showScoreView = false
    @State private var isLoading = false
    @State private var numberOfQuestions = 10
    @State private var numeroPregunta = 1


 var body: some View {
         VStack {
             if isLoading {
                             Text("Cargando preguntas...")
                                 .font(.title2)
                                 .bold()
                                 .foregroundColor(.black)
                                 .padding()
             }
             else if currentQuestionIndex < questions.count {
                 
                 Text("Pregunta \(numeroPregunta) de \(questions.count)")
                     .font(.subheadline)
                     .foregroundColor(.gray)

                 Text(questions[currentQuestionIndex].question)
                     .font(.title)
                     .bold()
                     .padding()
                     .multilineTextAlignment(.center)
                 
                 URLImage(URL(string: questions[currentQuestionIndex].imageURL)!) { image in
                     image
                         .resizable()
                         .aspectRatio(contentMode: .fit)
                         .frame(width: 300, height: 300)
                         .padding()
                 }
                 
                 ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                     Button(action: {
                         checkAnswer(index)
                     }) {
                         Text(questions[currentQuestionIndex].options[index])
                             .font(.body)
                             .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                             .background(Color.blue)
                             .foregroundColor(.white)
                             .cornerRadius(10)
                     }
                 }
             }
             
             if showScoreView {
                 ScoreView(score: userScore, totalQuestions: questions.count, restartQuiz: resetQuiz)
             }
         }
         .onAppear(perform: {
             isLoading = true
             fetchQuestionsFromNASA()
         })
     }
 
 
 func fetchQuestionsFromNASA() {
     if questions.isEmpty {
         let apiKey = "lKnPv8jXStvjQhTPZARSErbLhJC5zrj2qAK73An4"
         let urlString = "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&count=\(numberOfQuestions)"
         
         if let url = URL(string: urlString) {
             let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                 if let error = error {
                     print("Error al obtener datos de la NASA: \(error.localizedDescription)")
                 } else if let data = data,
                     let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                     
                     for json in jsonArray {
                         if let title = json["title"] as? String,
                            let imageURL = json["hdurl"] as? String {
                             
                             // Verifica si la URL de la imagen en alta definición (hdurl) no es nula o vacía
                             if !imageURL.isEmpty {
                                 let correctAnswer = title // Respuesta correcta
                                 let allAnswers = [title, "Mountain-Top Yoga Retreat", "Gourmet Cooking Escapade", "Exotic Travel Destinations", "Underwater Cave Expedition", "World War II History", "Historical Inventions Timeline"
                                                   ,"Ocean Waves Retreat", "Ocean Waves Retreat",
                                                   "Chocolate Tasting Extravaganza", "Historical Fiction Book Club", "Urban Graffiti Art Exploration"] // Todas las posibles respuestas
                                 
                                 let wrongAnswers = generateRandomWrongAnswers(correctAnswer: correctAnswer, allAnswers: allAnswers, numberOfWrongAnswers: 2)
                                 
                                 let options = [correctAnswer] + wrongAnswers
                                 let shuffledOptions = options.shuffled()
                                 
                                 let correctAnswerIndex = shuffledOptions.firstIndex(of: correctAnswer) ?? 0
                                 
                                 let question = QuizQuestion(question: "¿Cuál es el título de la imagen?", options: shuffledOptions, correctAnswerIndex: correctAnswerIndex, imageURL: imageURL)
                                 questions.append(question)
                             }
                         }
                     }
                     
                     if !questions.isEmpty {
                         DispatchQueue.main.async {
                             isLoading = false
                             currentQuestionIndex = 0
                         }
                     }
                 }
             }
             task.resume()
         }
     }
 }



 
 
 func generateRandomWrongAnswers(correctAnswer: String, allAnswers: [String], numberOfWrongAnswers: Int) -> [String] {
     var wrongAnswers: [String] = []

     while wrongAnswers.count < numberOfWrongAnswers {
         let randomAnswer = allAnswers.randomElement()
         if let randomAnswer = randomAnswer, randomAnswer != correctAnswer {
             wrongAnswers.append(randomAnswer)
         }
     }

     return wrongAnswers
 }





 func checkAnswer(_ selectedAnswerIndex: Int) {
         let correctAnswerIndex = questions[currentQuestionIndex].correctAnswerIndex
         
         if selectedAnswerIndex == correctAnswerIndex {
             userScore += 1
         }
         
         currentQuestionIndex += 1
         numeroPregunta += 1
         
         if currentQuestionIndex == questions.count {
             showScoreView = true
         }
     }
     
     func resetQuiz() {
         isLoading = true
         questions.removeAll()
         currentQuestionIndex = 0
         userScore = 0
         showScoreView = false
         numeroPregunta = 1
         fetchQuestionsFromNASA()
     }
 
 
}


struct ScoreView: View {
    let score: Int
    let totalQuestions: Int
    let restartQuiz: () -> Void

    var body: some View {
        VStack {
            Text("El quiz fue completado. Puntuación: \(score) de \(totalQuestions)")
                .font(.title2)
                .fontWeight(.bold)
                .padding()
                .multilineTextAlignment(.center)
                .foregroundColor(.blue)
            
            Button(action: {
                restartQuiz()
            }) {
                Text("Reiniciar")
                    .font(.body)
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}




struct QuizQuestionView_Preview: PreviewProvider {
    static var previews: some View {
       QuizQuestionView()
    }
}
