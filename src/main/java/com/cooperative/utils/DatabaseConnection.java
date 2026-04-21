package com.cooperative.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    // Changez ces paramètres selon votre configuration
    private static final String URL = "jdbc:mysql://localhost:3306/cooperative_reservation?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";  // Mettez votre mot de passe MySQL ici si vous en avez un

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✓ Driver MySQL chargé avec succès");
        } catch (ClassNotFoundException e) {
            System.err.println("✗ Driver MySQL non trouvé!");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("✓ Connexion MySQL établie avec succès");
            return conn;
        } catch (SQLException e) {
            System.err.println("✗ Erreur de connexion à MySQL: " + e.getMessage());
            System.err.println("  URL: " + URL);
            System.err.println("  User: " + USERNAME);
            throw e;
        }
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                System.out.println("✓ Connexion MySQL fermée");
            } catch (SQLException e) {
                System.err.println("Erreur lors de la fermeture: " + e.getMessage());
            }
        }
    }

    public static boolean testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("✓ Test réussi! Connecté à: " + conn.getMetaData().getURL());
            System.out.println("  Base de données: " + conn.getCatalog());
            return true;
        } catch (SQLException e) {
            System.err.println("✗ Test échoué: " + e.getMessage());
            return false;
        }
    }
}