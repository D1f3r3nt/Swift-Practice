public struct Reservation: Equatable {
    
    public let idUnico: Int
    public var nameHotel: String
    public var clients: [Client]
    public var days: Int
    public var price: Double
    public var breakfast: Bool
    
    public init(idUnico: Int, nameHotel: String, clients: [Client], days: Int, price: Double, breakfast: Bool) {
        self.breakfast = breakfast
        self.clients = clients
        self.days = days
        self.idUnico = idUnico
        self.nameHotel = nameHotel
        self.price = price
    }
}
