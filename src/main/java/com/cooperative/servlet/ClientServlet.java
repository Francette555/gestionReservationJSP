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

@WebServlet("/ClientServlet")
public class ClientServlet extends HttpServlet {
    private ClientDAO clientDAO = new ClientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        System.out.println("=== ClientServlet doGet ===");
        System.out.println("Action: " + action);

        try {
            // Gestion des actions GET
            if ("delete".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    int id = Integer.parseInt(idParam);
                    clientDAO.delete(id);
                    request.setAttribute("success", "deleted");
                    System.out.println("Client supprimé ID: " + id);
                }
            }
            else if ("edit".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    int id = Integer.parseInt(idParam);
                    Client client = clientDAO.findById(id);
                    request.setAttribute("clientToEdit", client);
                    System.out.println("Client à modifier: " + client);
                }
            }
            else if ("search".equals(action)) {
                String keyword = request.getParameter("keyword");
                if (keyword != null && !keyword.trim().isEmpty()) {
                    List<Client> searchResults = clientDAO.searchByNomOrTel(keyword);
                    request.setAttribute("searchResults", searchResults);
                    request.setAttribute("keyword", keyword);
                    System.out.println("Recherche: " + keyword + " - Résultats: " + searchResults.size());
                }
            }

            // TOUJOURS charger la liste complète des clients
            List<Client> clients = clientDAO.findAll();
            request.setAttribute("clients", clients);
            System.out.println("Total clients chargés: " + clients.size());

        } catch (SQLException e) {
            System.err.println("Erreur SQL: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur base de données: " + e.getMessage());
        } catch (NumberFormatException e) {
            System.err.println("Erreur format ID: " + e.getMessage());
            request.setAttribute("error", "ID invalide");
        }

        // Redirection vers la JSP
        request.getRequestDispatcher("/client/client.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        System.out.println("=== ClientServlet doPost ===");
        System.out.println("Action: " + action);

        try {
            if ("insert".equals(action)) {
                // Récupération des paramètres
                String nom = request.getParameter("nom");
                String tel = request.getParameter("numtel");

                System.out.println("Insert - Nom: " + nom + ", Tél: " + tel);

                if (nom == null || nom.trim().isEmpty()) {
                    request.setAttribute("error", "Le nom est requis");
                } else if (tel == null || tel.trim().isEmpty()) {
                    request.setAttribute("error", "Le numéro de téléphone est requis");
                } else {
                    Client client = new Client();
                    client.setNom(nom.trim());
                    client.setNumtel(tel.trim());
                    clientDAO.create(client);
                    request.setAttribute("success", "added");
                    System.out.println("Client ajouté avec succès");
                }
            }
            else if ("update".equals(action)) {
                // Récupération des paramètres
                String idParam = request.getParameter("idclt");
                String nom = request.getParameter("nom");
                String tel = request.getParameter("numtel");

                System.out.println("Update - ID: " + idParam + ", Nom: " + nom + ", Tél: " + tel);

                if (idParam == null || idParam.isEmpty()) {
                    request.setAttribute("error", "ID du client manquant");
                } else if (nom == null || nom.trim().isEmpty()) {
                    request.setAttribute("error", "Le nom est requis");
                } else if (tel == null || tel.trim().isEmpty()) {
                    request.setAttribute("error", "Le numéro de téléphone est requis");
                } else {
                    Client client = new Client();
                    client.setIdclt(Integer.parseInt(idParam));
                    client.setNom(nom.trim());
                    client.setNumtel(tel.trim());
                    clientDAO.update(client);
                    request.setAttribute("success", "updated");
                    // Supprimer l'attribut d'édition
                    request.removeAttribute("clientToEdit");
                    System.out.println("Client modifié avec succès");
                }
            }
            else {
                System.out.println("Action non reconnue: " + action);
            }

            // TOUJOURS recharger la liste complète
            List<Client> clients = clientDAO.findAll();
            request.setAttribute("clients", clients);
            System.out.println("Total clients après opération: " + clients.size());

        } catch (SQLException e) {
            System.err.println("Erreur SQL: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur base de données: " + e.getMessage());
        } catch (NumberFormatException e) {
            System.err.println("Erreur format ID: " + e.getMessage());
            request.setAttribute("error", "Format d'ID invalide");
        }

        // Redirection vers la JSP
        request.getRequestDispatcher("/client/client.jsp").forward(request, response);
    }
}