/*package com.cooperative.servlet;

import com.cooperative.dao.ReservationDAO;
import com.cooperative.dao.ClientDAO;
import com.cooperative.dao.VoitureDAO;
import com.cooperative.model.Reservation;
import com.cooperative.model.Client;
import com.cooperative.model.Voiture;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {
    private ReservationDAO reservationDAO = new ReservationDAO();
    private ClientDAO clientDAO = new ClientDAO();
    private VoitureDAO voitureDAO = new VoitureDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        System.out.println("=== ReservationServlet doGet ===");
        System.out.println("Action: " + action);

        try {
            // Gestion des actions GET
            if ("delete".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    reservationDAO.delete(idParam);
                    request.setAttribute("success", "deleted");
                    System.out.println("Réservation supprimée ID: " + idParam);
                }
            }
            else if ("edit".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    Reservation reservation = reservationDAO.findById(idParam);
                    request.setAttribute("reservationToEdit", reservation);
                    System.out.println("Réservation à modifier: " + reservation.getIdreserv());
                }
            }

            // TOUJOURS charger la liste complète
            List<Reservation> reservations = reservationDAO.findAll();
            List<Client> clients = clientDAO.findAll();
            List<Voiture> voitures = voitureDAO.findAll();

            request.setAttribute("reservations", reservations);
            request.setAttribute("clients", clients);
            request.setAttribute("voitures", voitures);

            System.out.println("Total réservations chargées: " + reservations.size());
            System.out.println("Total clients chargés: " + clients.size());
            System.out.println("Total voitures chargées: " + voitures.size());

        } catch (SQLException e) {
            System.err.println("Erreur SQL: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur base de données: " + e.getMessage());
        } catch (NumberFormatException e) {
            System.err.println("Erreur format ID: " + e.getMessage());
            request.setAttribute("error", "ID invalide");
        }

        // Redirection vers la JSP
        request.getRequestDispatcher("/reservation/reservation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        System.out.println("=== ReservationServlet doPost ===");
        System.out.println("Action: " + action);

        try {
            if ("insert".equals(action)) {
                // Récupération des paramètres
                String idvoit = request.getParameter("idvoit");
                String idcltStr = request.getParameter("idclt");
                String placeStr = request.getParameter("place");
                String dateVoyageStr = request.getParameter("date_voyage");
                String payement = request.getParameter("payement");
                String montantAvanceStr = request.getParameter("montant_avance");

                System.out.println("Insert - ID Voiture: " + idvoit + ", ID Client: " + idcltStr + ", Place: " + placeStr + ", Date: " + dateVoyageStr + ", Paiement: " + payement + ", Avance: " + montantAvanceStr);

                // Validation
                if (idvoit == null || idvoit.trim().isEmpty()) {
                    request.setAttribute("error", "La voiture est requise");
                } else if (idcltStr == null || idcltStr.trim().isEmpty()) {
                    request.setAttribute("error", "Le client est requis");
                } else if (placeStr == null || placeStr.trim().isEmpty()) {
                    request.setAttribute("error", "Le numéro de place est requis");
                } else if (dateVoyageStr == null || dateVoyageStr.trim().isEmpty()) {
                    request.setAttribute("error", "La date de voyage est requise");
                } else {
                    // Génération d'un ID unique
                    String idreserv = "RES" + System.currentTimeMillis();

                    Reservation reservation = new Reservation();
                    reservation.setIdreserv(idreserv);
                    reservation.setIdvoit(idvoit.trim());
                    reservation.setIdclt(Integer.parseInt(idcltStr));
                    reservation.setPlace(Integer.parseInt(placeStr));
                    reservation.setDateReserv(new Timestamp(System.currentTimeMillis()));
                    reservation.setDateVoyage(Date.valueOf(dateVoyageStr));
                    reservation.setPayement(payement);
                    reservation.setMontantAvance(montantAvanceStr != null && !montantAvanceStr.isEmpty() ? Integer.parseInt(montantAvanceStr) : 0);

                    reservationDAO.create(reservation);
                    request.setAttribute("success", "added");
                    System.out.println("Réservation ajoutée avec succès - ID: " + idreserv);
                }
            }
            else if ("update".equals(action)) {
                // Récupération des paramètres
                String idreserv = request.getParameter("idreserv");
                String idvoit = request.getParameter("idvoit");
                String idcltStr = request.getParameter("idclt");
                String placeStr = request.getParameter("place");
                String dateVoyageStr = request.getParameter("date_voyage");
                String payement = request.getParameter("payement");
                String montantAvanceStr = request.getParameter("montant_avance");

                System.out.println("Update - ID: " + idreserv + ", ID Voiture: " + idvoit + ", ID Client: " + idcltStr + ", Place: " + placeStr + ", Date: " + dateVoyageStr);

                if (idreserv == null || idreserv.trim().isEmpty()) {
                    request.setAttribute("error", "L'ID de la réservation est requis");
                } else if (idvoit == null || idvoit.trim().isEmpty()) {
                    request.setAttribute("error", "La voiture est requise");
                } else if (idcltStr == null || idcltStr.trim().isEmpty()) {
                    request.setAttribute("error", "Le client est requis");
                } else if (placeStr == null || placeStr.trim().isEmpty()) {
                    request.setAttribute("error", "Le numéro de place est requis");
                } else if (dateVoyageStr == null || dateVoyageStr.trim().isEmpty()) {
                    request.setAttribute("error", "La date de voyage est requise");
                } else {
                    Reservation reservation = new Reservation();
                    reservation.setIdreserv(idreserv.trim());
                    reservation.setIdvoit(idvoit.trim());
                    reservation.setIdclt(Integer.parseInt(idcltStr));
                    reservation.setPlace(Integer.parseInt(placeStr));
                    reservation.setDateVoyage(Date.valueOf(dateVoyageStr));
                    reservation.setPayement(payement);
                    reservation.setMontantAvance(montantAvanceStr != null && !montantAvanceStr.isEmpty() ? Integer.parseInt(montantAvanceStr) : 0);

                    reservationDAO.update(reservation);
                    request.setAttribute("success", "updated");
                    request.removeAttribute("reservationToEdit");
                    System.out.println("Réservation modifiée avec succès - ID: " + idreserv);
                }
            }
            else {
                System.out.println("Action non reconnue: " + action);
            }

            // TOUJOURS recharger la liste complète
            List<Reservation> reservations = reservationDAO.findAll();
            List<Client> clients = clientDAO.findAll();
            List<Voiture> voitures = voitureDAO.findAll();

            request.setAttribute("reservations", reservations);
            request.setAttribute("clients", clients);
            request.setAttribute("voitures", voitures);

            System.out.println("Total réservations après opération: " + reservations.size());

        } catch (SQLException e) {
            System.err.println("Erreur SQL: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur base de données: " + e.getMessage());
        } catch (NumberFormatException e) {
            System.err.println("Erreur format nombre: " + e.getMessage());
            request.setAttribute("error", "Format de nombre invalide pour les places ou l'avance");
        } catch (IllegalArgumentException e) {
            System.err.println("Erreur format date: " + e.getMessage());
            request.setAttribute("error", "Format de date invalide (utilisez AAAA-MM-JJ)");
        }

        // Redirection vers la JSP
        request.getRequestDispatcher("/reservation/reservation.jsp").forward(request, response);
    }
}*/

