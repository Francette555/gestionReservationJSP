<!--<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Paiements - Coopérative de Transport</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', sans-serif; background: #f0f2f5; padding: 20px; }
        .container { max-width: 1400px; margin: 0 auto; }
        .header { background: linear-gradient(135deg, #1a1a2e 0%, #16213e 100%); color: white; padding: 25px; border-radius: 15px; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; }
        .header a { color: white; text-decoration: none; }
        .filters { background: white; padding: 20px; border-radius: 15px; margin-bottom: 25px; display: flex; gap: 15px; flex-wrap: wrap; align-items: flex-end; }
        .filter-group { flex: 1; min-width: 180px; }
        .filter-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #555; }
        .filter-group select { width: 100%; padding: 10px; border: 2px solid #e0e0e0; border-radius: 8px; }
        .btn { padding: 10px 25px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-secondary { background: #6c757d; color: white; text-decoration: none; display: inline-block; text-align: center; }
        .table-container { background: white; border-radius: 15px; overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #1a1a2e; color: white; padding: 15px; text-align: left; }
        td { padding: 12px 15px; border-bottom: 1px solid #e0e0e0; }
        .badge-paid { background: #28a745; color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .badge-partial { background: #ffc107; color: #333; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .badge-pending { background: #dc3545; color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .info-text { text-align: center; padding: 40px; color: #666; font-style: italic; }
        .alert-info { background-color: #d1ecf1; color: #0c5460; padding: 15px; border-radius: 8px; margin-bottom: 15px; }
        .result-stats { background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; padding: 15px; border-radius: 10px; margin-bottom: 20px; text-align: center; }
        .result-stats .nombre { font-size: 2em; font-weight: bold; }
        .btn-small { padding: 5px 12px; font-size: 12px; background: #667eea; color: white; border: none; border-radius: 5px; cursor: pointer; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <div><h1>💰 Gestion des Paiements</h1></div>
        <div><a href="${pageContext.request.contextPath}/">🏠 Retour à l'accueil</a></div>
    </div>


    <c:if test="${not empty error}">
        <div class="alert-info" style="background:#f8d7da; color:#721c24;">❌ ${error}</div>
    </c:if>


    <c:if test="${not empty reservations and not empty selectedVoiture}">
        <div class="result-stats">
            <c:choose>
                <c:when test="${typePaiement == 'tout paye'}"><h3>✅ VOYAGEURS QUI ONT TOUT PAYÉ</h3></c:when>
                <c:when test="${typePaiement == 'avec avance'}"><h3>💵 VOYAGEURS QUI ONT PAYÉ UNE AVANCE</h3></c:when>
                <c:when test="${typePaiement == 'sans avance'}"><h3>⏳ VOYAGEURS QUI N'ONT PAS ENCORE PAYÉ</h3></c:when>
            </c:choose>
            <p>Nombre de voyageurs : <span class="nombre">${reservations.size()}</span></p>
        </div>
    </c:if>


    <div class="filters">
        <form action="${pageContext.request.contextPath}/paiement/paiement" method="post" style="display: flex; gap: 15px; flex-wrap: wrap; width: 100%;">
            <div class="filter-group">
                <label>🚗 Choisir une voiture</label>
                <select name="idvoit" required>
                    <option value="">Sélectionner une voiture</option>
                    <c:forEach var="voiture" items="${voitures}">
                        <option value="${voiture.idvoit}" ${selectedVoiture.idvoit == voiture.idvoit ? 'selected' : ''}>
                                ${voiture.idvoit} - ${voiture.design} (${voiture.type})
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="filter-group">
                <label>📊 Statut de paiement</label>
                <select name="typePaiement" required>
                    <option value="">Sélectionner un statut</option>
                    <option value="tout paye" ${typePaiement == 'tout paye' ? 'selected' : ''}>✅ Tout payé</option>
                    <option value="avec avance" ${typePaiement == 'avec avance' ? 'selected' : ''}>💵 Avec avance</option>
                    <option value="sans avance" ${typePaiement == 'sans avance' ? 'selected' : ''}>⏳ Sans avance</option>
                </select>
            </div>
            <div class="filter-group">
                <button type="submit" class="btn btn-primary">🔍 Rechercher</button>
                <a href="${pageContext.request.contextPath}/paiement/paiement" class="btn btn-secondary">🔄 Réinitialiser</a>
            </div>
        </form>
    </div>


    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>N° Réservation</th>
                <th>Client</th>
                <th>Contact</th>
                <th>Voiture</th>
                <th>Place</th>
                <th>Date voyage</th>
                <th>Frais</th>
                <th>Paiement</th>
                <th>Avance</th>
                <th>Reste</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${not empty reservations}">
                    <c:forEach var="r" items="${reservations}">
                        <tr>
                            <td><strong>${r.idreserv}</strong></td>
                            <td>${r.nomClient}</td>
                            <td>${r.numtel}</td>
                            <td>${r.idvoit} - ${r.designVoiture}</td>
                            <td>${r.place}</td>
                            <td>${r.dateVoyage}</td>
                            <td><fmt:formatNumber value="${r.frais}" type="number" groupingUsed="true"/> Ar</td>
                            <td>
                                <c:choose>
                                    <c:when test="${r.payement == 'tout paye'}"><span class="badge-paid">✓ Tout payé</span></c:when>
                                    <c:when test="${r.payement == 'avec avance'}"><span class="badge-partial">💵 Avec avance</span></c:when>
                                    <c:otherwise><span class="badge-pending">⏳ Sans avance</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td><fmt:formatNumber value="${r.montantAvance}" type="number" groupingUsed="true"/> Ar</td>
                            <td><strong><fmt:formatNumber value="${r.frais - r.montantAvance}" type="number" groupingUsed="true"/> Ar</strong></td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr><td colspan="10" class="info-text">📋 Sélectionnez une voiture et un statut de paiement</td></tr>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>-->



<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Paiements - Coopérative de Transport</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            overflow-x: hidden;
        }

        .app-container {
            display: flex;
            min-height: 100vh;
        }

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

        .sidebar-header .logo { font-size: 2.5em; margin-bottom: 10px; }
        .sidebar-header h3 { font-size: 1.2em; font-weight: 600; }
        .sidebar-header p { font-size: 0.8em; opacity: 0.7; margin-top: 5px; }

        .nav-section { margin-bottom: 20px; }
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

        .nav-item .icon { font-size: 1.2em; width: 24px; }

        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 20px;
        }

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

        .page-title { text-align: center; flex: 1; }
        .page-title h1 { color: #1a1a2e; font-size: 1.8em; margin-bottom: 5px; }
        .page-title p { color: #666; font-size: 0.9em; }

        .date-time { text-align: right; color: #667eea; font-weight: 500; }
        .date-time .date { font-size: 0.85em; }
        .date-time .time { font-size: 1.1em; font-weight: 600; }

        .container { max-width: 1400px; margin: 0 auto; }

        .filters {
            background: white;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 25px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: flex-end;
        }

        .filter-group { flex: 1; min-width: 180px; }
        .filter-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #555; }
        .filter-group select, .filter-group input {
            width: 100%;
            padding: 10px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
        }
        .filter-group select:focus { outline: none; border-color: #667eea; }

        .btn {
            display: inline-block;
            padding: 10px 25px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
        }

        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-primary:hover { transform: translateY(-2px); }
        .btn-secondary { background: #6c757d; color: white; }

        .table-container {
            background: white;
            border-radius: 15px;
            overflow-x: auto;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        table { width: 100%; border-collapse: collapse; }
        th { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 15px; text-align: left; }
        td { padding: 12px 15px; border-bottom: 1px solid #e0e0e0; }

        .badge-paid { background: #28a745; color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .badge-partial { background: #ffc107; color: #333; padding: 4px 12px; border-radius: 20px; font-size: 12px; }
        .badge-pending { background: #dc3545; color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px; }

        .info-text { text-align: center; padding: 40px; color: #666; font-style: italic; }
        .alert-info {
            background-color: #d1ecf1;
            color: #0c5460;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .result-stats {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            text-align: center;
        }

        .result-stats .nombre { font-size: 2em; font-weight: bold; }

        .footer {
            margin-top: 40px;
            text-align: center;
            padding: 20px;
            color: #666;
            background: white;
            border-radius: 12px;
        }

        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                position: fixed;
                z-index: 1000;
            }
            .sidebar.open { transform: translateX(0); }
            .main-content { margin-left: 0; }
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
            .menu-toggle { display: none; }
        }

        .sidebar::-webkit-scrollbar { width: 5px; }
        .sidebar::-webkit-scrollbar-track { background: rgba(255,255,255,0.1); }
        .sidebar::-webkit-scrollbar-thumb { background: #667eea; border-radius: 5px; }
    </style>
</head>
<body>
<div class="app-container">
    <button class="menu-toggle" id="menuToggle">☰ Menu</button>

    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <div class="logo">🚌</div>
            <h3>Coopérative Transport</h3>
            <p>Gestion de Réservation</p>
        </div>

        <div class="nav-section">
            <div class="nav-title">Menu Principal</div>
            <a href="${pageContext.request.contextPath}/" class="nav-item">
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
            <a href="${pageContext.request.contextPath}/paiement/paiement" class="nav-item active">
                <span class="icon">💰</span>
                <span>Paiements</span>
            </a>
        </div>
    </div>

    <div class="main-content">
        <div class="top-header">
            <div></div>
            <div class="page-title">
                <h1>💰 Gestion des Paiements</h1>
                <p>Suivez les paiements de vos voyageurs</p>
            </div>
            <div class="date-time">
                <div class="date" id="currentDate"></div>
                <div class="time" id="currentTime"></div>
            </div>
        </div>

        <div class="container">
            <c:if test="${not empty error}">
                <div class="alert-info" style="background:#f8d7da; color:#721c24;">❌ ${error}</div>
            </c:if>

            <c:if test="${not empty reservations and not empty selectedVoiture}">
                <div class="result-stats">
                    <c:choose>
                        <c:when test="${typePaiement == 'tout paye'}"><h3>✅ VOYAGEURS QUI ONT TOUT PAYÉ</h3></c:when>
                        <c:when test="${typePaiement == 'avec avance'}"><h3>💵 VOYAGEURS QUI ONT PAYÉ UNE AVANCE</h3></c:when>
                        <c:when test="${typePaiement == 'sans avance'}"><h3>⏳ VOYAGEURS QUI N'ONT PAS ENCORE PAYÉ</h3></c:when>
                    </c:choose>
                    <p>Nombre de voyageurs : <span class="nombre">${reservations.size()}</span></p>
                </div>
            </c:if>

            <div class="filters">
                <form action="${pageContext.request.contextPath}/paiement/paiement" method="post" style="display: flex; gap: 15px; flex-wrap: wrap; width: 100%;">
                    <div class="filter-group">
                        <label>🚗 Choisir une voiture</label>
                        <select name="idvoit" required>
                            <option value="">Sélectionner une voiture</option>
                            <c:forEach var="voiture" items="${voitures}">
                                <option value="${voiture.idvoit}" ${selectedVoiture.idvoit == voiture.idvoit ? 'selected' : ''}>
                                        ${voiture.idvoit} - ${voiture.design} (${voiture.type})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label>📊 Statut de paiement</label>
                        <select name="typePaiement" required>
                            <option value="">Sélectionner un statut</option>
                            <option value="tout paye" ${typePaiement == 'tout paye' ? 'selected' : ''}>✅ Tout payé</option>
                            <option value="avec avance" ${typePaiement == 'avec avance' ? 'selected' : ''}>💵 Avec avance</option>
                            <option value="sans avance" ${typePaiement == 'sans avance' ? 'selected' : ''}>⏳ Sans avance</option>
                        </select>
                    </div>
                    <div class="filter-group">
                        <button type="submit" class="btn btn-primary">🔍 Rechercher</button>
                        <a href="${pageContext.request.contextPath}/paiement/paiement" class="btn btn-secondary">🔄 Réinitialiser</a>
                    </div>
                </form>
            </div>

            <div class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>N° Réservation</th>
                        <th>Client</th>
                        <th>Contact</th>
                        <th>Voiture</th>
                        <th>Place</th>
                        <th>Date voyage</th>
                        <th>Frais</th>
                        <th>Paiement</th>
                        <th>Avance</th>
                        <th>Reste</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${not empty reservations}">
                            <c:forEach var="r" items="${reservations}">
                                <tr>
                                    <td><strong>${r.idreserv}</strong></td>
                                    <td>${r.nomClient}</td>
                                    <td>${r.numtel}</td>
                                    <td>${r.idvoit} - ${r.designVoiture}</td>
                                    <td>${r.place}</td>
                                    <td>${r.dateVoyage}</td>
                                    <td><fmt:formatNumber value="${r.frais}" type="number" groupingUsed="true"/> Ar</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${r.payement == 'tout paye'}"><span class="badge-paid">✓ Tout payé</span></c:when>
                                            <c:when test="${r.payement == 'avec avance'}"><span class="badge-partial">💵 Avec avance</span></c:when>
                                            <c:otherwise><span class="badge-pending">⏳ Sans avance</span></c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatNumber value="${r.montantAvance}" type="number" groupingUsed="true"/> Ar</td>
                                    <td><strong><fmt:formatNumber value="${r.frais - r.montantAvance}" type="number" groupingUsed="true"/> Ar</strong></td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr><td colspan="10" class="info-text">📋 Sélectionnez une voiture et un statut de paiement</td></tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="footer">
            <p>© 2026 - Coopérative de Transport | Application de Gestion de Réservation</p>
            <p>Tous droits réservés</p>
        </div>
    </div>
</div>

<script>
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

    function initMobileMenu() {
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        if (menuToggle && sidebar) {
            menuToggle.addEventListener('click', function() { sidebar.classList.toggle('open'); });
            document.addEventListener('click', function(event) {
                const isClickInside = sidebar.contains(event.target) || menuToggle.contains(event.target);
                if (!isClickInside && window.innerWidth <= 768) sidebar.classList.remove('open');
            });
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        updateDateTime();
        initMobileMenu();
        setInterval(updateDateTime, 1000);
    });
</script>
</body>
</html>