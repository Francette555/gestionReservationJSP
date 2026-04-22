package com.cooperative.servlet;

import com.cooperative.dao.ReservationDAO;
import com.cooperative.dao.ClientDAO;
import com.cooperative.model.Reservation;
import com.cooperative.model.Client;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/recu/generate")
public class RecuServlet extends HttpServlet {
    private ReservationDAO reservationDAO = new ReservationDAO();
    private ClientDAO clientDAO = new ClientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idreserv = request.getParameter("id");

        try {
            Reservation reservation = reservationDAO.findById(idreserv);
            if (reservation != null) {
                Client client = clientDAO.findById(reservation.getIdclt());
                generatePDF(response, reservation, client);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (SQLException | DocumentException e) {
            throw new ServletException(e);
        }
    }

    private void generatePDF(HttpServletResponse response, Reservation reservation, Client client)
            throws DocumentException, IOException {

        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=recu_" + reservation.getIdreserv() + ".pdf");

        Document document = new Document(PageSize.A4);
        PdfWriter.getInstance(document, response.getOutputStream());
        document.open();

        // ========== EN-TÊTE ==========
        Font titleFont = new Font(Font.FontFamily.HELVETICA, 16, Font.BOLD);
        Font normalFont = new Font(Font.FontFamily.HELVETICA, 12, Font.NORMAL);
        Font boldFont = new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD);
        Font headerFont = new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD);

        // Titre principal
        Paragraph title = new Paragraph("COOPÉRATIVE DE TRANSPORT", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);

        document.add(new Paragraph(" "));

        Paragraph subtitle = new Paragraph("REÇU DE RÉSERVATION", headerFont);
        subtitle.setAlignment(Element.ALIGN_CENTER);
        document.add(subtitle);

        document.add(new Paragraph(" "));
        document.add(new Paragraph(" "));

        // ========== NUMÉRO DU REÇU ==========
        Paragraph recuNum = new Paragraph("Reçu N° " + reservation.getIdreserv(), boldFont);
        recuNum.setAlignment(Element.ALIGN_CENTER);
        document.add(recuNum);

        document.add(new Paragraph(" "));
        document.add(new Paragraph(" "));

        // ========== TABLEAU DES INFORMATIONS (2 colonnes) ==========
        PdfPTable infoTable = new PdfPTable(2);
        infoTable.setWidthPercentage(90);
        infoTable.setHorizontalAlignment(Element.ALIGN_CENTER);
        infoTable.setWidths(new float[]{35, 65});

        // Date de réservation
        PdfPCell cell1 = new PdfPCell(new Phrase("Date du réservation :", boldFont));
        cell1.setBorder(Rectangle.NO_BORDER);
        cell1.setPadding(5);
        infoTable.addCell(cell1);

        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy");
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("dd MMMM yyyy 'à' HH:mm");
        String dateReservStr = dateTimeFormat.format(reservation.getDateReserv());
        PdfPCell cell2 = new PdfPCell(new Phrase(dateReservStr, normalFont));
        cell2.setBorder(Rectangle.NO_BORDER);
        cell2.setPadding(5);
        infoTable.addCell(cell2);

        // Date du voyage
        cell1 = new PdfPCell(new Phrase("Date du voyage :", boldFont));
        cell1.setBorder(Rectangle.NO_BORDER);
        cell1.setPadding(5);
        infoTable.addCell(cell1);

        String dateVoyageStr = dateFormat.format(reservation.getDateVoyage());
        cell2 = new PdfPCell(new Phrase(dateVoyageStr, normalFont));
        cell2.setBorder(Rectangle.NO_BORDER);
        cell2.setPadding(5);
        infoTable.addCell(cell2);

        // Nom du Client
        cell1 = new PdfPCell(new Phrase("Nom du Client :", boldFont));
        cell1.setBorder(Rectangle.NO_BORDER);
        cell1.setPadding(5);
        infoTable.addCell(cell1);

        String clientInfo = client.getNom() + " / Contact : " + (client.getNumtel() != null ? client.getNumtel() : "-");
        cell2 = new PdfPCell(new Phrase(clientInfo, normalFont));
        cell2.setBorder(Rectangle.NO_BORDER);
        cell2.setPadding(5);
        infoTable.addCell(cell2);

