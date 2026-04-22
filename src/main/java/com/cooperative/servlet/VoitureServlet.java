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

@WebServlet("/VoitureServlet")
public class VoitureServlet extends HttpServlet {
    private VoitureDAO voitureDAO = new VoitureDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        System.out.println("=== VoitureServlet doGet ===");
        System.out.println("Action: " + action);

        try {
            // Gestion des actions GET
            if ("delete".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    voitureDAO.delete(idParam);
                    request.setAttribute("success", "deleted");
                    System.out.println("Voiture supprimée ID: " + idParam);
                }
            }
            else if ("edit".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    Voiture voiture = voitureDAO.findById(idParam);
                    request.setAttribute("voitureToEdit", voiture);
                    System.out.println("Voiture à modifier: " + voiture);
                }
            }
           else if ("search".equals(action)) {
                String keyword = request.getParameter("keyword");
                if (keyword != null && !keyword.trim().isEmpty()) {
                    List<Voiture> searchResults = voitureDAO.searchByDesign(keyword);
                    request.setAttribute("searchResults", searchResults);
                    request.setAttribute("keyword", keyword);
                    System.out.println("Recherche: " + keyword + " - Résultats: " + searchResults.size());
                }
            }

            // TOUJOURS charger la liste complète des voitures
            List<Voiture> voitures = voitureDAO.findAll();
            request.setAttribute("voitures", voitures);
            System.out.println("Total voitures chargées: " + voitures.size());

        } catch (SQLException e) {
            System.err.println("Erreur SQL: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur base de données: " + e.getMessage());
        } catch (NumberFormatException e) {
            System.err.println("Erreur format ID: " + e.getMessage());
            request.setAttribute("error", "ID invalide");
        }

        // Redirection vers la JSP
        request.getRequestDispatcher("/voiture/voiture.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        System.out.println("=== VoitureServlet doPost ===");
        System.out.println("Action: " + action);

        try {
            if ("insert".equals(action)) {
                // Récupération des paramètres
                String idvoit = request.getParameter("idvoit");
                String design = request.getParameter("design");
                String type = request.getParameter("type");
                String nbrplaceStr = request.getParameter("nbrplace");
                String fraisStr = request.getParameter("frais");

                System.out.println("Insert - ID: " + idvoit + ", Design: " + design + ", Type: " + type + ", Places: " + nbrplaceStr + ", Frais: " + fraisStr);

                if (idvoit == null || idvoit.trim().isEmpty()) {
                    request.setAttribute("error", "L'ID de la voiture est requis");
                } else if (design == null || design.trim().isEmpty()) {
                    request.setAttribute("error", "Le design est requis");
                } else if (type == null || type.trim().isEmpty()) {
                    request.setAttribute("error", "Le type est requis");
                } else if (nbrplaceStr == null || nbrplaceStr.trim().isEmpty()) {
                    request.setAttribute("error", "Le nombre de places est requis");
                } else if (fraisStr == null || fraisStr.trim().isEmpty()) {
                    request.setAttribute("error", "Le frais est requis");
                } else {
                    Voiture voiture = new Voiture();
                    voiture.setIdvoit(idvoit.trim());
                    voiture.setDesign(design.trim());
                    voiture.setType(type.trim());
                    voiture.setNbrplace(Integer.parseInt(nbrplaceStr));
                    voiture.setFrais(Integer.parseInt(fraisStr));
                    voitureDAO.create(voiture);
                    request.setAttribute("success", "added");
                    System.out.println("Voiture ajoutée avec succès");
                }
            }
            else if ("update".equals(action)) {
                // Récupération des paramètres
                String idvoit = request.getParameter("idvoit");
                String design = request.getParameter("design");
                String type = request.getParameter("type");
                String nbrplaceStr = request.getParameter("nbrplace");
                String fraisStr = request.getParameter("frais");

                System.out.println("Update - ID: " + idvoit + ", Design: " + design + ", Type: " + type + ", Places: " + nbrplaceStr + ", Frais: " + fraisStr);

                if (idvoit == null || idvoit.trim().isEmpty()) {
                    request.setAttribute("error", "L'ID de la voiture est requis");
                } else if (design == null || design.trim().isEmpty()) {
                    request.setAttribute("error", "Le design est requis");
                } else if (type == null || type.trim().isEmpty()) {
                    request.setAttribute("error", "Le type est requis");
                } else if (nbrplaceStr == null || nbrplaceStr.trim().isEmpty()) {
                    request.setAttribute("error", "Le nombre de places est requis");
                } else if (fraisStr == null || fraisStr.trim().isEmpty()) {
                    request.setAttribute("error", "Le frais est requis");
                } else {
                    Voiture voiture = new Voiture();
                    voiture.setIdvoit(idvoit.trim());
                    voiture.setDesign(design.trim());
                    voiture.setType(type.trim());
                    voiture.setNbrplace(Integer.parseInt(nbrplaceStr));
                    voiture.setFrais(Integer.parseInt(fraisStr));
                    voitureDAO.update(voiture);
                    request.setAttribute("success", "updated");
                    request.removeAttribute("voitureToEdit");
                    System.out.println("Voiture modifiée avec succès");
                }
            }
            else {
                System.out.println("Action non reconnue: " + action);
            }

            // TOUJOURS recharger la liste complète
            List<Voiture> voitures = voitureDAO.findAll();
            request.setAttribute("voitures", voitures);
            System.out.println("Total voitures après opération: " + voitures.size());

        } catch (SQLException e) {
            System.err.println("Erreur SQL: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Erreur base de données: " + e.getMessage());
        } catch (NumberFormatException e) {
            System.err.println("Erreur format nombre: " + e.getMessage());
            request.setAttribute("error", "Format de nombre invalide pour les places ou les frais");
        }

        // Redirection vers la JSP
        request.getRequestDispatcher("/voiture/voiture.jsp").forward(request, response);
    }
}