public struct Client: Equatable, Hashable {
    var nombre: String
    var edad: Int
    var altura: Int
    
    public init(nombre: String, edad: Int, altura: Int) {
        self.altura = altura
        self.edad = edad
        self.nombre = nombre
    }
}
