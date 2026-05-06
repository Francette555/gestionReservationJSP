package com.cooperative.servlet;

import com.cooperative.dao.ReservationDAO;
import com.cooperative.dao.VoitureDAO;
import com.cooperative.model.Voiture;
import com.google.gson.Gson;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/GetPlacesLibres")
public class GetPlacesLibresServlet extends HttpServlet {
    private ReservationDAO reservationDAO = new ReservationDAO();
    private VoitureDAO voitureDAO = new VoitureDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idvoit = request.getParameter("idvoit");
        String dateVoyageStr = request.getParameter("date_voyage");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            Map<String, Object> result = new HashMap<>();

            if (idvoit != null && !idvoit.isEmpty() && dateVoyageStr != null && !dateVoyageStr.isEmpty()) {
                Date dateVoyage = Date.valueOf(dateVoyageStr);
                List<Integer> placesLibres = reservationDAO.getPlacesLibres(idvoit, dateVoyage);

                VoitureDAO voitureDAO = new VoitureDAO();
                Voiture voiture = voitureDAO.findById(idvoit);

                result.put("success", true);
                result.put("places", placesLibres);
                result.put("nbrplace", voiture != null ? voiture.getNbrplace() : 0);
            } else {
                result.put("success", false);
                result.put("error", "Paramètres manquants");
            }

            Gson gson = new Gson();
            String json = gson.toJson(result);
            response.getWriter().write(json);

        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}