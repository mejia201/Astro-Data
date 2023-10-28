import SwiftUI

struct ContentView: View {
    
    @State private var isLoading = true

    var body: some View {
            ZStack {
                if isLoading {
                    // Pantalla de carga
                    Color.white
                        .ignoresSafeArea()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isLoading = false
                            }
                        }
                    VStack(spacing: 10) {
                        ZStack {
                            Rectangle()
                                .fill(Color.teal)
                                .frame(width: 330, height: 90)
                                .cornerRadius(10)
                            HStack {
                                Image("nasa_logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 150, height: 100)

        
                                Text("AstroData")
                                    .foregroundColor(.white)
                                    .font(.custom("Futura", size: 35))
                                    .multilineTextAlignment(.center)
                                    .padding(.trailing, 35)
                                    
                            }
                        }
                        .padding()

                        Text("Cargando...")
                            .foregroundColor(.black)
                            .font(.title3)
                            .bold()
                        }



                  
                } else {
                    // Contenido principal
                    NavigationView {
                                        VStack {
                                          
                                            Image("nasa")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(height: 300)
                                            
                                            //Dirigir a filtro 1
                                            NavigationLink(destination: AsteroidsView()) {
                                                Text("Asteroides")
                                                    .font(.system(size: 20, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .frame(width: 200, height: 50)
                                                    .background(Color.black)
                                                    .cornerRadius(10)
                                                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                                    .shadow(radius: 5)
                                            }
                                            
                                            //Dirigir a filtro 2
                                            NavigationLink(destination: QuizQuestionView()) {
                                                Text("Imagenes")
                                                    .font(.system(size: 20, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .frame(width: 200, height: 50)
                                                    .background(Color.blue)
                                                    .cornerRadius(10)
                                                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                                    .shadow(radius: 5)
                                            }
                                           
                                            //Dirigir al quiz
                                            NavigationLink(destination: QuizQuestionView()) {
                                                Text("Quiz")
                                                    .font(.system(size: 20, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .frame(width: 200, height: 50)
                                                    .background(Color.red)
                                                    .cornerRadius(10)
                                                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                                    .shadow(radius: 5)
                                            }
                                        }
                                        .navigationBarTitle("Menú")
                        
                                    }
                
                   
                
                }
            }
        }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