package com.cooperative.servlet;

import com.cooperative.dao.ReservationDAO;
import com.cooperative.dao.ClientDAO;
import com.cooperative.dao.VoitureDAO;
import com.cooperative.model.Reservation;
import com.cooperative.model.Client;
import com.cooperative.model.Voiture;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {
    private ReservationDAO reservationDAO = new ReservationDAO();
    private ClientDAO clientDAO = new ClientDAO();
    private VoitureDAO voitureDAO = new VoitureDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    reservationDAO.delete(idParam);
                    request.setAttribute("success", "deleted");
                }
            }
            else if ("edit".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    Reservation reservation = reservationDAO.findById(idParam);
                    request.setAttribute("reservationToEdit", reservation);
                }
            }

            // ✅ Load ny clients sy voitures
            List<Client> clients = clientDAO.findAll();
            List<Voiture> voitures = voitureDAO.findAll();
            List<Reservation> reservations = reservationDAO.findAll();

            request.setAttribute("clients", clients);
            request.setAttribute("voitures", voitures);
            request.setAttribute("reservations", reservations);

            // ✅ Raha misy voiture voafidy, maka places libres
            String idvoit = request.getParameter("idvoit");
            if (idvoit != null && !idvoit.isEmpty()) {
                List<Integer> placesLibres = reservationDAO.getPlacesLibres(idvoit);
                Voiture selectedVoiture = voitureDAO.findById(idvoit);
                request.setAttribute("placesLibres", placesLibres);
                request.setAttribute("selectedVoiture", selectedVoiture);
            } else if (voitures != null && !voitures.isEmpty()) {
                // ✅ Raha tsy misy voafidy, omena places libres an' ilay voiture voalohany
                String firstVoitureId = voitures.get(0).getIdvoit();
                List<Integer> placesLibres = reservationDAO.getPlacesLibres(firstVoitureId);
                request.setAttribute("placesLibres", placesLibres);
                request.setAttribute("selectedVoiture", voitures.get(0));
            }

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur base de données: " + e.getMessage());
        }

        request.getRequestDispatcher("/reservation/reservation.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
           /* if ("insert".equals(action)) {
                String idvoit = request.getParameter("idvoit");
                String idcltStr = request.getParameter("idclt");
                String placeStr = request.getParameter("place");
                String dateVoyageStr = request.getParameter("date_voyage");
                String payement = request.getParameter("payement");
                String montantAvanceStr = request.getParameter("montant_avance");

                // ✅ Vérification place libre aloha
                List<Integer> placesLibres = reservationDAO.getPlacesLibres(idvoit);
                int placeNumber = Integer.parseInt(placeStr);

                if (!placesLibres.contains(placeNumber)) {
                    request.setAttribute("error", "⚠️ Place " + placeNumber + " tsy misy na efa nisy namandrika!");
                    loadCommonData(request);
                    request.getRequestDispatcher("/reservation/reservation.jsp").forward(request, response);
                    return;
                }

                String idreserv = "RES" + System.currentTimeMillis();
                Reservation reservation = new Reservation();
                reservation.setIdreserv(idreserv);
                reservation.setIdvoit(idvoit);
                reservation.setIdclt(Integer.parseInt(idcltStr));
                reservation.setPlace(placeNumber);
                reservation.setDateReserv(new Timestamp(System.currentTimeMillis()));
                reservation.setDateVoyage(Date.valueOf(dateVoyageStr));
                reservation.setPayement(payement);
                reservation.setMontantAvance(montantAvanceStr != null && !montantAvanceStr.isEmpty() ? Integer.parseInt(montantAvanceStr) : 0);

                boolean success = reservationDAO.create(reservation);
                if (success) {
                    request.setAttribute("success", "added");
                } else {
                    request.setAttribute("error", "Tsy voatahiry ny réservation!");
                }*/
            if ("insert".equals(action)) {
                String idvoit = request.getParameter("idvoit");
                int idclt = Integer.parseInt(request.getParameter("idclt"));
                int place = Integer.parseInt(request.getParameter("place"));
                Date dateVoyage = Date.valueOf(request.getParameter("date_voyage"));
                String payement = request.getParameter("payement");
                int montantAvance = Integer.parseInt(request.getParameter("montant_avance"));

                // ✅ VÉRIFICATION CRUCIALE : place libre pour cette date ?
                if (!reservationDAO.isPlaceLibre(idvoit, place, dateVoyage)) {
                    request.setAttribute("error", "Place " + place + " déjà réservée pour le " + dateVoyage);
                    loadCommonData(request);
                    request.getRequestDispatcher("/reservation/reservation.jsp").forward(request, response);
                    return;
                }

                Reservation r = new Reservation();
                r.setIdreserv(reservationDAO.getNextReservationId());
                r.setIdvoit(idvoit);
                r.setIdclt(idclt);
                r.setPlace(place);
                r.setDateReserv(new Timestamp(System.currentTimeMillis()));
                r.setDateVoyage(dateVoyage);
                r.setPayement(payement);
                r.setMontantAvance(montantAvance);

                if (reservationDAO.create(r)) {
                    request.setAttribute("success", "added");
                } else {
                    request.setAttribute("error", "Échec réservation");
                }

            }
            else if ("update".equals(action)) {
                String idreserv = request.getParameter("idreserv");
                String idvoit = request.getParameter("idvoit");
                String idcltStr = request.getParameter("idclt");
                String placeStr = request.getParameter("place");
                String dateVoyageStr = request.getParameter("date_voyage");
                String payement = request.getParameter("payement");
                String montantAvanceStr = request.getParameter("montant_avance");

                Reservation old = reservationDAO.findById(idreserv);
                int newPlace = Integer.parseInt(placeStr);

                if (old.getPlace() != newPlace) {
                    List<Integer> placesLibres = reservationDAO.getPlacesLibres(idvoit);
                    if (!placesLibres.contains(newPlace)) {
                        request.setAttribute("error", "⚠️ Place " + newPlace + " efa misy olona!");
                        loadCommonData(request);
                        request.setAttribute("reservationToEdit", old);
                        request.getRequestDispatcher("/reservation/reservation.jsp").forward(request, response);
                        return;
                    }
                }

                Reservation reservation = new Reservation();
                reservation.setIdreserv(idreserv);
                reservation.setIdvoit(idvoit);
                reservation.setIdclt(Integer.parseInt(idcltStr));
                reservation.setPlace(newPlace);
                reservation.setDateVoyage(Date.valueOf(dateVoyageStr));
                reservation.setPayement(payement);
                reservation.setMontantAvance(montantAvanceStr != null && !montantAvanceStr.isEmpty() ? Integer.parseInt(montantAvanceStr) : 0);

                reservationDAO.update(reservation);
                request.setAttribute("success", "updated");
            }

            loadCommonData(request);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur: " + e.getMessage());
            try {
                loadCommonData(request);
            } catch (SQLException ex) {
                throw new RuntimeException(ex);
            }
        }

        request.getRequestDispatcher("/reservation/reservation.jsp").forward(request, response);
    }

    private void loadCommonData(HttpServletRequest request) throws SQLException {
        List<Client> clients = clientDAO.findAll();
        List<Voiture> voitures = voitureDAO.findAll();
        List<Reservation> reservations = reservationDAO.findAll();

        request.setAttribute("clients", clients);
        request.setAttribute("voitures", voitures);
        request.setAttribute("reservations", reservations);

        String idvoit = request.getParameter("idvoit");
        if (idvoit != null && !idvoit.isEmpty()) {
            Date defaultDate = Date.valueOf(java.time.LocalDate.now().plusDays(1));
            List<Integer> placesLibres = reservationDAO.getPlacesLibres(idvoit, defaultDate);
            List<Integer> placesOccupees = reservationDAO.getPlacesOccupees(idvoit);
            Voiture selectedVoiture = voitureDAO.findById(idvoit);

            request.setAttribute("placesLibres", placesLibres);
            request.setAttribute("placesOccupees", placesOccupees);
            request.setAttribute("selectedVoiture", selectedVoiture);
        } else if (voitures != null && !voitures.isEmpty()) {
            String firstId = voitures.get(0).getIdvoit();
            request.setAttribute("placesLibres", reservationDAO.getPlacesLibres(firstId));
            request.setAttribute("placesOccupees", reservationDAO.getPlacesOccupees(firstId));
            request.setAttribute("selectedVoiture", voitures.get(0));
        }
    }
}

