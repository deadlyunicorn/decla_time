class ReservationsDatabase{

  void storeReservationsToDatabase(){

    //calls readReservationFile() and gets a List<Reservation>
    //this is inside a try in order to catch no reservations or unknown file

    //after everything is okay, it tries to store the reservations to the local db.
    //entries must be unique based on their id.
  }

  void getReservationsFromDatabase(){

    //get the list of reservations.
    //we can two optional parameters FROM date and UNTIL date.

  }

}