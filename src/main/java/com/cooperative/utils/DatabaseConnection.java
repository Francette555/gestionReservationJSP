package com.cooperative.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/cooperative_reservation?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String USERNAME = "root";
    private static final String PASSWORD = ""; // Laissez vide si pas de mot de passe

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("✓ Connexion MySQL établie avec succès");
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("✗ Driver MySQL non trouvé!");
            e.printStackTrace();
            throw new SQLException("Driver MySQL non trouvé! Assurez-vous que mysql-connector-java.jar est dans le classpath", e);
        } catch (SQLException e) {
            System.err.println("✗ Erreur de connexion à MySQL: " + e.getMessage());
            e.printStackTrace();
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
            return true;
        } catch (SQLException e) {
            System.err.println("✗ Test échoué: " + e.getMessage());
            return false;
        }
    }
}