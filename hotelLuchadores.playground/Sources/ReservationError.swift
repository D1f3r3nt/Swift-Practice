public enum ReservationError: Error {
    case repeatedId
    case noReservation
    case userAlreadyReserved
}
