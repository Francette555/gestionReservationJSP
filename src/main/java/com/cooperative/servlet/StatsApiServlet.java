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

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder();

        try {
            VoitureDAO voitureDAO = new VoitureDAO();
            ClientDAO clientDAO = new ClientDAO();
            ReservationDAO reservationDAO = new ReservationDAO();

            int nbVoitures = voitureDAO.findAll().size();
            int nbClients = clientDAO.findAll().size();
            int nbReservations = reservationDAO.findAll().size();
            int totalRecette = reservationDAO.getRecetteTotale();

            json.append("{");
            json.append("\"nbVoitures\":").append(nbVoitures).append(",");
            json.append("\"nbClients\":").append(nbClients).append(",");
            json.append("\"nbReservations\":").append(nbReservations).append(",");
            json.append("\"totalRecette\":").append(totalRecette);
            json.append("}");

        } catch (SQLException e) {
            // En cas d'erreur, retourner des valeurs par défaut
            json.append("{");
            json.append("\"nbVoitures\":0,");
            json.append("\"nbClients\":0,");
            json.append("\"nbReservations\":0,");
            json.append("\"totalRecette\":0");
            json.append("}");
            e.printStackTrace();
        }

        response.getWriter().write(json.toString());
    }
}