package com.cooperative.servlet;

import com.cooperative.dao.ClientDAO;
import com.cooperative.model.Client;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/client/*")
public class ClientServlet extends HttpServlet {
    private ClientDAO clientDAO = new ClientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        System.out.println("GET ClientServlet - PathInfo: " + pathInfo);

        try {
            if (pathInfo == null || pathInfo.equals("/") || pathInfo.equals("/list")) {
                listClients(request, response);
            } else if (pathInfo.equals("/edit")) {
                showEditForm(request, response);
            } else if (pathInfo.equals("/delete")) {
                deleteClient(request, response);
            } else if (pathInfo.equals("/search")) {
                searchClients(request, response);
            } else {
                listClients(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur base de données: " + e.getMessage());
            try {
                listClients(request, response);
            } catch (Exception ex) {
                throw new ServletException(ex);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID invalide");
            try {
                listClients(request, response);
            } catch (Exception ex) {
                throw new ServletException(ex);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();

        System.out.println("POST ClientServlet - PathInfo: " + pathInfo);

        try {
            if (pathInfo == null) {
                listClients(request, response);
                return;
            }

            if (pathInfo.equals("/insert")) {
                insertClient(request, response);
            } else if (pathInfo.equals("/update")) {
                updateClient(request, response);
            } else {
                listClients(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur base de données: " + e.getMessage());
          //  listClients(request, response);
        }
    }

    private void listClients(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Client> clients = clientDAO.findAll();
        request.setAttribute("clients", clients);
        request.getRequestDispatcher("/client/client.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            request.setAttribute("error", "ID du client manquant");
            listClients(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Client client = clientDAO.findById(id);
            if (client == null) {
                request.setAttribute("error", "Client non trouvé");
            } else {
                request.setAttribute("client", client);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Format d'ID invalide");
        }

        listClients(request, response);
    }

    private void insertClient(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String nom = request.getParameter("nom");
        String numtel = request.getParameter("numtel");

        if (nom == null || nom.trim().isEmpty()) {
            request.setAttribute("error", "Le nom est requis");
            listClients(request, response);
            return;
        }

        if (numtel == null || numtel.trim().isEmpty()) {
            request.setAttribute("error", "Le numéro de téléphone est requis");
            listClients(request, response);
            return;
        }

        try {
            Client client = new Client();
            client.setNom(nom.trim());
            client.setNumtel(numtel.trim());
            clientDAO.create(client);
            request.setAttribute("success", "added");
        } catch (SQLException e) {
            if (e.getMessage().contains("Duplicate")) {
                request.setAttribute("error", "Ce numéro de téléphone existe déjà");
            } else {
                request.setAttribute("error", "Erreur lors de l'insertion: " + e.getMessage());
            }
        }

        listClients(request, response);
    }

    private void updateClient(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String idParam = request.getParameter("idclt");
        if (idParam == null || idParam.isEmpty()) {
            request.setAttribute("error", "ID du client manquant");
            listClients(request, response);
            return;
        }

        String nom = request.getParameter("nom");
        String numtel = request.getParameter("numtel");

        if (nom == null || nom.trim().isEmpty()) {
            request.setAttribute("error", "Le nom est requis");
            listClients(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            Client client = new Client();
            client.setIdclt(id);
            client.setNom(nom.trim());
            client.setNumtel(numtel.trim());
            clientDAO.update(client);
            request.setAttribute("success", "updated");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Format d'ID invalide");
        } catch (SQLException e) {
            request.setAttribute("error", "Erreur lors de la mise à jour: " + e.getMessage());
        }

        listClients(request, response);
    }

    private void deleteClient(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            request.setAttribute("error", "ID du client manquant");
            listClients(request, response);
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            clientDAO.delete(id);
            request.setAttribute("success", "deleted");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Format d'ID invalide");
        } catch (SQLException e) {
            request.setAttribute("error", "Erreur lors de la suppression: " + e.getMessage());
        }

        listClients(request, response);
    }

    private void searchClients(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");

        if (keyword != null && !keyword.trim().isEmpty()) {
            List<Client> searchResults = clientDAO.searchByNomOrTel(keyword);
            request.setAttribute("searchResults", searchResults);
            request.setAttribute("keyword", keyword);
        }

        listClients(request, response);
    }
}