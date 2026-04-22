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
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container { max-width: 1400px; margin: 0 auto; }

        .main-header {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            text-align: center;
        }

        .main-header h1 { color: #ee5a24; font-size: 2.5em; margin-bottom: 10px; }
        .main-header p { color: #666; font-size: 1.1em; }

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
            border-bottom: 3px solid #ee5a24;
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
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #ee5a24; }

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

        .btn-primary { background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%); color: white; }
        .btn-primary:hover { transform: translateY(-2px); }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-danger { background: #dc3545; color: white; }
        .btn-warning { background: #ffc107; color: #333; }
        .btn-info { background: #17a2b8; color: white; }
        .btn-sm { padding: 5px 12px; font-size: 12px; margin: 0 3px; }
        .btn-pdf { background: #dc3545; color: white; }
        .btn-pdf:hover { background: #c82333; }

        .table-responsive { overflow-x: auto; margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; background: white; border-radius: 10px; overflow: hidden; }
        thead { background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%); color: white; }
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

        .places-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(80px, 100px));
            gap: 15px;
            margin-top: 20px;
        }

        .place {
            padding: 15px;
            text-align: center;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
        }

        .place-libre {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
            border: 2px solid #28a745;
        }

        .place-occupee {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
            color: #721c24;
            border: 2px solid #dc3545;
        }

        .place-info { font-size: 11px; margin-top: 8px; }

        .alert-info {
            background-color: #d1ecf1;
            color: #0c5460;
            padding: 15px;
            border-radius: 8px;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 15px;
        }

        .info-text { text-align: center; padding: 20px; color: #666; font-style: italic; }
        .stats { display: flex; gap: 15px; margin-bottom: 20px; flex-wrap: wrap; }
        .stat-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 15px; border-radius: 10px; flex: 1; text-align: center; }
        .stat-card h3 { font-size: 2em; margin-bottom: 5px; }
        .actions { display: flex; gap: 5px; flex-wrap: wrap; }
        .full-width { grid-column: 1 / -1; }
        .debug-info { background: #f0f0f0; border-left: 4px solid #ee5a24; padding: 10px; margin-bottom: 15px; font-size: 12px; color: #666; }

        @media (max-width: 768px) {
            .grid { grid-template-columns: 1fr; }
            .main-header h1 { font-size: 1.8em; }
            .btn-sm { width: 100%; margin: 2px 0; text-align: center; }
            .places-grid { grid-template-columns: repeat(auto-fill, minmax(70px, 80px)); }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="main-header">
        <h1>🚐 Gestion des Réservations</h1>
        <p>Système complet de gestion des réservations de voyages</p>
    </div>

    <!-- Messages -->
    <c:if test="${not empty success}">
        <c:choose>
            <c:when test="${success == 'added'}"><div class="alert-success">✅ Réservation ajoutée avec succès !</div></c:when>
            <c:when test="${success == 'updated'}"><div class="alert-success">✏️ Réservation modifiée avec succès !</div></c:when>
            <c:when test="${success == 'deleted'}"><div class="alert-success">🗑️ Réservation supprimée avec succès !</div></c:when>
        </c:choose>
    </c:if>
    <c:if test="${not empty error}"><div class="alert-error">❌ ${error}</div></c:if>

    <!-- Info debug -->
    <div class="debug-info">
        📊 <strong>Info technique :</strong> ${reservations.size()} réservation(s) chargée(s)
    </div>

    <div class="grid">
        <!-- SECTION 1: NOUVELLE RÉSERVATION -->
        <div class="card">
            <div class="card-header">
                <span class="icon">📝</span>
                <h2>Nouvelle Réservation</h2>
            </div>
            <form action="${pageContext.request.contextPath}/ReservationServlet" method="post">
                <input type="hidden" name="action" value="insert">
                <div class="form-group">
                    <label>👤 Client *</label>
                    <select name="idclt" required>
                        <option value="">Sélectionner un client</option>
                        <c:forEach var="client" items="${clients}">
                            <option value="${client.idclt}">${client.nom} - ${client.numtel}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>🚗 Voiture *</label>
                    <select name="idvoit" id="idvoit" required onchange="updateFrais()">
                        <option value="">Sélectionner une voiture</option>
                        <c:forEach var="voiture" items="${voitures}">
                            <option value="${voiture.idvoit}" data-frais="${voiture.frais}">${voiture.design} (${voiture.type}) - ${voiture.frais} Ar</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>💺 Place *</label>
                    <select name="place" id="place" required>
                        <option value="">Sélectionner une place</option>
                        <c:forEach var="i" begin="1" end="50">
                            <option value="${i}">Place ${i}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label>📅 Date du voyage *</label>
                    <input type="date" name="date_voyage" required>
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
                    <input type="number" name="montant_avance" id="montant_avance" value="0">
                </div>
                <button type="submit" class="btn btn-primary">✅ Enregistrer la réservation</button>
                <button type="reset" class="btn btn-secondary">🗑️ Réinitialiser</button>
            </form>
        </div>

        <!-- SECTION 2: MODIFIER UNE RÉSERVATION -->
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
                        <select name="idvoit" required>
                            <c:forEach var="voiture" items="${voitures}">
                                <option value="${voiture.idvoit}" ${reservationToEdit.idvoit == voiture.idvoit ? 'selected' : ''}>${voiture.design} (${voiture.type})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>💺 Place *</label>
                        <input type="number" name="place" value="${reservationToEdit.place}" required min="1">
                    </div>
                    <div class="form-group">
                        <label>📅 Date du voyage *</label>
                        <input type="date" name="date_voyage" value="${reservationToEdit.dateVoyage}" required>
                    </div>
                    <div class="form-group">
                        <label>💳 Type de paiement *</label>
                        <select name="payement" required>
                            <option value="sans avance" ${reservationToEdit.payement == 'sans avance' ? 'selected' : ''}>Sans avance</option>
                            <option value="avec avance" ${reservationToEdit.payement == 'avec avance' ? 'selected' : ''}>Avec avance</option>
                            <option value="tout paye" ${reservationToEdit.payement == 'tout paye' ? 'selected' : ''}>Tout payé</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>💵 Montant de l'avance (Ar)</label>
                        <input type="number" name="montant_avance" value="${reservationToEdit.montantAvance}">
                    </div>
                    <button type="submit" class="btn btn-primary">💾 Mettre à jour</button>
                    <a href="${pageContext.request.contextPath}/ReservationServlet" class="btn btn-secondary">Annuler</a>
                </form>
            </c:if>
            <c:if test="${empty reservationToEdit}">
                <div class="alert-info">ℹ️ Cliquez sur "Modifier" dans la liste pour modifier une réservation</div>
            </c:if>
        </div>
    </div>

    <!-- SECTION 3: LISTE DES RÉSERVATIONS -->
    <div class="card full-width">
        <div class="card-header">
            <span class="icon">📊</span>
            <h2>Liste des Réservations</h2>
        </div>

        <div style="margin-bottom: 20px; display: flex; gap: 10px; flex-wrap: wrap;">
            <a href="${pageContext.request.contextPath}/ReservationServlet" class="btn btn-primary">🔄 Rafraîchir</a>
            <a href="${pageContext.request.contextPath}/" class="btn btn-secondary">🏠 Retour à l'accueil</a>
        </div>

        <div class="table-responsive">
            <table>
                <thead>
                <tr>
                    <th>🆔 N° Réservation</th>
                    <th>👤 Client</th>
                    <th>🚗 Voiture</th>
                    <th>💺 Place</th>
                    <th>📅 Date Voyage</th>
                    <th>💳 Paiement</th>
                    <th>💵 Avance</th>
                    <th>💰 Reste</th>
                    <th>⚙️ Actions</th>
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
                                <td>${reservation.dateVoyage}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${reservation.payement == 'sans avance'}"><span class="badge badge-pending">Sans avance</span></c:when>
                                        <c:when test="${reservation.payement == 'avec avance'}"><span class="badge badge-partial">Avec avance</span></c:when>
                                        <c:when test="${reservation.payement == 'tout paye'}"><span class="badge badge-paid">Tout payé</span></c:when>
                                    </c:choose>
                                </td>
                                <td>${reservation.montantAvance} Ar</td>
                                <td>${reservation.frais - reservation.montantAvance} Ar</td>
                                <td class="actions">
                                    <a href="${pageContext.request.contextPath}/ReservationServlet?action=edit&id=${reservation.idreserv}" class="btn btn-warning btn-sm">✏️ Modifier</a>
                                    <a href="${pageContext.request.contextPath}/ReservationServlet?action=delete&id=${reservation.idreserv}" class="btn btn-danger btn-sm" onclick="return confirm('Supprimer cette réservation ?')">🗑️ Supprimer</a>
                                    <a href="${pageContext.request.contextPath}/recu/generate?id=${reservation.idreserv}" class="btn btn-pdf btn-sm" target="_blank">📄 Reçu PDF</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr><td colspan="9" class="info-text">📋 Aucune réservation enregistrée</td></tr>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <div class="grid">
        <!-- SECTION 4: RECHERCHE -->
        <div class="card">
            <div class="card-header">
                <span class="icon">🔍</span>
                <h2>Recherche de Réservation</h2>
            </div>
            <form action="${pageContext.request.contextPath}/ReservationServlet" method="get">
                <input type="hidden" name="action" value="search">
                <div class="form-group">
                    <label>🔎 Rechercher par n° réservation ou nom client</label>
                    <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                        <input type="text" name="keyword" placeholder="Ex: RES001 ou Rakoto" style="flex: 1;">
                        <button type="submit" class="btn btn-primary">🔍 Rechercher</button>
                    </div>
                </div>
            </form>
            <c:if test="${not empty param.keyword and not empty searchResults}">
                <div class="alert-info">🔎 ${searchResults.size()} résultat(s) trouvé(s)</div>
            </c:if>
        </div>

        <!-- SECTION 5: STATISTIQUES -->
        <div class="card">
            <div class="card-header">
                <span class="icon">💰</span>
                <h2>Recette Totale</h2>
            </div>
            <div class="stats">
                <div class="stat-card" style="background: linear-gradient(135deg, #28a745, #20c997);">
                    <h3>
                        <c:set var="totalRecette" value="0"/>
                        <c:forEach var="reservation" items="${reservations}">
                            <c:set var="totalRecette" value="${totalRecette + reservation.frais}"/>
                        </c:forEach>
                        <fmt:formatNumber value="${totalRecette}" type="number" groupingUsed="true"/> Ar
                    </h3>
                    <p>Recette totale</p>
                </div>
                <div class="stat-card" style="background: linear-gradient(135deg, #ff6b6b, #ee5a24);">
                    <h3>
                        <c:set var="totalAvance" value="0"/>
                        <c:forEach var="reservation" items="${reservations}">
                            <c:set var="totalAvance" value="${totalAvance + reservation.montantAvance}"/>
                        </c:forEach>
                        <fmt:formatNumber value="${totalAvance}" type="number" groupingUsed="true"/> Ar
                    </h3>
                    <p>Total avances</p>
                </div>
            </div>
        </div>
    </div>
    <!-- SECTION 6: PLACES LIBRES D'UNE VOITURE -->
    <div class="card full-width">
        <div class="card-header">
            <span class="icon">✅</span>
            <h2>Places Libres par Voiture</h2>
        </div>

        <div class="filters" style="margin-bottom: 20px;">
            <form action="${pageContext.request.contextPath}/places/libres" method="post" style="display: flex; gap: 15px; flex-wrap: wrap; width: 100%; align-items: flex-end;">
                <div class="filter-group" style="flex: 2;">
                    <label>🚗 Sélectionner une voiture</label>
                    <select name="idvoit" required>
                        <option value="">Choisir une voiture</option>
                        <c:forEach var="voiture" items="${voitures}">
                            <option value="${voiture.idvoit}" ${selectedVoiture.idvoit == voiture.idvoit ? 'selected' : ''}>
                                    ${voiture.idvoit} - ${voiture.design} (${voiture.type}) - ${voiture.nbrplace} places
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="filter-group">
                    <button type="submit" class="btn btn-primary">🔍 Voir les places libres</button>
                </div>
            </form>
        </div>

        <!-- Affichage des résultats -->
        <c:if test="${not empty placesLibres}">
            <div class="result-stats" style="background: linear-gradient(135deg, #28a745, #20c997); color: white; padding: 15px; border-radius: 10px; margin-bottom: 20px; text-align: center;">
                <h3>✅ Places disponibles</h3>
                <p>Voiture : <strong>${selectedVoiture.design} (${selectedVoiture.idvoit})</strong></p>
                <p>Nombre de places libres : <strong>${placesLibres.size()}</strong> / ${selectedVoiture.nbrplace}</p>
            </div>

            <div class="places-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(80px, 100px)); gap: 15px; margin-top: 20px;">
                <c:forEach var="place" items="${placesLibres}">
                    <div class="place place-libre" style="background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%); color: #155724; border: 2px solid #28a745; padding: 15px; text-align: center; border-radius: 10px; font-weight: 600;">
                        🪑 Place ${place}
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${not empty param.idvoit and empty placesLibres and not empty selectedVoiture}">
            <div class="alert-info" style="background-color: #d1ecf1; color: #0c5460; padding: 15px; border-radius: 8px; text-align: center;">
                📋 Aucune place libre disponible pour cette voiture
            </div>
        </c:if>
    </div>

    <!-- Ajoutez ce style dans la section <style> si nécessaire -->
    <style>
        .result-stats { background: linear-gradient(135deg, #28a745, #20c997); color: white; padding: 15px; border-radius: 10px; margin-bottom: 20px; text-align: center; }
        .places-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(80px, 100px)); gap: 15px; margin-top: 20px; }
        .place-libre { background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%); color: #155724; border: 2px solid #28a745; padding: 15px; text-align: center; border-radius: 10px; font-weight: 600; transition: transform 0.3s ease; }
        .place-libre:hover { transform: scale(1.05); cursor: pointer; }
        .filter-group { flex: 1; min-width: 180px; }
        .filter-group label { display: block; margin-bottom: 8px; font-weight: 500; color: #555; }
        .filter-group select { width: 100%; padding: 10px; border: 2px solid #e0e0e0; border-radius: 8px; font-size: 14px; }
    </style>
</div>

<script>
    function updateFrais() {
        var select = document.getElementById("idvoit");
        var selectedOption = select.options[select.selectedIndex];
        var frais = selectedOption.getAttribute("data-frais");
        var fraisInput = document.getElementById("frais");

        if (frais) {
            fraisInput.value = parseInt(frais).toLocaleString('fr-FR') + " Ar";
        } else {
            fraisInput.value = "0 Ar";
        }
        updateMontantAvance();
    }

    function updateMontantAvance() {
        var payement = document.getElementById("payement");
        var montantDiv = document.getElementById("montantAvanceDiv");
        var montantInput = document.getElementById("montant_avance");
        var fraisInput = document.getElementById("frais");
        var frais = parseInt(fraisInput.value.replace(/[^0-9]/g, '')) || 0;

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
            montantInput.value = 0;
        } else {
            montantDiv.style.display = "none";
        }
    }
</script>
</body>
</html>