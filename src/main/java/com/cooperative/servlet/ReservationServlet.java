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

@WebServlet("/reservation")
public class ReservationServlet extends HttpServlet {
    private ReservationDAO reservationDAO = new ReservationDAO();
    private ClientDAO clientDAO = new ClientDAO();
    private VoitureDAO voitureDAO = new VoitureDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        System.out.println("GET ReservationServlet - Action: " + action);

        try {
            if (action == null || action.equals("/") || action.equals("/list")) {
                listReservations(request, response);
            } else if (action.equals("/add")) {
                showAddForm(request, response);
            } else if (action.equals("/edit")) {
                showEditForm(request, response);
            } else if (action.equals("/delete")) {
                deleteReservation(request, response);
            } else {
                listReservations(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        System.out.println("POST ReservationServlet - Action: " + action);

        try {
            if (action == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
                return;
            }

            if (action.equals("/insert")) {
                insertReservation(request, response);
            } else if (action.equals("/update")) {
                updateReservation(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void listReservations(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Reservation> reservations = reservationDAO.findAll();
        List<Client> clients = clientDAO.findAll();
        List<Voiture> voitures = voitureDAO.findAll();

        request.setAttribute("reservations", reservations);
        request.setAttribute("clients", clients);
        request.setAttribute("voitures", voitures);
        request.getRequestDispatcher("/reservation/reservation.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Client> clients = clientDAO.findAll();
        List<Voiture> voitures = voitureDAO.findAll();
        request.setAttribute("clients", clients);
        request.setAttribute("voitures", voitures);
        request.getRequestDispatcher("/reservation/reservation.jsp?action=add").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Reservation reservation = reservationDAO.findById(id);
        List<Client> clients = clientDAO.findAll();
        List<Voiture> voitures = voitureDAO.findAll();

        request.setAttribute("reservation", reservation);
        request.setAttribute("clients", clients);
        request.setAttribute("voitures", voitures);
        request.getRequestDispatcher("/reservation/reservation.jsp").forward(request, response);
    }

    private void insertReservation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String idreserv = "RES" + System.currentTimeMillis();
        String idvoit = request.getParameter("idvoit");
        int idclt = Integer.parseInt(request.getParameter("idclt"));
        int place = Integer.parseInt(request.getParameter("place"));
        Date dateVoyage = Date.valueOf(request.getParameter("date_voyage"));
        String payement = request.getParameter("payement");
        int montantAvance = Integer.parseInt(request.getParameter("montant_avance"));

        Reservation reservation = new Reservation();
        reservation.setIdreserv(idreserv);
        reservation.setIdvoit(idvoit);
        reservation.setIdclt(idclt);
        reservation.setPlace(place);
        reservation.setDateReserv(new Timestamp(System.currentTimeMillis()));
        reservation.setDateVoyage(dateVoyage);
        reservation.setPayement(payement);
        reservation.setMontantAvance(montantAvance);

        reservationDAO.create(reservation);
        response.sendRedirect(request.getContextPath() + "/reservation/reservation.jsp?success=added");
    }

    private void updateReservation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String idreserv = request.getParameter("idreserv");
        String idvoit = request.getParameter("idvoit");
        int idclt = Integer.parseInt(request.getParameter("idclt"));
        int place = Integer.parseInt(request.getParameter("place"));
        Date dateVoyage = Date.valueOf(request.getParameter("date_voyage"));
        String payement = request.getParameter("payement");
        int montantAvance = Integer.parseInt(request.getParameter("montant_avance"));

        Reservation reservation = new Reservation();
        reservation.setIdreserv(idreserv);
        reservation.setIdvoit(idvoit);
        reservation.setIdclt(idclt);
        reservation.setPlace(place);
        reservation.setDateVoyage(dateVoyage);
        reservation.setPayement(payement);
        reservation.setMontantAvance(montantAvance);

        reservationDAO.update(reservation);
        response.sendRedirect(request.getContextPath() + "/reservation/reservation.jsp?success=updated");
    }

    private void deleteReservation(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        reservationDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/reservation/reservation.jsp?success=deleted");
    }
}