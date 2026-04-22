package com.cooperative.dao;

import com.cooperative.model.Voiture;
import com.cooperative.utils.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoitureDAO {

    public void create(Voiture voiture) throws SQLException {
        String sql = "INSERT INTO VOITURE (idvoit, Design, type, nbrplace, frais) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, voiture.getIdvoit());
            pstmt.setString(2, voiture.getDesign());
            pstmt.setString(3, voiture.getType());
            pstmt.setInt(4, voiture.getNbrplace());
            pstmt.setInt(5, voiture.getFrais());
            pstmt.executeUpdate();

            // Créer les places pour cette voiture
            createPlaces(voiture.getIdvoit(), voiture.getNbrplace());
        }
    }

    private void createPlaces(String idvoit, int nbrplace) throws SQLException {
        String sql = "INSERT INTO PLACE (idvoit, place, occupation) VALUES (?, ?, 'non')";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            for (int i = 1; i <= nbrplace; i++) {
                pstmt.setString(1, idvoit);
                pstmt.setInt(2, i);
                pstmt.addBatch();
            }
            pstmt.executeBatch();
        }
    }

    public List<Voiture> findAll() throws SQLException {
        List<Voiture> voitures = new ArrayList<>();
        String sql = "SELECT * FROM VOITURE ORDER BY idvoit";

        System.out.println("=== VoitureDAO.findAll() ===");

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Voiture v = new Voiture();
                v.setIdvoit(rs.getString("idvoit"));
                v.setDesign(rs.getString("Design"));
                v.setType(rs.getString("type"));
                v.setNbrplace(rs.getInt("nbrplace"));
                v.setFrais(rs.getInt("frais"));
                voitures.add(v);
                System.out.println("  Voiture trouvée: " + v.getIdvoit() + " - " + v.getDesign());
            }
            System.out.println("Total voitures: " + voitures.size());
        }
        return voitures;
    }

    public Voiture findById(String id) throws SQLException {
        String sql = "SELECT * FROM VOITURE WHERE idvoit = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Voiture v = new Voiture();
                    v.setIdvoit(rs.getString("idvoit"));
                    v.setDesign(rs.getString("Design"));
                    v.setType(rs.getString("type"));
                    v.setNbrplace(rs.getInt("nbrplace"));
                    v.setFrais(rs.getInt("frais"));
                    return v;
                }
            }
        }
        return null;
    }

    public List<Voiture> searchByDesign(String keyword) throws SQLException {
        List<Voiture> voitures = new ArrayList<>();
        String sql = "SELECT * FROM VOITURE WHERE Design LIKE ? ORDER BY Design";

        System.out.println("=== VoitureDAO.searchByDesign('" + keyword + "') ===");

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, "%" + keyword + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Voiture v = new Voiture();
                    v.setIdvoit(rs.getString("idvoit"));
                    v.setDesign(rs.getString("Design"));
                    v.setType(rs.getString("type"));
                    v.setNbrplace(rs.getInt("nbrplace"));
                    v.setFrais(rs.getInt("frais"));
                    voitures.add(v);
                    System.out.println("  Résultat recherche: " + v.getDesign());
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL dans searchByDesign(): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        System.out.println("Total résultats: " + voitures.size());
        return voitures;
    }

    public void update(Voiture voiture) throws SQLException {
        String sql = "UPDATE VOITURE SET Design=?, type=?, nbrplace=?, frais=? WHERE idvoit=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, voiture.getDesign());
            pstmt.setString(2, voiture.getType());
            pstmt.setInt(3, voiture.getNbrplace());
            pstmt.setInt(4, voiture.getFrais());
            pstmt.setString(5, voiture.getIdvoit());
            pstmt.executeUpdate();
        }
    }

    public void delete(String id) throws SQLException {
        String sql = "DELETE FROM VOITURE WHERE idvoit=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, id);
            pstmt.executeUpdate();
        }
    }
}