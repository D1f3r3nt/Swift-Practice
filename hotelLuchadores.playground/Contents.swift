class HotelReservationManager {
    private var reservations: [Reservation]
    private let hotelName: String = "Transilvania"
    private let pricePerClient: Double = 20.0
    private var counter: Int = 0
    
    init() {
        // tests
        self.reservations = []
        testAddReservation()
        testCancelReservation()
        testReservationPrice()
        
        // init
        self.reservations = []
        self.counter = 0
    }
    
    /// Crea método para añadir una reserva. Asigna un ID único (puedes usar un contador por ejemplo),
    /// calcula el precio y agrega el nombre del hotel
    /// - Parameters:
    ///   - clients: Lista de clientes
    ///   - days: Duración
    ///   - breakfast: Opción de desayuno
    /// - Returns: La reserva creada
    public func addReservation(clients: [Client], days: Int, breakfast: Bool) -> Reservation? {
        var reservation: Reservation? = nil
        
        do {
            try checkClientsAlreadyLogued(clients)
            
            let price: Double = calculatePrice(clients: clients, days: days, breakfast: breakfast)
            let id: Int = try newId()
            
            reservation = Reservation(
                idUnico: id,
                nameHotel: hotelName,
                clients: clients,
                days: days,
                price: price,
                breakfast: breakfast
            )
            
            reservations.append(reservation!)
            
            
        } catch ReservationError.userAlreadyReserved {
            print("ERROR: Este usuario ya esta logueado")
        } catch ReservationError.repeatedId {
            print("ERROR: El ID ya existe")
        } catch {}
        
        return reservation
    }
    
    /// Un método para cancelar una reserva.
    /// Cancela la reserva dado su ID, lanzando un ReservationError si esta no existe
    /// - Parameter id: El ID a cancelar
    public func cancelReservation(id: Int) {
        do {
            try checkIdReservation(id)
            
            reservations = reservations.filter {$0.idUnico != id}
        } catch ReservationError.noReservation {
            print("ERROR: El ID de la reserva no existe")
        } catch {}
    }
    
    
    /// Un método para obtener un listado de todas las
    /// reservas actuales
    public func getAllReservations() -> [Reservation] {
        return reservations
    }
    
    /// Para recoger el nuevo ID único
    /// - Returns: El ID único
    private func newId() throws -> Int {
        counter += 1
        
        if (reservations.contains {res in res.idUnico == counter}) {
            throw ReservationError.repeatedId
        }
        
        return counter
    }
    
    
    /// Comprueba si la reserva existe
    /// - Parameter id: Id de la reserva
    private func checkIdReservation(_ id: Int) throws {
        if (!reservations.contains {$0.idUnico == id}) {
            throw ReservationError.noReservation
        }
    }
    
    /// número de clientes * precio base por cliente * días en el hotel * 1,25 si toman desayuno o 1 si no toman desayuno
    /// - Parameters:
    ///   - clients: Array de clientes
    ///   - days: Numero de dias que estara en el hotel
    ///   - breakfast: Si tiene desayuno o no
    /// - Returns: El precio pertinente
    private func calculatePrice(clients: [Client], days: Int, breakfast: Bool) -> Double {
        var result: Double = 0.0
        result = Double(clients.count) * pricePerClient * Double(days)
        result *= breakfast ? 1.25 : 1.0
        return result
    }
    
    
    /// Para comprobar si un usuario ya se ha logueado anteriormente
    /// - Parameter clients: Array de clientes a comprobar
    /// - Returns: Si devuelve True existe, si devuelve False no existe
    private func checkClientsAlreadyLogued (_ clients: [Client]) throws {
        if Set(clients).count != clients.count {
            throw ReservationError.userAlreadyReserved
        }
        
        for client in clients {
            for reservation in reservations {
                if reservation.clients.contains(client) {
                    throw ReservationError.userAlreadyReserved
                }
            }
        }
    }
    
    
    /// Verifica errores al añadir reservas duplicadas
    /// y que nuevas reservas sean añadidas correctamente.
    private func testAddReservation() {
        reservations = []
        
        let test = Client(nombre: "Test", edad: 1, altura: 1)
        let testRepeat = Client(nombre: "Test", edad: 1, altura: 1)
        let test2 = Client(nombre: "Test 2", edad: 1, altura: 1)
        
        let reservation: Reservation? = addReservation(clients: [test], days: 1, breakfast: true)
        let reservation2: Reservation? = addReservation(clients: [test2], days: 1, breakfast: true)
        
        guard let reservation else {
            assertionFailure("TEST FAILED: Null value")
            return
        }
        
        guard let reservation2 else {
            assertionFailure("TEST FAILED: Null value")
            return
        }
        
        do {
            try checkClientsAlreadyLogued([testRepeat])
            assertionFailure("TEST FAILED: No check user already exists")
        } catch {}
        
        assert(reservations.count == 2)
        assert(reservation.idUnico != reservation2.idUnico)
        print("TEST PASSED: testAddReservation")
    }
    
    
    /// Verifica que las reservas se cancelen correctamente
    /// y que cancelar una reserva no existente resulte en un error.
    private func testCancelReservation() {
        reservations = []
        
        let test = Client(nombre: "Test", edad: 1, altura: 1)
        let test2 = Client(nombre: "Test 2", edad: 1, altura: 1)
        
        let reservation: Reservation? = addReservation(clients: [test], days: 1, breakfast: true)
        addReservation(clients: [test2], days: 1, breakfast: true)
        
        guard let reservation else {
            assertionFailure("TEST FAILED: Null value")
            return
        }
        
        cancelReservation(id: reservation.idUnico)
        
        
        do {
            try checkIdReservation(1000)
            assertionFailure("TEST FAILED: No check resevation no exists")
        } catch {}
        
        assert(reservations.count == 1)
        print("TEST PASSED: testCancelReservation")
    }
    
    /// Asegura que el sistema calcula los precios de forma consistente
    private func testReservationPrice() {
        reservations = []
        
        let test = Client(nombre: "Test 3", edad: 1, altura: 1)
        let reservation: Reservation? = addReservation(clients: [test], days: 1, breakfast: true)
        
        let test2 = Client(nombre: "Test 4", edad: 1, altura: 1)
        let reservation2: Reservation? = addReservation(clients: [test2], days: 1, breakfast: true)
        
        guard let reservation else {
            assertionFailure("TEST FAILED: Null value")
            return
        }
        
        guard let reservation2 else {
            assertionFailure("TEST FAILED: Null value")
            return
        }
        
        assert(reservation.price == reservation2.price)
        print("TEST PASSED: testReservationPrice")
    }
}

// Code execution example :)

let manager = HotelReservationManager()
let marc = Client(nombre: "Marc", edad: 19, altura: 180)
let laura = Client(nombre: "Laura", edad: 16, altura: 160)

print(manager.addReservation(clients: [marc], days: 2, breakfast: false) as Any)
print(manager.addReservation(clients: [marc], days: 5, breakfast: true) as Any) // Este da error

manager.cancelReservation(id: 1)
// Aqui lanza error porque el ID 3 no existe
manager.cancelReservation(id: 3)

print(manager.addReservation(clients: [marc], days: 10, breakfast: true) as Any) // Lo permite ya que se ha borrado
print(manager.addReservation(clients: [marc, laura], days: 5, breakfast: true) as Any) // Este da error

print(manager.getAllReservations())