        // Voiture et Type
        cell1 = new PdfPCell(new Phrase("Voiture :", boldFont));
        cell1.setBorder(Rectangle.NO_BORDER);
        cell1.setPadding(5);
        infoTable.addCell(cell1);

        String typeVoiture = "";
        if ("simple".equals(reservation.getDesignVoitureType())) {
            typeVoiture = "Simple";
        } else if ("premium".equals(reservation.getDesignVoitureType())) {
            typeVoiture = "Premium";
        } else if ("VIP".equals(reservation.getDesignVoitureType())) {
            typeVoiture = "VIP";
        } else {
            typeVoiture = reservation.getDesignVoitureType();
        }

        String voitureInfo = "N°" + reservation.getIdvoit() + " / Type de Voiture : " + typeVoiture + " / Place : " + reservation.getPlace();
        cell2 = new PdfPCell(new Phrase(voitureInfo, normalFont));
        cell2.setBorder(Rectangle.NO_BORDER);
        cell2.setPadding(5);
        infoTable.addCell(cell2);

        // Frais
        cell1 = new PdfPCell(new Phrase("Frais :", boldFont));
        cell1.setBorder(Rectangle.NO_BORDER);
        cell1.setPadding(5);
        infoTable.addCell(cell1);

        String fraisStr = String.format("%,d Ar", reservation.getFrais());
        cell2 = new PdfPCell(new Phrase(fraisStr, normalFont));
        cell2.setBorder(Rectangle.NO_BORDER);
        cell2.setPadding(5);
        infoTable.addCell(cell2);

        // Paiement
        cell1 = new PdfPCell(new Phrase("Paiement :", boldFont));
        cell1.setBorder(Rectangle.NO_BORDER);
        cell1.setPadding(5);
        infoTable.addCell(cell1);

        String payementLibelle = "";
        if ("sans avance".equals(reservation.getPayement())) {
            payementLibelle = "Sans Avance";
        } else if ("avec avance".equals(reservation.getPayement())) {
            payementLibelle = "Avec Avance";
        } else if ("tout paye".equals(reservation.getPayement())) {
            payementLibelle = "Tout Payé";
        } else {
            payementLibelle = reservation.getPayement();
        }

        cell2 = new PdfPCell(new Phrase(payementLibelle, normalFont));
        cell2.setBorder(Rectangle.NO_BORDER);
        cell2.setPadding(5);
        infoTable.addCell(cell2);

        // Montant Avance / Reste
        if ("avec avance".equals(reservation.getPayement())) {
            cell1 = new PdfPCell(new Phrase("Montant Avance :", boldFont));
            cell1.setBorder(Rectangle.NO_BORDER);
            cell1.setPadding(5);
            infoTable.addCell(cell1);

            String avanceInfo = String.format("%,d Ar / Reste : %,d Ar", reservation.getMontantAvance(), reservation.getResteAPayer());
            cell2 = new PdfPCell(new Phrase(avanceInfo, normalFont));
            cell2.setBorder(Rectangle.NO_BORDER);
            cell2.setPadding(5);
            infoTable.addCell(cell2);
        } else if ("tout paye".equals(reservation.getPayement())) {
            cell1 = new PdfPCell(new Phrase("Montant payé :", boldFont));
            cell1.setBorder(Rectangle.NO_BORDER);
            cell1.setPadding(5);
            infoTable.addCell(cell1);

            cell2 = new PdfPCell(new Phrase(String.format("%,d Ar", reservation.getMontantAvance()), normalFont));
            cell2.setBorder(Rectangle.NO_BORDER);
            cell2.setPadding(5);
            infoTable.addCell(cell2);
        }

        document.add(infoTable);

        document.add(new Paragraph(" "));
        document.add(new Paragraph(" "));
        document.add(new Paragraph(" "));

        // ========== PIED DE PAGE ==========
        Font footerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC);
        Paragraph footer = new Paragraph("Merci de votre confiance !", footerFont);
        footer.setAlignment(Element.ALIGN_CENTER);
        document.add(footer);

        document.close();
    }
}