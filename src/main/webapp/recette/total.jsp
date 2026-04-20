<!-- recette/total.jsp -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Recette Totale</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<div class="container">
    <h1>Recette Totale de la Coopérative</h1>
    <a href="../" class="btn">Retour</a>

    <div class="recette-box">
        <h2>Montant total des avances perçues</h2>
        <div class="montant">
            <fmt:formatNumber value="${totalRecette}" type="number" /> Ar
        </div>
        <p class="info">* Ce montant représente la somme de toutes les avances et paiements totaux enregistrés.</p>
    </div>
</div>
</body>
</html>