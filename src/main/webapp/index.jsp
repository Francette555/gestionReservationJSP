<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accueil - Gestion de Réservation Coopérative</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            overflow-x: hidden;
        }

        /* Layout principal avec menu latéral */
        .app-container {
            display: flex;
            min-height: 100vh;
        }

        /* ========== MENU LATÉRAL ========== */
        .sidebar {
            width: 280px;
            background: linear-gradient(180deg, #1a1a2e 0%, #16213e 100%);
            color: white;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            transition: all 0.3s ease;
            z-index: 100;
            box-shadow: 2px 0 20px rgba(0,0,0,0.1);
        }

        .sidebar-header {
            padding: 25px 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 20px;
        }

        .sidebar-header .logo {
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        .sidebar-header h3 {
            font-size: 1.2em;
            font-weight: 600;
        }

        .sidebar-header p {
            font-size: 0.8em;
            opacity: 0.7;
            margin-top: 5px;
        }

        .nav-section {
            margin-bottom: 20px;
        }

        .nav-title {
            padding: 10px 20px;
            font-size: 0.75em;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: rgba(255,255,255,0.5);
            font-weight: 600;
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 20px;
            color: rgba(255,255,255,0.8);
            text-decoration: none;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
        }

        .nav-item:hover {
            background: rgba(255,255,255,0.1);
            color: white;
            border-left-color: #667eea;
        }

        .nav-item.active {
            background: rgba(102, 126, 234, 0.2);
            border-left-color: #667eea;
            color: white;
        }

        .nav-item .icon {
            font-size: 1.2em;
            width: 24px;
        }

        /* ========== CONTENU PRINCIPAL ========== */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 20px;
        }

        /* En-tête */
        .top-header {
            background: white;
            border-radius: 15px;
            padding: 20px 30px;
            margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .page-title {
            text-align: center;
            flex: 1;
        }

        .page-title h1 {
            color: #1a1a2e;
            font-size: 1.8em;
            margin-bottom: 5px;
        }

        .page-title p {
            color: #666;
            font-size: 0.9em;
        }

        .date-time {
            text-align: right;
            color: #667eea;
            font-weight: 500;
        }

        .date-time .date {
            font-size: 0.85em;
        }

        .date-time .time {
            font-size: 1.1em;
            font-weight: 600;
        }

        /* Cartes statistiques */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            cursor: pointer;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .stat-icon {
            width: 55px;
            height: 55px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8em;
            color: white;
        }

        .stat-info {
            flex: 1;
        }

        .stat-number {
            font-size: 1.8em;
            font-weight: bold;
            color: #1a1a2e;
        }

        .stat-label {
            color: #666;
            font-size: 0.85em;
        }

        /* Message de bienvenue au centre */
        .welcome-message {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            padding: 50px;
            text-align: center;
            margin-bottom: 30px;
            color: white;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .welcome-message h2 {
            font-size: 2em;
            margin-bottom: 15px;
        }

        .welcome-message p {
            font-size: 1.1em;
            opacity: 0.95;
            max-width: 600px;
            margin: 0 auto;
        }

        .welcome-message .emoji {
            font-size: 3em;
            margin-bottom: 15px;
        }

        /* Section raccourcis */
        .shortcuts {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 30px;
        }

        .shortcut-btn {
            background: white;
            padding: 15px;
            border-radius: 12px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            color: #333;
        }

        .shortcut-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .shortcut-btn .shortcut-icon {
            font-size: 1.5em;
        }

        /* Footer */
        .footer {
            margin-top: 40px;
            text-align: center;
            padding: 20px;
            color: #666;
            background: white;
            border-radius: 12px;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                position: fixed;
                z-index: 1000;
            }

            .sidebar.open {
                transform: translateX(0);
            }

            .main-content {
                margin-left: 0;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .top-header {
                flex-direction: column;
                text-align: center;
            }

            .date-time {
                text-align: center;
            }

            .menu-toggle {
                display: block;
                position: fixed;
                top: 20px;
                left: 20px;
                z-index: 1001;
                background: #667eea;
                color: white;
                border: none;
                padding: 10px 15px;
                border-radius: 8px;
                cursor: pointer;
            }
        }

        @media (min-width: 769px) {
            .menu-toggle {
                display: none;
            }
        }

        /* Scrollbar personnalisée */
        .sidebar::-webkit-scrollbar {
            width: 5px;
        }

        .sidebar::-webkit-scrollbar-track {
            background: rgba(255,255,255,0.1);
        }

        .sidebar::-webkit-scrollbar-thumb {
            background: #667eea;
            border-radius: 5px;
        }

        /* Animation de chargement */
        .loading {
            display: inline-block;
            width: 24px;
            height: 24px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #667eea;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
<div class="app-container">
    <!-- Bouton menu mobile -->
    <button class="menu-toggle" id="menuToggle">☰ Menu</button>

    <!-- Menu latéral simplifié -->
    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="logo">🚌</div>
            <h3>Coopérative Transport</h3>
            <p>Gestion de Réservation</p>
        </div>

        <!-- Navigation par section - UN SEUL LIEN PAR SECTION -->
        <div class="nav-section">
            <div class="nav-title">Menu Principal</div>
            <a href="${pageContext.request.contextPath}/" class="nav-item active">
                <span class="icon">📊</span>
                <span>Accueil</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-title">Gestion</div>
            <a href="${pageContext.request.contextPath}/VoitureServlet" class="nav-item">
                <span class="icon">🚗</span>
                <span>Gestion des Voitures</span>
            </a>
            <a href="${pageContext.request.contextPath}/ClientServlet" class="nav-item">
                <span class="icon">👥</span>
                <span>Gestion des Clients</span>
            </a>
            <a href="${pageContext.request.contextPath}/ReservationServlet" class="nav-item">
                <span class="icon">📅</span>
                <span>Gestion des Réservations</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-title">Finances</div>
            <a href="${pageContext.request.contextPath}/paiement/paiement" class="nav-item">
                <span class="icon">💰</span>
                <span>Paiements</span>
            </a>


        </div>

       <!-- <div class="nav-section">
            <div class="nav-title">Statistiques</div>
            <a href="${pageContext.request.contextPath}/RecetteServlet" class="nav-item">
                <span class="icon">📈</span>
                <span>Statistiques</span>
            </a>
        </div>

        <div class="nav-section">
            <div class="nav-title">Support</div>
            <a href="${pageContext.request.contextPath}/contact.jsp" class="nav-item">
                <span class="icon">📧</span>
                <span>Contact</span>
            </a>
        </div>-->
    </div>

    <!-- Contenu principal -->
    <div class="main-content">
        <!-- En-tête avec titre centré -->
        <div class="top-header">
            <div></div>
            <div class="page-title">
                <h1>🚌 Coopérative de Transport</h1>
                <p>Système intégré de gestion des réservations</p>
            </div>
            <div class="date-time">
                <div class="date" id="currentDate"></div>
                <div class="time" id="currentTime"></div>
            </div>
        </div>

        <!-- Message de bienvenue centré -->
        <div class="welcome-message">
            <div class="emoji">🎉</div>
            <h2>Bienvenue sur votre espace de gestion</h2>
            <p>Gérez efficacement vos véhicules, vos clients et vos réservations depuis une interface unique et intuitive.</p>
        </div>

        <!-- Cartes statistiques -->
        <div class="stats-grid">
            <div class="stat-card" onclick="location.href='${pageContext.request.contextPath}/voiture/voiture.jsp'">
                <div class="stat-icon">🚗</div>
                <div class="stat-info">
                    <div class="stat-number" id="nbVoitures">
                        <span class="loading"></span>
                    </div>
                    <div class="stat-label">Voitures enregistrées</div>
                </div>
            </div>
            <div class="stat-card" onclick="location.href='${pageContext.request.contextPath}/client/client.jsp'">
                <div class="stat-icon">👥</div>
                <div class="stat-info">
                    <div class="stat-number" id="nbClients">
                        <span class="loading"></span>
                    </div>
                    <div class="stat-label">Clients fidèles</div>
                </div>
            </div>
            <div class="stat-card" onclick="location.href='${pageContext.request.contextPath}/reservation/reservation.jsp'">
                <div class="stat-icon">📅</div>
                <div class="stat-info">
                    <div class="stat-number" id="nbReservations">
                        <span class="loading"></span>
                    </div>
                    <div class="stat-label">Réservations effectuées</div>
                </div>
            </div>
            <div class="stat-card" onclick="location.href='${pageContext.request.contextPath}/paiement/paiement.jsp'">
                <div class="stat-icon">💰</div>
                <div class="stat-info">
                    <div class="stat-number" id="totalRecette">
                        <span class="loading"></span>
                    </div>
                    <div class="stat-label">Recette totale (Ar)</div>
                </div>
            </div>
        </div>

        <!-- Raccourcis rapides -->
        <div class="shortcuts">
            <a href="${pageContext.request.contextPath}/ReservationServlet" class="shortcut-btn">
                <span class="shortcut-icon">➕</span>
                <span>Nouvelle réservation</span>
            </a>
            <a href="${pageContext.request.contextPath}/ClientServlet" class="shortcut-btn">
                <span class="shortcut-icon">👤</span>
                <span>Nouveau client</span>
            </a>
            <a href="${pageContext.request.contextPath}/VoitureServlet" class="shortcut-btn">
                <span class="shortcut-icon">🚗</span>
                <span>Nouvelle voiture</span>
            </a>

        </div>

        <!-- Footer -->
        <div class="footer">
            <p>© 2026 - Coopérative de Transport | Application de Gestion de Réservation</p>
            <p>Tous droits réservés</p>
        </div>
    </div>
</div>

<script>
    // Affichage de la date et heure
    function updateDateTime() {
        const now = new Date();
        const dateElement = document.getElementById('currentDate');
        const timeElement = document.getElementById('currentTime');

        if (dateElement) {
            const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
            dateElement.textContent = now.toLocaleDateString('fr-FR', options);
        }

        if (timeElement) {
            timeElement.textContent = now.toLocaleTimeString('fr-FR');
        }
    }

    // Récupération des statistiques via l'API
    async function loadStats() {
        try {
            // Tentative de récupération via l'API
            const response = await fetch('${pageContext.request.contextPath}/api/stats');

            if (response.ok) {
                const data = await response.json();

                // Mise à jour des éléments
                document.getElementById('nbVoitures').innerHTML = (data.nbVoitures || 0).toLocaleString('fr-FR');
                document.getElementById('nbClients').innerHTML = (data.nbClients || 0).toLocaleString('fr-FR');
                document.getElementById('nbReservations').innerHTML = (data.nbReservations || 0).toLocaleString('fr-FR');
                document.getElementById('totalRecette').innerHTML = (data.totalRecette || 0).toLocaleString('fr-FR') + ' Ar';
            } else {
                // Si l'API n'existe pas, on utilise les données JSP
                useJspData();
            }
        } catch (error) {
            console.error('Erreur API:', error);
            // En cas d'erreur, on utilise les données JSP
            useJspData();
        }
    }

    // Utilisation des données passées par JSP
    function useJspData() {
        <c:if test="${not empty stats}">
        document.getElementById('nbVoitures').innerHTML = '${stats.nbVoitures}';
        document.getElementById('nbClients').innerHTML = '${stats.nbClients}';
        document.getElementById('nbReservations').innerHTML = '${stats.nbReservations}';
        document.getElementById('totalRecette').innerHTML = '${stats.totalRecette} Ar';
        </c:if>

        <c:if test="${empty stats}">
        // Données de démonstration si aucune donnée n'est disponible
        document.getElementById('nbVoitures').innerHTML = '12';
        document.getElementById('nbClients').innerHTML = '45';
        document.getElementById('nbReservations').innerHTML = '128';
        document.getElementById('totalRecette').innerHTML = '2' + '450' + '000 Ar';
        </c:if>
    }

    // Menu mobile
    function initMobileMenu() {
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');

        if (menuToggle && sidebar) {
            menuToggle.addEventListener('click', function() {
                sidebar.classList.toggle('open');
            });

            // Fermer le menu en cliquant à l'extérieur sur mobile
            document.addEventListener('click', function(event) {
                const isClickInside = sidebar.contains(event.target) || menuToggle.contains(event.target);
                if (!isClickInside && window.innerWidth <= 768) {
                    sidebar.classList.remove('open');
                }
            });
        }
    }

    // Initialisation
    document.addEventListener('DOMContentLoaded', function() {
        updateDateTime();
        initMobileMenu();
        loadStats();

        // Mise à jour de l'heure chaque seconde
        setInterval(updateDateTime, 1000);

        // Rafraîchissement des stats toutes les 30 secondes
        setInterval(loadStats, 30000);
    });
</script>
</body>
</html>