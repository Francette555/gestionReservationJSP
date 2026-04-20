package com.cooperative.servlet;

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

@WebServlet("/voiture")
public class VoitureServlet extends HttpServlet {
    private VoitureDAO voitureDAO = new VoitureDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getPathInfo();

        System.out.println("GET VoitureServlet - Action: " + action);

        try {
            if (action == null || action.equals("/") || action.equals("/list")) {
                listVoitures(request, response);
            } else if (action.equals("/add")) {
                showAddForm(request, response);
            } else if (action.equals("/edit")) {
                showEditForm(request, response);
            } else if (action.equals("/delete")) {
                deleteVoiture(request, response);
            } else {
                listVoitures(request, response);
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

        System.out.println("POST VoitureServlet - Action: " + action);

        try {
            if (action.equals("/insert")) {
                insertVoiture(request, response);
            } else if (action.equals("/update")) {
                updateVoiture(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }

    private void listVoitures(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Voiture> voitures = voitureDAO.findAll();
        request.setAttribute("voitures", voitures);
        // Redirection vers la page JSP qui contient TOUTES les fonctionnalités
        request.getRequestDispatcher("/voiture/voiture.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/voiture/voiture.jsp?action=add");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        Voiture voiture = voitureDAO.findById(id);
        if (voiture == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("voiture", voiture);
        request.getRequestDispatcher("/voiture/voiture.jsp").forward(request, response);
    }

    private void insertVoiture(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String idvoit = request.getParameter("idvoit");
        String design = request.getParameter("design");
        String type = request.getParameter("type");
        int nbrplace = Integer.parseInt(request.getParameter("nbrplace"));
        int frais = Integer.parseInt(request.getParameter("frais"));

        Voiture voiture = new Voiture(idvoit, design, type, nbrplace, frais);
        voitureDAO.create(voiture);

        response.sendRedirect(request.getContextPath() + "/voiture/voiture.jsp?success=added");
    }

    private void updateVoiture(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String idvoit = request.getParameter("idvoit");
        String design = request.getParameter("design");
        String type = request.getParameter("type");
        int nbrplace = Integer.parseInt(request.getParameter("nbrplace"));
        int frais = Integer.parseInt(request.getParameter("frais"));

        Voiture voiture = new Voiture(idvoit, design, type, nbrplace, frais);
        voitureDAO.update(voiture);

        response.sendRedirect(request.getContextPath() + "/voiture/voiture.jsp?success=updated");
    }

    private void deleteVoiture(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String id = request.getParameter("id");
        if (id == null || id.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        voitureDAO.delete(id);
        response.sendRedirect(request.getContextPath() + "/voiture/voiture.jsp?success=deleted");
    }
}