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

    <!-- Message d'erreur -->
    <c:if test="${not empty error}">
        <div class="alert-info" style="background:#f8d7da; color:#721c24;">❌ ${error}</div>
    </c:if>

    <!-- Résultat de la recherche -->
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

    <!-- Filtres -->
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

    <!-- Tableau des résultats -->
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
</html>