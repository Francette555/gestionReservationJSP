package com.cooperative.servlet;

import com.cooperative.dao.ReservationDAO;
import com.cooperative.dao.VoitureDAO;
import com.cooperative.model.Reservation;
import com.cooperative.model.Voiture;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/paiement/paiement")
public class PaiementServlet extends HttpServlet {
    private ReservationDAO reservationDAO = new ReservationDAO();
    private VoitureDAO voitureDAO = new VoitureDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Charger toutes les voitures pour le filtre
            List<Voiture> voitures = voitureDAO.findAll();
            request.setAttribute("voitures", voitures);
            request.getRequestDispatcher("/paiement/paiement.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idvoit = request.getParameter("idvoit");
        String typePaiement = request.getParameter("typePaiement");

        System.out.println("=== PaiementServlet doPost ===");
        System.out.println("idvoit: " + idvoit);
        System.out.println("typePaiement: " + typePaiement);

        try {
            // Validation des paramètres
            if (idvoit == null || idvoit.trim().isEmpty()) {
                request.setAttribute("error", "Veuillez sélectionner une voiture");
                List<Voiture> voitures = voitureDAO.findAll();
                request.setAttribute("voitures", voitures);
                request.getRequestDispatcher("/paiement/paiement.jsp").forward(request, response);
                return;
            }

            if (typePaiement == null || typePaiement.trim().isEmpty()) {
                request.setAttribute("error", "Veuillez sélectionner un type de paiement");
                List<Voiture> voitures = voitureDAO.findAll();
                request.setAttribute("voitures", voitures);
                request.getRequestDispatcher("/paiement/paiement.jsp").forward(request, response);
                return;
            }

            // Récupérer les réservations filtrées
            List<Reservation> reservations = reservationDAO.getVoyageursParPaiement(idvoit, typePaiement);
            Voiture voiture = voitureDAO.findById(idvoit);
            List<Voiture> voitures = voitureDAO.findAll();

            System.out.println("Réservations trouvées: " + reservations.size());

            request.setAttribute("reservations", reservations);
            request.setAttribute("selectedVoiture", voiture);
            request.setAttribute("typePaiement", typePaiement);
            request.setAttribute("voitures", voitures);

            request.getRequestDispatcher("/paiement/paiement.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("Erreur SQL: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur base de données: " + e.getMessage());

            try {
                List<Voiture> voitures = voitureDAO.findAll();
                request.setAttribute("voitures", voitures);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }

            request.getRequestDispatcher("/paiement/paiement.jsp").forward(request, response);
        }
    }
}