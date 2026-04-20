package com.cooperative.servlet;

import com.cooperative.dao.ReservationDAO;
import com.cooperative.dao.VoitureDAO;
import com.cooperative.model.Voiture;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/places/libres")
public class PlacesLibresServlet extends HttpServlet {
    private ReservationDAO reservationDAO = new ReservationDAO();
    private VoitureDAO voitureDAO = new VoitureDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Voiture> voitures = voitureDAO.findAll();
            request.setAttribute("voitures", voitures);
            // Redirection vers la page reservation.jsp qui contient la section places libres
            request.getRequestDispatcher("/reservation/reservation.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors du chargement des voitures: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idvoit = request.getParameter("idvoit");

        try {
            List<Integer> placesLibres = reservationDAO.getPlacesLibres(idvoit);
            Voiture voiture = voitureDAO.findById(idvoit);
            List<Voiture> voitures = voitureDAO.findAll();

            request.setAttribute("placesLibres", placesLibres);
            request.setAttribute("selectedVoiture", voiture);
            request.setAttribute("voitures", voitures);
            // Redirection vers la page reservation.jsp
            request.getRequestDispatcher("/reservation/reservation.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Erreur lors de l'affichage des places libres: " + e.getMessage(), e);
        }
    }
}