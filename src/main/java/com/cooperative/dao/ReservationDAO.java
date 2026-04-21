package com.cooperative.dao;

import com.cooperative.model.Reservation;
import com.cooperative.utils.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    // CREATE - Ajouter une réservation
    public void create(Reservation reservation) throws SQLException {
        String sql = "INSERT INTO RESERVER (idreserv, idvoit, idclt, place, date_reserv, date_voyage, payement, montant_avance) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reservation.getIdreserv());
            pstmt.setString(2, reservation.getIdvoit());
            pstmt.setInt(3, reservation.getIdclt());
            pstmt.setInt(4, reservation.getPlace());
            pstmt.setTimestamp(5, reservation.getDateReserv());
            pstmt.setDate(6, reservation.getDateVoyage());
            pstmt.setString(7, reservation.getPayement());
            pstmt.setInt(8, reservation.getMontantAvance());
            pstmt.executeUpdate();

            // Mettre à jour l'occupation de la place
            updatePlaceOccupation(reservation.getIdvoit(), reservation.getPlace(), "oui");
        }
    }

    // UPDATE - Modifier une réservation
    public void update(Reservation reservation) throws SQLException {
        String sql = "UPDATE RESERVER SET idvoit = ?, idclt = ?, place = ?, date_voyage = ?, payement = ?, montant_avance = ? WHERE idreserv = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, reservation.getIdvoit());
            pstmt.setInt(2, reservation.getIdclt());
            pstmt.setInt(3, reservation.getPlace());
            pstmt.setDate(4, reservation.getDateVoyage());
            pstmt.setString(5, reservation.getPayement());
            pstmt.setInt(6, reservation.getMontantAvance());
            pstmt.setString(7, reservation.getIdreserv());
            pstmt.executeUpdate();
        }
    }

    // READ ALL - Lister toutes les réservations
    public List<Reservation> findAll() throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, c.nom as nomClient, v.Design as designVoiture, v.frais " +
                "FROM RESERVER r " +
                "JOIN CLIENT c ON r.idclt = c.idclt " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                "ORDER BY r.date_reserv DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                reservations.add(extractReservation(rs));
            }
        }
        return reservations;
    }

    // READ BY ID - Trouver une réservation par ID
    public Reservation findById(String id) throws SQLException {
        String sql = "SELECT r.*, c.nom as nomClient, v.Design as designVoiture, v.frais " +
                "FROM RESERVER r " +
                "JOIN CLIENT c ON r.idclt = c.idclt " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                "WHERE r.idreserv = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return extractReservation(rs);
                }
            }
        }
        return null;
    }

    // DELETE - Supprimer une réservation
    public void delete(String id) throws SQLException {
        // D'abord récupérer la réservation pour libérer la place
        Reservation res = findById(id);
        if (res != null) {
            updatePlaceOccupation(res.getIdvoit(), res.getPlace(), "non");
        }

        String sql = "DELETE FROM RESERVER WHERE idreserv = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, id);
            pstmt.executeUpdate();
        }
    }

    // Mettre à jour l'occupation d'une place
    private void updatePlaceOccupation(String idvoit, int place, String occupation) throws SQLException {
        String sql = "UPDATE PLACE SET occupation = ? WHERE idvoit = ? AND place = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, occupation);
            pstmt.setString(2, idvoit);
            pstmt.setInt(3, place);
            pstmt.executeUpdate();
        }
    }

    // Obtenir les places libres d'une voiture
    public List<Integer> getPlacesLibres(String idvoit) throws SQLException {
        List<Integer> placesLibres = new ArrayList<>();
        String sql = "SELECT place FROM PLACE WHERE idvoit = ? AND occupation = 'non' ORDER BY place";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, idvoit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    placesLibres.add(rs.getInt("place"));
                }
            }
        }
        return placesLibres;
    }

    // Obtenir les voyageurs par type de paiement
    public List<Reservation> getVoyageursParPaiement(String idvoit, String typePaiement) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, c.nom as nomClient, v.Design as designVoiture, v.frais " +
                "FROM RESERVER r " +
                "JOIN CLIENT c ON r.idclt = c.idclt " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                "WHERE r.idvoit = ? AND r.payement = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, idvoit);
            pstmt.setString(2, typePaiement);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(extractReservation(rs));
                }
            }
        }
        return reservations;
    }

    // Recette totale = somme des frais de toutes les réservations
    public int getRecetteTotale() throws SQLException {
        String sql = "SELECT COALESCE(SUM(v.frais), 0) as total FROM RESERVER r " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit";

        System.out.println("=== ReservationDAO.getRecetteTotale() ===");

        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                int total = rs.getInt("total");
                System.out.println("Recette totale: " + total);
                return total;
            }

        } catch (SQLException e) {
            System.err.println("ERREUR SQL dans getRecetteTotale(): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        return 0;
    }



    // Extraire une réservation d'un ResultSet
    private Reservation extractReservation(ResultSet rs) throws SQLException {
        Reservation res = new Reservation();
        res.setIdreserv(rs.getString("idreserv"));
        res.setIdvoit(rs.getString("idvoit"));
        res.setIdclt(rs.getInt("idclt"));
        res.setPlace(rs.getInt("place"));
        res.setDateReserv(rs.getTimestamp("date_reserv"));
        res.setDateVoyage(rs.getDate("date_voyage"));
        res.setPayement(rs.getString("payement"));
        res.setMontantAvance(rs.getInt("montant_avance"));
        res.setNomClient(rs.getString("nomClient"));
        res.setDesignVoiture(rs.getString("designVoiture"));
        res.setFrais(rs.getInt("frais"));
        return res;
    }
}