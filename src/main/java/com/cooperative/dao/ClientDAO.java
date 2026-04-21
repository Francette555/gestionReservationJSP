package com.cooperative.dao;

import com.cooperative.model.Client;
import com.cooperative.utils.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClientDAO {

    public List<Client> findAll() throws SQLException {
        List<Client> clients = new ArrayList<>();
        String sql = "SELECT * FROM CLIENT ORDER BY idclt";

        System.out.println("=== ClientDAO.findAll() ===");

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Client client = new Client();
                client.setIdclt(rs.getInt("idclt"));
                client.setNom(rs.getString("nom"));
                client.setNumtel(rs.getString("numtel"));
                clients.add(client);
                System.out.println("  Client trouvé: ID=" + client.getIdclt() +
                        ", Nom=" + client.getNom() +
                        ", Tél=" + client.getNumtel());
            }
            System.out.println("Total clients trouvés: " + clients.size());
        } catch (SQLException e) {
            System.err.println("Erreur SQL dans findAll(): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return clients;
    }

    public void create(Client client) throws SQLException {
        String sql = "INSERT INTO CLIENT (nom, numtel) VALUES (?, ?)";

        System.out.println("=== ClientDAO.create() ===");
        System.out.println("  Nom: " + client.getNom());
        System.out.println("  Tél: " + client.getNumtel());

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, client.getNom());
            pstmt.setString(2, client.getNumtel());
            int affectedRows = pstmt.executeUpdate();
            System.out.println("  Lignes affectées: " + affectedRows);

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    client.setIdclt(rs.getInt(1));
                    System.out.println("  ID généré: " + client.getIdclt());
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL dans create(): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public Client findById(int id) throws SQLException {
        String sql = "SELECT * FROM CLIENT WHERE idclt = ?";

        System.out.println("=== ClientDAO.findById(" + id + ") ===");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Client client = new Client();
                    client.setIdclt(rs.getInt("idclt"));
                    client.setNom(rs.getString("nom"));
                    client.setNumtel(rs.getString("numtel"));
                    System.out.println("  Client trouvé: " + client.getNom());
                    return client;
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL dans findById(): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        System.out.println("  Aucun client trouvé avec l'ID: " + id);
        return null;
    }

    public List<Client> searchByNomOrTel(String keyword) throws SQLException {
        List<Client> clients = new ArrayList<>();
        String sql = "SELECT * FROM CLIENT WHERE nom LIKE ? OR numtel LIKE ? ORDER BY nom";

        System.out.println("=== ClientDAO.searchByNomOrTel('" + keyword + "') ===");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Client client = new Client();
                    client.setIdclt(rs.getInt("idclt"));
                    client.setNom(rs.getString("nom"));
                    client.setNumtel(rs.getString("numtel"));
                    clients.add(client);
                    System.out.println("  Résultat recherche: " + client.getNom());
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL dans searchByNomOrTel(): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        System.out.println("Total résultats: " + clients.size());
        return clients;
    }

    public void update(Client client) throws SQLException {
        String sql = "UPDATE CLIENT SET nom = ?, numtel = ? WHERE idclt = ?";

        System.out.println("=== ClientDAO.update() ===");
        System.out.println("  ID: " + client.getIdclt());
        System.out.println("  Nom: " + client.getNom());
        System.out.println("  Tél: " + client.getNumtel());

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, client.getNom());
            pstmt.setString(2, client.getNumtel());
            pstmt.setInt(3, client.getIdclt());
            int affectedRows = pstmt.executeUpdate();
            System.out.println("  Lignes affectées: " + affectedRows);
        } catch (SQLException e) {
            System.err.println("Erreur SQL dans update(): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM CLIENT WHERE idclt = ?";

        System.out.println("=== ClientDAO.delete(" + id + ") ===");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            int affectedRows = pstmt.executeUpdate();
            System.out.println("  Lignes affectées: " + affectedRows);
        } catch (SQLException e) {
            System.err.println("Erreur SQL dans delete(): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }
}