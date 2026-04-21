package com.cooperative.servlet;

import com.cooperative.dao.ClientDAO;
import com.cooperative.dao.ReservationDAO;
import com.cooperative.dao.VoitureDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/api/stats")
public class StatsApiServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== StatsApiServlet doGet() appelée ===");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder();

        try {
            VoitureDAO voitureDAO = new VoitureDAO();
            ClientDAO clientDAO = new ClientDAO();
            ReservationDAO reservationDAO = new ReservationDAO();

            int nbVoitures = voitureDAO.findAll().size();
            System.out.println("nbVoitures = " + nbVoitures);

            int nbClients = clientDAO.findAll().size();
            System.out.println("nbClients = " + nbClients);

            int nbReservations = reservationDAO.findAll().size();
            System.out.println("nbReservations = " + nbReservations);

            int totalRecette = reservationDAO.getRecetteTotale();
            System.out.println("totalRecette = " + totalRecette);

            json.append("{");
            json.append("\"nbVoitures\":").append(nbVoitures).append(",");
            json.append("\"nbClients\":").append(nbClients).append(",");
            json.append("\"nbReservations\":").append(nbReservations).append(",");
            json.append("\"totalRecette\":").append(totalRecette);
            json.append("}");

        } catch (SQLException e) {
            System.err.println("ERREUR dans StatsApiServlet: " + e.getMessage());
            e.printStackTrace();
            json.append("{");
            json.append("\"nbVoitures\":0,");
            json.append("\"nbClients\":0,");
            json.append("\"nbReservations\":0,");
            json.append("\"totalRecette\":0");
            json.append("}");
        }

        System.out.println("Réponse JSON: " + json.toString());
        response.getWriter().write(json.toString());
    }
}