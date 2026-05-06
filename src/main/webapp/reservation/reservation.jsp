
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Réservations - Transport Voyage</title>
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

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 30px;
            margin-bottom: 30px;
        }

        .card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .card:hover { transform: translateY(-5px); }

        .card-header {
            border-bottom: 3px solid #667eea;
            padding-bottom: 15px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card-header h2 { color: #333; font-size: 1.5em; }
        .card-header .icon { font-size: 1.8em; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; color: #555; font-weight: 500; }
        .form-group input, .form-group select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
        }
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #667eea; }
        .form-group input:disabled { background-color: #f5f5f5; cursor: not-allowed; }

        .btn {
            display: inline-block;
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            margin-right: 10px;
        }

        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-primary:hover { transform: translateY(-2px); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-warning { background: #ffc107; color: #333; }
        .btn-sm { padding: 5px 12px; font-size: 12px; margin: 0 3px; }
        .btn-pdf { background: #dc3545; color: white; }
        .btn-pdf:hover { background: #c82333; }

        .table-responsive { overflow-x: auto; margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; }
        thead { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        th, td { padding: 12px 15px; text-align: left; }
        tbody tr { border-bottom: 1px solid #e0e0e0; }
        tbody tr:hover { background-color: #f8f9fa; }

        .badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 600;
        }
        .badge-paid { background: #28a745; color: white; }
        .badge-partial { background: #ffc107; color: #333; }
        .badge-pending { background: #dc3545; color: white; }

        .alert-info { background-color: #d1ecf1; color: #0c5460; padding: 15px; border-radius: 8px; }
        .alert-success { background-color: #d4edda; color: #155724; padding: 15px; border-radius: 8px; margin-bottom: 15px; }
        .alert-error { background-color: #f8d7da; color: #721c24; padding: 15px; border-radius: 8px; margin-bottom: 15px; }

        .info-text { text-align: center; padding: 20px; color: #666; font-style: italic; }
        .stats { display: flex; gap: 15px; margin-bottom: 20px; flex-wrap: wrap; }
        .stat-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 15px; border-radius: 10px; flex: 1; text-align: center; }
        .stat-card h3 { font-size: 2em; margin-bottom: 5px; }
        .actions { display: flex; gap: 5px; flex-wrap: wrap; }
        .full-width { grid-column: 1 / -1; }

        .places-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(80px, 100px));
            gap: 15px;
            margin-top: 20px;
        }

        .place-libre {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            border: 2px solid #28a745;
            padding: 15px;
            text-align: center;
            border-radius: 10px;
            font-weight: 600;
            transition: transform 0.3s ease;
        }

        .place-libre:hover { transform: scale(1.05); cursor: pointer; }

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
            .grid { grid-template-columns: 1fr; }
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
            .btn-sm { width: 100%; margin: 2px 0; text-align: center; }
            .places-grid { grid-template-columns: repeat(auto-fill, minmax(70px, 80px)); }
        }

        @media (min-width: 769px) {
            .menu-toggle { display: none; }
        }

        .sidebar::-webkit-scrollbar { width: 5px; }
        .sidebar::-webkit-scrollbar-track { background: rgba(255,255,255,0.1); }
        .sidebar::-webkit-scrollbar-thumb { background: #667eea; border-radius: 5px; }

        .loading-spinner { text-align: center; padding: 20px; color: #666; }

        option:disabled {
            background-color: #f8d7da;
            color: #721c24;
        }

        option:not(:disabled) {
            background-color: #d4edda;
            color: #155724;
        }
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
            <a href="${pageContext.request.contextPath}/ReservationServlet" class="nav-item active">
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
    </div>

    <div class="main-content">
        <div class="top-header">
            <div></div>
            <div class="page-title">
                <h1>🚐 Gestion des Réservations</h1>
                <p>Système complet de gestion des réservations de voyages</p>
            </div>
            <div class="date-time">
                <div class="date" id="currentDate"></div>
                <div class="time" id="currentTime"></div>
            </div>
        </div>

        <div class="container">
            <c:if test="${not empty success}">
                <c:choose>
                    <c:when test="${success == 'added'}"><div class="alert-success">✅ Réservation ajoutée avec succès !</div></c:when>
                    <c:when test="${success == 'updated'}"><div class="alert-success">✏️ Réservation modifiée avec succès !</div></c:when>
                    <c:when test="${success == 'deleted'}"><div class="alert-success">🗑️ Réservation supprimée avec succès !</div></c:when>
                </c:choose>
            </c:if>
            <c:if test="${not empty error}"><div class="alert-error">❌ ${error}</div></c:if>

            <div class="grid">
                <div class="card">
                    <div class="card-header">
                        <span class="icon">📝</span>
                        <h2>Nouvelle Réservation</h2>
                    </div>
                    <form action="${pageContext.request.contextPath}/ReservationServlet" method="post" onsubmit="return validateForm()">
                        <input type="hidden" name="action" value="insert">
                        <div class="form-group">
                            <label>👤 Client *</label>
                            <select name="idclt" id="idclt" required>
                                <option value="">Sélectionner un client</option>
                                <c:forEach var="client" items="${clients}">
                                    <option value="${client.idclt}">${client.nom} - ${client.numtel}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>🚗 Voiture *</label>
                            <select name="idvoit" id="idvoit" required onchange="loadPlaces()">
                                <option value="">Sélectionner une voiture</option>
                                <c:forEach var="voiture" items="${voitures}">
                                    <option value="${voiture.idvoit}" data-frais="${voiture.frais}" data-nbrplace="${voiture.nbrplace}">
                                            ${voiture.design} (${voiture.type}) - <fmt:formatNumber value="${voiture.frais}" type="number" groupingUsed="true"/> Ar
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>💺 Place *</label>
                            <select name="place" id="place" required>
                                <option value="">Sélectionner d'abord une voiture</option>
                            </select>
                            <div id="placesLoading" class="loading-spinner" style="display:none;">⏳ Chargement des places...</div>
                            <small>🟢 Vert = Libre | 🔴 Rouge = Occupée</small>
                        </div>
                        <div class="form-group">
                            <label>📅 Date du voyage *</label>
                            <input type="date" name="date_voyage" id="date_voyage" required>
                        </div>
                        <div class="form-group">
                            <label>💰 Frais (Ar)</label>
                            <input type="text" id="frais" readonly disabled value="0 Ar">
                        </div>
                        <div class="form-group">
                            <label>💳 Type de paiement *</label>
                            <select name="payement" id="payement" required onchange="updateMontantAvance()">
                                <option value="">Sélectionner</option>
                                <option value="sans avance">Sans avance</option>
                                <option value="avec avance">Avec avance</option>
                                <option value="tout paye">Tout payé</option>
                            </select>
                        </div>
                        <div class="form-group" id="montantAvanceDiv" style="display:none;">
                            <label>💵 Montant de l'avance (Ar)</label>
                            <input type="number" name="montant_avance" id="montant_avance" value="0" min="0">
                        </div>
                        <button type="submit" class="btn btn-primary">✅ Enregistrer</button>
                        <button type="reset" class="btn btn-secondary" onclick="resetForm()">🗑️ Réinitialiser</button>
                    </form>
                </div>

                <div class="card">
                    <div class="card-header">
                        <span class="icon">✏️</span>
                        <h2>Modifier une Réservation</h2>
                    </div>
                    <c:if test="${not empty reservationToEdit}">
                        <form action="${pageContext.request.contextPath}/ReservationServlet" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="idreserv" value="${reservationToEdit.idreserv}">
                            <div class="form-group">
                                <label>👤 Client *</label>
                                <select name="idclt" required>
                                    <c:forEach var="client" items="${clients}">
                                        <option value="${client.idclt}" ${reservationToEdit.idclt == client.idclt ? 'selected' : ''}>${client.nom} - ${client.numtel}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>🚗 Voiture *</label>
                                <select name="idvoit" id="edit_idvoit" required onchange="loadEditPlaces()">
                                    <c:forEach var="voiture" items="${voitures}">
                                        <option value="${voiture.idvoit}" ${reservationToEdit.idvoit == voiture.idvoit ? 'selected' : ''}>${voiture.design} (${voiture.type})</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>💺 Place *</label>
                                <select name="place" id="edit_place" required>
                                    <option value="">Chargement...</option>
                                </select>
                                <div id="editPlacesLoading" class="loading-spinner" style="display:none;">⏳ Chargement...</div>
                            </div>
                            <div class="form-group">
                                <label>📅 Date du voyage *</label>
                                <input type="date" name="date_voyage" value="${reservationToEdit.dateVoyage}" required>
                            </div>
                            <div class="form-group">
                                <label>💳 Type de paiement *</label>
                                <select name="payement" id="edit_payement" required onchange="updateEditMontantAvance()">
                                    <option value="sans avance" ${reservationToEdit.payement == 'sans avance' ? 'selected' : ''}>Sans avance</option>
                                    <option value="avec avance" ${reservationToEdit.payement == 'avec avance' ? 'selected' : ''}>Avec avance</option>
                                    <option value="tout paye" ${reservationToEdit.payement == 'tout paye' ? 'selected' : ''}>Tout payé</option>
                                </select>
                            </div>
                            <div class="form-group" id="editMontantAvanceDiv" style="display:${reservationToEdit.payement == 'avec avance' || reservationToEdit.payement == 'tout paye' ? 'block' : 'none'};">
                                <label>💵 Montant de l'avance (Ar)</label>
                                <input type="number" name="montant_avance" id="edit_montant_avance" value="${reservationToEdit.montantAvance}" min="0">
                            </div>
                            <button type="submit" class="btn btn-primary">💾 Mettre à jour</button>
                            <a href="${pageContext.request.contextPath}/ReservationServlet" class="btn btn-secondary">Annuler</a>
                        </form>
                    </c:if>
                    <c:if test="${empty reservationToEdit}">
                        <div class="alert-info">ℹ️ Cliquez sur "Modifier" dans la liste</div>
                    </c:if>
                </div>
            </div>

            <div class="card full-width">
                <div class="card-header">
                    <span class="icon">📊</span>
                    <h2>Liste des Réservations</h2>
                </div>
                <div style="margin-bottom: 20px;">
                    <a href="${pageContext.request.contextPath}/ReservationServlet" class="btn btn-primary">🔄 Rafraîchir</a>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">🏠 Retour à l'accueil</a>
                </div>

                <div class="table-responsive">
                    <table>
                        <thead>
                        <tr>
                            <th>🆔 N°</th><th>👤 Client</th><th>🚗 Voiture</th><th>💺 Place</th>
                            <th>📅 Date Réserv</th><th>📅 Date Voyage</th><th>💳 Paiement</th>
                            <th>💵 Avance</th><th>💰 Reste</th><th>⚙️ Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty reservations}">
                                <c:forEach var="reservation" items="${reservations}">
                                    <tr>
                                        <td><strong>${reservation.idreserv}</strong></td>
                                        <td>${reservation.nomClient}</td>
                                        <td>${reservation.designVoiture}</td>
                                        <td>${reservation.place}</td>
                                        <td><fmt:formatDate value="${reservation.dateReserv}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                        <td><fmt:formatDate value="${reservation.dateVoyage}" pattern="dd/MM/yyyy"/></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${reservation.payement == 'sans avance'}"><span class="badge badge-pending">Sans avance</span></c:when>
                                                <c:when test="${reservation.payement == 'avec avance'}"><span class="badge badge-partial">Avec avance</span></c:when>
                                                <c:when test="${reservation.payement == 'tout paye'}"><span class="badge badge-paid">Tout payé</span></c:when>
                                            </c:choose>
                                        </td>
                                        <td><fmt:formatNumber value="${reservation.montantAvance}" type="number" groupingUsed="true"/> Ar</td>
                                        <td><fmt:formatNumber value="${reservation.frais - reservation.montantAvance}" type="number" groupingUsed="true"/> Ar</td>
                                        <td class="actions">
                                            <a href="${pageContext.request.contextPath}/ReservationServlet?action=edit&id=${reservation.idreserv}" class="btn btn-warning btn-sm">✏️ Modifier</a>
                                            <a href="${pageContext.request.contextPath}/ReservationServlet?action=delete&id=${reservation.idreserv}" class="btn btn-danger btn-sm" onclick="return confirm('Supprimer ?')">🗑️ Supprimer</a>
                                            <a href="${pageContext.request.contextPath}/recu/generate?id=${reservation.idreserv}" class="btn btn-pdf btn-sm" target="_blank">📄 Reçu</a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr><td colspan="10" class="info-text">📋 Aucune réservation</td></tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="grid">
                <div class="card">
                    <div class="card-header">
                        <span class="icon">💰</span>
                        <h2>Recette Totale</h2>
                    </div>
                    <div class="stats">
                        <div class="stat-card">
                            <h3>
                                <c:set var="totalRecette" value="0"/>
                                <c:forEach var="reservation" items="${reservations}">
                                    <c:set var="totalRecette" value="${totalRecette + reservation.frais}"/>
                                </c:forEach>
                                <fmt:formatNumber value="${totalRecette}" type="number" groupingUsed="true"/> Ar
                            </h3>
                            <p>Recette totale</p>
                        </div>
                        <div class="stat-card" style="background: linear-gradient(135deg, #28a745, #20c997);">
                            <h3>
                                <c:set var="totalAvance" value="0"/>
                                <c:forEach var="reservation" items="${reservations}">
                                    <c:set var="totalAvance" value="${totalAvance + reservation.montantAvance}"/>
                                </c:forEach>
                                <fmt:formatNumber value="${totalAvance}" type="number" groupingUsed="true"/> Ar
                            </h3>
                            <p>Total avances</p>
                        </div>
                        <div class="stat-card" style="background: linear-gradient(135deg, #17a2b8, #138496);">
                            <h3>
                                <fmt:formatNumber value="${totalRecette - totalAvance}" type="number" groupingUsed="true"/> Ar
                            </h3>
                            <p>Reste à payer</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="card full-width">
                <div class="card-header">
                    <span class="icon">✅</span>
                    <h2>Places Libres par Voiture et par Date</h2>
                </div>

                <form method="get" action="${pageContext.request.contextPath}/ReservationServlet" style="margin-bottom:20px;">
                    <div class="form-group">
                        <label>🚗 Voiture</label>
                        <select name="idvoit" id="search_idvoit" required onchange="loadPlacesByDate()">
                            <option value="">-- Sélectionner --</option>
                            <c:forEach var="v" items="${voitures}">
                                <option value="${v.idvoit}" ${selectedVoiture.idvoit == v.idvoit ? 'selected' : ''}>
                                        ${v.idvoit} - ${v.design} (${v.type}) - ${v.nbrplace} places
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>📅 Date du voyage</label>
                        <input type="date" name="search_date" id="search_date" required
                               value="${selectedDate != null ? selectedDate : ''}"
                               onchange="loadPlacesByDate()">
                    </div>
                    <button type="button" class="btn btn-primary" onclick="loadPlacesByDate()">🔍 Rechercher</button>
                </form>

                <div id="placesResult">
                    <c:if test="${not empty placesLibres}">
                        <div style="background: #28a745; color:white; padding:15px; border-radius:10px; margin-bottom:20px; text-align:center;">
                            <h3>✅ Places disponibles</h3>
                            <p>Voiture : <strong>${selectedVoiture.design} (${selectedVoiture.idvoit})</strong></p>
                            <p>Date : <strong>${selectedDate}</strong></p>
                            <p>Places libres : <strong>${placesLibres.size()}</strong> / ${selectedVoiture.nbrplace}</p>
                        </div>
                        <div class="places-grid" id="placesGrid">
                            <c:forEach var="place" items="${placesLibres}">
                                <div class="place-libre">🪑 Place ${place}</div>
                            </c:forEach>
                        </div>
                    </c:if>
                    <c:if test="${empty placesLibres and not empty selectedVoiture}">
                        <div class="alert-info">📋 Aucune place libre pour cette voiture à la date sélectionnée</div>
                    </c:if>
                </div>
            </div>

        <div class="footer">
            <p>© 2026 - Coopérative de Transport | Application de Gestion de Réservation</p>
            <p>Tous droits réservés</p>
        </div>
    </div>
</div>

<script>
    var currentFrais = 0;
    var currentNbrPlace = 0;

    function updateFrais() {
        var select = document.getElementById("idvoit");
        var selectedOption = select.options[select.selectedIndex];
        var frais = selectedOption.getAttribute("data-frais");
        var fraisInput = document.getElementById("frais");
        if (frais && frais != "null") {
            currentFrais = parseInt(frais);
            fraisInput.value = currentFrais.toLocaleString('fr-FR') + " Ar";
        } else {
            fraisInput.value = "0 Ar";
            currentFrais = 0;
        }
        updateMontantAvance();
    }

    function updateMontantAvance() {
        var payement = document.getElementById("payement");
        var montantDiv = document.getElementById("montantAvanceDiv");
        var montantInput = document.getElementById("montant_avance");
        if (payement.value === "sans avance") {
            montantDiv.style.display = "none";
            montantInput.value = 0;
        } else if (payement.value === "tout paye") {
            montantDiv.style.display = "block";
            montantInput.value = currentFrais;
            montantInput.readOnly = true;
        } else if (payement.value === "avec avance") {
            montantDiv.style.display = "block";
            montantInput.readOnly = false;
            if (montantInput.value == 0 || montantInput.value == currentFrais) montantInput.value = 0;
        } else {
            montantDiv.style.display = "none";
        }
    }

    // Charger les places libres par date (pour la section recherche)
    function loadPlacesByDate() {
        var idvoit = document.getElementById("search_idvoit").value;
        var dateVoyage = document.getElementById("search_date").value;

        if (!idvoit || !dateVoyage) {
            document.getElementById("placesResult").innerHTML = '<div class="alert-info">Veuillez sélectionner une voiture et une date</div>';
            return;
        }

        document.getElementById("placesResult").innerHTML = '<div class="loading-spinner">⏳ Chargement des places...</div>';

        fetch('${pageContext.request.contextPath}/GetPlacesLibres?idvoit=' + idvoit + '&date_voyage=' + dateVoyage)
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    var placesLibres = data.places;
                    var nbrplace = data.nbrplace || 0;

                    var html = '';
                    html += '<div style="background: #28a745; color:white; padding:15px; border-radius:10px; margin-bottom:20px; text-align:center;">';
                    html += '<h3>✅ Places disponibles</h3>';
                    html += '<p>Date : <strong>' + dateVoyage + '</strong></p>';
                    html += '<p>Places libres : <strong>' + placesLibres.length + '</strong> / ' + nbrplace + '</p>';
                    html += '</div>';

                    if (placesLibres.length > 0) {
                        html += '<div class="places-grid">';
                        for (var i = 0; i < placesLibres.length; i++) {
                            html += '<div class="place-libre">🪑 Place ' + placesLibres[i] + '</div>';
                        }
                        html += '</div>';
                    } else {
                        html += '<div class="alert-info">📋 Aucune place libre pour cette date</div>';
                    }

                    document.getElementById("placesResult").innerHTML = html;
                } else {
                    document.getElementById("placesResult").innerHTML = '<div class="alert-error">❌ Erreur: ' + data.error + '</div>';
                }
            })
            .catch(error => {
                console.error('Erreur:', error);
                document.getElementById("placesResult").innerHTML = '<div class="alert-error">❌ Erreur de chargement des places</div>';
            });
    }

    // Modifier loadPlaces() pour utiliser la date (pour le formulaire de réservation)
  /*  function loadPlaces() {
        var voitureId = document.getElementById("idvoit").value;
        var dateVoyage = document.getElementById("date_voyage").value;
        var placeSelect = document.getElementById("place");
        var loadingDiv = document.getElementById("placesLoading");

        if (!voitureId) {
            placeSelect.innerHTML = '<option value="">Sélectionner une voiture</option>';
            updateFrais();
            return;
        }

        if (!dateVoyage) {
            placeSelect.innerHTML = '<option value="">Sélectionner d\'abord une date</option>';
            return;
        }

        var selectedOption = document.getElementById("idvoit").options[document.getElementById("idvoit").selectedIndex];
        var nbrPlaceAttr = selectedOption.getAttribute("data-nbrplace");
        currentNbrPlace = nbrPlaceAttr ? parseInt(nbrPlaceAttr) : 20;

        loadingDiv.style.display = "block";
        placeSelect.innerHTML = '<option value="">Chargement...</option>';
        placeSelect.disabled = true;

        fetch('${pageContext.request.contextPath}/GetPlacesStatus?idvoit=' + voitureId + '&date_voyage=' + dateVoyage)
            .then(response => response.json())
            .then(data => {
                placeSelect.innerHTML = '';
                var placesOccupees = data.placesOccupees || [];

                for (var i = 1; i <= currentNbrPlace; i++) {
                    var option = document.createElement('option');
                    option.value = i;
                    if (placesOccupees.includes(i)) {
                        option.textContent = '🚫 Place ' + i + ' (Occupée le ' + dateVoyage + ')';
                        option.disabled = true;
                        option.style.backgroundColor = '#f8d7da';
                        option.style.color = '#721c24';
                    } else {
                        option.textContent = '✅ Place ' + i + ' (Libre le ' + dateVoyage + ')';
                        option.style.backgroundColor = '#d4edda';
                        option.style.color = '#155724';
                    }
                    placeSelect.appendChild(option);
                }

                placeSelect.disabled = false;
                loadingDiv.style.display = "none";
            })
            .catch(error => {
                console.error('Erreur:', error);
                placeSelect.innerHTML = '<option value="">Erreur de chargement</option>';
                placeSelect.disabled = false;
                loadingDiv.style.display = "none";
            });

        updateFrais();
    }*/


    // ✅ Version CORRIGÉE : Charge les places sans dépendre de la date
    function loadPlaces() {
        var voitureSelect = document.getElementById("idvoit");
        var voitureId = voitureSelect.value;
        var placeSelect = document.getElementById("place");
        var loadingDiv = document.getElementById("placesLoading");

        if (!voitureId) {
            placeSelect.innerHTML = '<option value="">Sélectionner une voiture</option>';
            updateFrais();
            return;
        }

        var selectedOption = voitureSelect.options[voitureSelect.selectedIndex];
        var nbrPlaceAttr = selectedOption.getAttribute("data-nbrplace");
        currentNbrPlace = nbrPlaceAttr ? parseInt(nbrPlaceAttr) : 20;

        loadingDiv.style.display = "block";
        placeSelect.innerHTML = '<option value="">Chargement...</option>';
        placeSelect.disabled = true;

        // Appel AJAX sans paramètre date
        fetch('${pageContext.request.contextPath}/GetPlacesStatus?idvoit=' + voitureId)
            .then(response => response.json())
            .then(data => {
                placeSelect.innerHTML = '';
                var placesOccupees = data.placesOccupees || [];

                for (var i = 1; i <= currentNbrPlace; i++) {
                    var option = document.createElement('option');
                    option.value = i;
                    if (placesOccupees.includes(i)) {
                        option.textContent = '🚫 Place ' + i + ' (Occupée)';
                        option.disabled = true;
                        option.style.backgroundColor = '#f8d7da';
                        option.style.color = '#721c24';
                    } else {
                        option.textContent = '✅ Place ' + i + ' (Libre)';
                        option.style.backgroundColor = '#d4edda';
                        option.style.color = '#155724';
                    }
                    placeSelect.appendChild(option);
                }

                placeSelect.disabled = false;
                loadingDiv.style.display = "none";
            })
            .catch(error => {
                console.error('Erreur:', error);
                placeSelect.innerHTML = '<option value="">Erreur de chargement</option>';
                placeSelect.disabled = false;
                loadingDiv.style.display = "none";
            });

        updateFrais();
    }


    // ✅ Version CORRIGÉE pour la modification
    function loadEditPlaces() {
        var voitureSelect = document.getElementById("edit_idvoit");
        var voitureId = voitureSelect.value;
        var placeSelect = document.getElementById("edit_place");
        var loadingDiv = document.getElementById("editPlacesLoading");
        var currentPlace = ${reservationToEdit != null ? reservationToEdit.place : 0};

        if (!voitureId) return;

        loadingDiv.style.display = "block";
        placeSelect.innerHTML = '<option value="">Chargement...</option>';
        placeSelect.disabled = true;

        fetch('${pageContext.request.contextPath}/GetPlacesStatus?idvoit=' + voitureId)
            .then(response => response.json())
            .then(data => {
                placeSelect.innerHTML = '';
                var placesOccupees = data.placesOccupees || [];
                var nbrPlace = data.nbrplace || 20;

                for (var i = 1; i <= nbrPlace; i++) {
                    var option = document.createElement('option');
                    option.value = i;
                    if (placesOccupees.includes(i) && i != currentPlace) {
                        option.textContent = '🚫 Place ' + i + ' (Occupée)';
                        option.disabled = true;
                        option.style.backgroundColor = '#f8d7da';
                        option.style.color = '#721c24';
                    } else {
                        option.textContent = '✅ Place ' + i + (i == currentPlace ? ' (actuelle)' : ' (Libre)');
                        if (i == currentPlace) option.selected = true;
                        option.style.backgroundColor = '#d4edda';
                        option.style.color = '#155724';
                    }
                    placeSelect.appendChild(option);
                }

                placeSelect.disabled = false;
                loadingDiv.style.display = "none";
            })
            .catch(error => {
                console.error('Erreur:', error);
                placeSelect.disabled = false;
                loadingDiv.style.display = "none";
            });
    }

    function updateEditMontantAvance() {
        var payement = document.getElementById("edit_payement");
        var montantDiv = document.getElementById("editMontantAvanceDiv");
        var montantInput = document.getElementById("edit_montant_avance");
        var frais = ${reservationToEdit != null ? reservationToEdit.frais : 0};
        if (payement.value === "sans avance") {
            montantDiv.style.display = "none";
            montantInput.value = 0;
        } else if (payement.value === "tout paye") {
            montantDiv.style.display = "block";
            montantInput.value = frais;
            montantInput.readOnly = true;
        } else if (payement.value === "avec avance") {
            montantDiv.style.display = "block";
            montantInput.readOnly = false;
        } else {
            montantDiv.style.display = "none";
        }
    }

    function resetForm() {
        document.getElementById("idclt").value = "";
        document.getElementById("idvoit").value = "";
        document.getElementById("place").innerHTML = '<option value="">Sélectionner une voiture</option>';
        document.getElementById("date_voyage").value = "";
        document.getElementById("frais").value = "0 Ar";
        document.getElementById("payement").value = "";
        document.getElementById("montantAvanceDiv").style.display = "none";
        document.getElementById("montant_avance").value = 0;
        currentFrais = 0;
    }

    function validateForm() {
        var placeSelect = document.getElementById("place");
        var selectedPlace = placeSelect.options[placeSelect.selectedIndex];
        if (selectedPlace && selectedPlace.disabled) {
            alert("❌ Cette place est déjà occupée ! Veuillez choisir une autre place.");
            return false;
        }
        var avance = parseInt(document.getElementById("montant_avance").value) || 0;
        if (avance > currentFrais) {
            alert("❌ Le montant de l'avance ne peut pas dépasser le montant total des frais (" + currentFrais.toLocaleString('fr-FR') + " Ar)");
            return false;
        }
        return true;
    }

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

    document.addEventListener("DOMContentLoaded", function() {
        updateDateTime();
        initMobileMenu();
        setInterval(updateDateTime, 1000);

        // Initialiser le chargement des places si une voiture est déjà sélectionnée
        if (document.getElementById("idvoit").value) {
            loadPlaces();
        }

        // Mettre la date minimale à aujourd'hui
        var today = new Date().toISOString().split('T')[0];
        var dateInput = document.getElementById("date_voyage");
        if (dateInput) {
            dateInput.min = today;
        }

        // Initialiser pour le formulaire de modification
        if (document.getElementById("edit_idvoit") && document.getElementById("edit_idvoit").value) {
            loadEditPlaces();
        }
    });
</script>
</body>
</html>