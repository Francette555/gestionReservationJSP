/*package com.cooperative.servlet;

import com.cooperative.dao.ReservationDAO;
import com.cooperative.dao.VoitureDAO;
import com.cooperative.model.Voiture;
import com.google.gson.Gson;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/GetPlacesStatus")
public class GetPlacesStatusServlet extends HttpServlet {
    private ReservationDAO reservationDAO = new ReservationDAO();
    private VoitureDAO voitureDAO = new VoitureDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idvoit = request.getParameter("idvoit");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            Voiture voiture = voitureDAO.findById(idvoit);
            List<Integer> placesOccupees = reservationDAO.getPlacesOccupees(idvoit);

            Map<String, Object> result = new HashMap<>();
            result.put("nbrplace", voiture.getNbrplace());
            result.put("placesOccupees", placesOccupees);
            result.put("success", true);

            Gson gson = new Gson();
            response.getWriter().write(gson.toJson(result));

        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}*/

package com.cooperative.servlet;

import com.cooperative.dao.ReservationDAO;
import com.cooperative.dao.VoitureDAO;
import com.cooperative.model.Voiture;
import com.google.gson.Gson;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/GetPlacesStatus")
public class GetPlacesStatusServlet extends HttpServlet {
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
            Voiture voiture = voitureDAO.findById(idvoit);
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("nbrplace", voiture != null ? voiture.getNbrplace() : 0);

            if (dateVoyageStr != null && !dateVoyageStr.isEmpty() && idvoit != null) {
                Date dateVoyage = Date.valueOf(dateVoyageStr);
                List<Integer> placesOccupees = reservationDAO.getPlacesOccupees(idvoit, dateVoyage);
                result.put("placesOccupees", placesOccupees);
            } else {
                result.put("placesOccupees", new java.util.ArrayList<>());
            }

            Gson gson = new Gson();
            response.getWriter().write(gson.toJson(result));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}