<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contact - Support</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="container">
    <h1>Contactez-nous</h1>
    <a href="index.jsp" class="btn">Retour</a>

    <div class="contact-container">
        <div class="contact-info">
            <h2>Coopérative de Transport</h2>
            <div class="info-item">
                <strong>📞 Téléphone:</strong> +261 34 00 000 00
            </div>
            <div class="info-item">
                <strong>✉️ Email:</strong> contact@cooperative-transport.mg
            </div>
            <div class="info-item">
                <strong>📍 Adresse:</strong> Antananarivo, Madagascar
            </div>
            <div class="info-item">
                <strong>🕒 Heures d'ouverture:</strong>
                <br>Lundi - Vendredi: 8h00 - 17h00
                <br>Samedi: 9h00 - 13h00
                <br>Dimanche: Fermé
            </div>
        </div>

        <div class="contact-form">
            <h2>Formulaire de contact</h2>
            <form action="envoyerMessage" method="post">
                <div class="form-group">
                    <label>Nom complet:</label>
                    <input type="text" name="nom" required>
                </div>
                <div class="form-group">
                    <label>Email:</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Téléphone:</label>
                    <input type="tel" name="telephone">
                </div>
                <div class="form-group">
                    <label>Sujet:</label>
                    <select name="sujet" required>
                        <option value="">Choisir un sujet</option>
                        <option value="reservation">Problème de réservation</option>
                        <option value="paiement">Question sur paiement</option>
                        <option value="technique">Problème technique</option>
                        <option value="autre">Autre</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Message:</label>
                    <textarea name="message" rows="5" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">Envoyer le message</button>
            </form>
        </div>
    </div>

    <div class="map-container">
        <h2>Notre localisation</h2>
        <iframe
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d38491.30331518331!2d47.500000!3d-18.900000!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zMTjCsDU0JzAwLjAiUyA0N8KwMzAnMDAuMCJF!5e0!3m2!1sfr!2smg!4v1641234567890!5m2!1sfr!2smg"
                width="100%"
                height="300"
                style="border:0; border-radius: 10px;"
                allowfullscreen=""
                loading="lazy">
        </iframe>
    </div>
</div>

<style>
    .contact-container {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 30px;
        margin: 30px 0;
    }
    .contact-info, .contact-form {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 10px;
    }
    .info-item {
        margin: 15px 0;
        padding: 10px;
        background: white;
        border-radius: 5px;
    }
    textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 5px;
        resize: vertical;
    }
    .map-container {
        margin-top: 30px;
    }
    .map-container h2 {
        margin-bottom: 15px;
    }
    @media (max-width: 768px) {
        .contact-container {
            grid-template-columns: 1fr;
        }
    }
</style>
</body>
</html>
