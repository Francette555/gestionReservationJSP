/*package com.cooperative.dao;

import com.cooperative.model.Reservation;
import com.cooperative.utils.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    // CREATE - Ajouter une réservation
    /*public void create(Reservation reservation) throws SQLException {
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
    }*/

    // 🔥 NOUVELLE VERSION DE CREATE
   /* public boolean create(Reservation reservation) throws SQLException {

        // Vérifier si place libre
        List<Integer> placesLibres = getPlacesLibres(reservation.getIdvoit());

        if (!placesLibres.contains(reservation.getPlace())) {
            return false; // ❌ place déjà occupée
        }

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

            // mettre occupation = oui
            updatePlaceOccupation(reservation.getIdvoit(), reservation.getPlace(), "oui");

            return true;
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

    // Ajoutez cette méthode dans ReservationDAO.java
    public List<Reservation> getVoyageursParPaiement(String idvoit, String typePaiement) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, c.nom as nomClient, c.numtel, v.Design as designVoiture, v.frais " +
                "FROM RESERVER r " +
                "JOIN CLIENT c ON r.idclt = c.idclt " +
                "JOIN VOITURE v ON r.idvoit = v.idvoit " +
                "WHERE r.idvoit = ? AND r.payement = ? " +
                "ORDER BY r.date_reserv DESC";

        System.out.println("=== ReservationDAO.getVoyageursParPaiement() ===");
        System.out.println("idvoit: " + idvoit + ", typePaiement: " + typePaiement);

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, idvoit);
            pstmt.setString(2, typePaiement);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setIdreserv(rs.getString("idreserv"));
                    r.setIdvoit(rs.getString("idvoit"));
                    r.setIdclt(rs.getInt("idclt"));
                    r.setPlace(rs.getInt("place"));
                    r.setDateReserv(rs.getTimestamp("date_reserv"));
                    r.setDateVoyage(rs.getDate("date_voyage"));
                    r.setPayement(rs.getString("payement"));
                    r.setMontantAvance(rs.getInt("montant_avance"));
                    r.setNomClient(rs.getString("nomClient"));
                    r.setNumtel(rs.getString("numtel"));
                    r.setDesignVoiture(rs.getString("designVoiture"));
                    r.setFrais(rs.getInt("frais"));
                    reservations.add(r);
                    System.out.println("  Réservation trouvée: " + r.getIdreserv() + " - " + r.getNomClient());
                }
            }
        } catch (SQLException e) {
            System.err.println("Erreur SQL dans getVoyageursParPaiement(): " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        System.out.println("Total réservations: " + reservations.size());
        return reservations;
    }

    // Obtenir les places occupées d'une voiture
    public List<Integer> getPlacesOccupees(String idvoit) throws SQLException {
        List<Integer> placesOccupees = new ArrayList<>();
        String sql = "SELECT place FROM PLACE WHERE idvoit = ? AND occupation = 'oui' ORDER BY place";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, idvoit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    placesOccupees.add(rs.getInt("place"));
                }
            }
        }
        return placesOccupees;
    }
}
*/

package com.cooperative.dao;

import com.cooperative.model.Reservation;
import com.cooperative.model.Voiture;
import com.cooperative.utils.DatabaseConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    // CREATE - Ajouter une réservation
    public boolean create(Reservation reservation) throws SQLException {
        if (!isPlaceLibre(reservation.getIdvoit(), reservation.getPlace(), reservation.getDateVoyage())) {
            return false;
        }

        String sql = "INSERT INTO RESERVER (idreserv, idvoit, idclt, place, date_reserv, date_voyage, payement, montant_avance) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

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

            updatePlaceOccupation(reservation.getIdvoit(), reservation.getPlace(),
                    reservation.getDateVoyage(), "oui", reservation.getIdreserv());
            return true;
        }
    }

    // ✅ MÉTHODE SURCHARGÉE pour compatibilité (sans date)
    public List<Integer> getPlacesLibres(String idvoit) throws SQLException {
        Date defaultDate = Date.valueOf(java.time.LocalDate.now().plusDays(1));
        return getPlacesLibres(idvoit, defaultDate);
    }

    // ✅ MÉTHODE PRINCIPALE avec date
    public List<Integer> getPlacesLibres(String idvoit, Date dateVoyage) throws SQLException {
        List<Integer> placesLibres = new ArrayList<>();

        VoitureDAO voitureDAO = new VoitureDAO();
        Voiture voiture = voitureDAO.findById(idvoit);
        int totalPlaces = (voiture != null) ? voiture.getNbrplace() : 0;

        if (totalPlaces == 0) return placesLibres;

        List<Integer> placesOccupees = getPlacesOccupees(idvoit, dateVoyage);

        for (int i = 1; i <= totalPlaces; i++) {
            if (!placesOccupees.contains(i)) {
                placesLibres.add(i);
            }
        }
        return placesLibres;
    }

    // ✅ MÉTHODE SURCHARGÉE pour compatibilité (sans date)
    public List<Integer> getPlacesOccupees(String idvoit) throws SQLException {
        Date defaultDate = Date.valueOf(java.time.LocalDate.now().plusDays(1));
        return getPlacesOccupees(idvoit, defaultDate);
    }

    // ✅ MÉTHODE PRINCIPALE avec date
    public List<Integer> getPlacesOccupees(String idvoit, Date dateVoyage) throws SQLException {
        List<Integer> placesOccupees = new ArrayList<>();
        String sql = "SELECT place FROM PLACE WHERE idvoit = ? AND date_voyage = ? AND occupation = 'oui' ORDER BY place";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, idvoit);
            pstmt.setDate(2, dateVoyage);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                placesOccupees.add(rs.getInt("place"));
            }
        }
        return placesOccupees;
    }

    // Vérifier si une place est libre pour une date donnée
    public boolean isPlaceLibre(String idvoit, int place, Date dateVoyage) throws SQLException {
        String sql = "SELECT COUNT(*) FROM PLACE WHERE idvoit = ? AND place = ? AND date_voyage = ? AND occupation = 'oui'";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, idvoit);
            pstmt.setInt(2, place);
            pstmt.setDate(3, dateVoyage);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0;
            }
        }
        return true;
    }

    // Mettre à jour l'occupation d'une place pour une date
    private void updatePlaceOccupation(String idvoit, int place, Date dateVoyage, String occupation, String idreserv) throws SQLException {
        String sql = "INSERT INTO PLACE (idvoit, place, date_voyage, occupation, idreserv) "
                + "VALUES (?, ?, ?, ?, ?) "
                + "ON DUPLICATE KEY UPDATE occupation = ?, idreserv = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, idvoit);
            pstmt.setInt(2, place);
            pstmt.setDate(3, dateVoyage);
            pstmt.setString(4, occupation);
            pstmt.setString(5, idreserv);
            pstmt.setString(6, occupation);
            pstmt.setString(7, idreserv);
            pstmt.executeUpdate();
        }
    }

    // UPDATE réservation
    public void update(Reservation reservation) throws SQLException {
        Reservation old = findById(reservation.getIdreserv());

        try (Connection conn = DatabaseConnection.getConnection()) {
            conn.setAutoCommit(false);

            updatePlaceOccupation(old.getIdvoit(), old.getPlace(), old.getDateVoyage(), "non", null);

            if (!isPlaceLibre(reservation.getIdvoit(), reservation.getPlace(), reservation.getDateVoyage())) {
                conn.rollback();
                throw new SQLException("Place déjà occupée pour cette date");
            }

            String sql = "UPDATE RESERVER SET idvoit = ?, idclt = ?, place = ?, date_voyage = ?, payement = ?, montant_avance = ? WHERE idreserv = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, reservation.getIdvoit());
                pstmt.setInt(2, reservation.getIdclt());
                pstmt.setInt(3, reservation.getPlace());
                pstmt.setDate(4, reservation.getDateVoyage());
                pstmt.setString(5, reservation.getPayement());
                pstmt.setInt(6, reservation.getMontantAvance());
                pstmt.setString(7, reservation.getIdreserv());
                pstmt.executeUpdate();
            }

            updatePlaceOccupation(reservation.getIdvoit(), reservation.getPlace(),
                    reservation.getDateVoyage(), "oui", reservation.getIdreserv());
            conn.commit();
        }
    }

    // DELETE réservation
    public void delete(String id) throws SQLException {
        Reservation res = findById(id);
        if (res != null) {
            updatePlaceOccupation(res.getIdvoit(), res.getPlace(), res.getDateVoyage(), "non", null);
        }
        String sql = "DELETE FROM RESERVER WHERE idreserv = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            pstmt.executeUpdate();
        }
    }

    // FIND ALL
    public List<Reservation> findAll() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.*, c.nom as nomClient, c.numtel, v.Design as designVoiture, v.type as typeVoiture, v.frais "
                + "FROM RESERVER r "
                + "JOIN CLIENT c ON r.idclt = c.idclt "
                + "JOIN VOITURE v ON r.idvoit = v.idvoit "
                + "ORDER BY r.date_voyage DESC, r.date_reserv DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(extractReservation(rs));
            }
        }
        return list;
    }

    // FIND BY ID
    public Reservation findById(String id) throws SQLException {
        String sql = "SELECT r.*, c.nom as nomClient, c.numtel, v.Design as designVoiture, v.type as typeVoiture, v.frais "
                + "FROM RESERVER r "
                + "JOIN CLIENT c ON r.idclt = c.idclt "
                + "JOIN VOITURE v ON r.idvoit = v.idvoit "
                + "WHERE r.idreserv = ?";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractReservation(rs);
            }
        }
        return null;
    }

    private Reservation extractReservation(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setIdreserv(rs.getString("idreserv"));
        r.setIdvoit(rs.getString("idvoit"));
        r.setIdclt(rs.getInt("idclt"));
        r.setPlace(rs.getInt("place"));
        r.setDateReserv(rs.getTimestamp("date_reserv"));
        r.setDateVoyage(rs.getDate("date_voyage"));
        r.setPayement(rs.getString("payement"));
        r.setMontantAvance(rs.getInt("montant_avance"));
        r.setNomClient(rs.getString("nomClient"));
        r.setNumtel(rs.getString("numtel"));
        r.setDesignVoiture(rs.getString("designVoiture"));
        r.setTypeVoiture(rs.getString("typeVoiture"));
        r.setFrais(rs.getInt("frais"));
        return r;
    }

    public int getRecetteTotale() throws SQLException {
        String sql = "SELECT COALESCE(SUM(v.frais), 0) as total FROM RESERVER r JOIN VOITURE v ON r.idvoit = v.idvoit";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt("total");
        }
        return 0;
    }

    public List<Reservation> getVoyageursParPaiement(String idvoit, String typePaiement) throws SQLException {
        List<Reservation> reservations = new ArrayList<>();
        String sql = "SELECT r.*, c.nom as nomClient, c.numtel, v.Design as designVoiture, v.type as typeVoiture, v.frais "
                + "FROM RESERVER r "
                + "JOIN CLIENT c ON r.idclt = c.idclt "
                + "JOIN VOITURE v ON r.idvoit = v.idvoit "
                + "WHERE r.idvoit = ? AND r.payement = ? "
                + "ORDER BY r.date_voyage DESC";
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, idvoit);
            pstmt.setString(2, typePaiement);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                reservations.add(extractReservation(rs));
            }
        }
        return reservations;
    }

    // Ajoutez cette méthode dans ReservationDAO.java
    public String getNextReservationId() throws SQLException {
        String sql = "SELECT MAX(idreserv) as max_id FROM RESERVER";
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                String maxId = rs.getString("max_id");
                if (maxId != null && maxId.startsWith("RES")) {
                    int num = Integer.parseInt(maxId.substring(3));
                    int nextNum = num + 1;
                    return String.format("RES%03d", nextNum);
                }
            }
            return "RES001";
        }
    }
}
