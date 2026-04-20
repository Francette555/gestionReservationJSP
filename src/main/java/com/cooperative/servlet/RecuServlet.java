package com.cooperative.servlet;

import com.cooperative.dao.ReservationDAO;
import com.cooperative.dao.ClientDAO;
import com.cooperative.model.Reservation;
import com.cooperative.model.Client;
import com.itextpdf.text.*;
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

        Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD);
        Paragraph title = new Paragraph("COOPERATIVE DE TRANSPORT", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);

        Paragraph subtitle = new Paragraph("RECU DE RESERVATION", new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD));
        subtitle.setAlignment(Element.ALIGN_CENTER);
        document.add(subtitle);

        document.add(new Paragraph(" "));

        PdfPTable headerTable = new PdfPTable(2);
        headerTable.setWidthPercentage(100);
        headerTable.addCell("Reçu N°: " + reservation.getIdreserv());
        headerTable.addCell("Date: " + new SimpleDateFormat("dd/MM/yyyy").format(new java.util.Date()));
        document.add(headerTable);

        document.add(new Paragraph(" "));

        PdfPTable infoTable = new PdfPTable(2);
        infoTable.setWidthPercentage(100);
        infoTable.setWidths(new float[]{30, 70});

        infoTable.addCell("Date du réservation:");
        infoTable.addCell(new SimpleDateFormat("dd MMMM yyyy à HH:mm").format(reservation.getDateReserv()));

        infoTable.addCell("Date du voyage:");
        infoTable.addCell(new SimpleDateFormat("dd MMMM yyyy").format(reservation.getDateVoyage()));

        infoTable.addCell("Nom du Client:");
        infoTable.addCell(client.getNom());

        infoTable.addCell("Contact:");
        infoTable.addCell(client.getNumtel() != null ? client.getNumtel() : "-");

        infoTable.addCell("Voiture N°:");
        infoTable.addCell(reservation.getIdvoit() + " / " + reservation.getDesignVoiture());

        infoTable.addCell("Place:");
        infoTable.addCell(String.valueOf(reservation.getPlace()));

        infoTable.addCell("Frais:");
        infoTable.addCell(String.format("%,d Ar", reservation.getFrais()));

        infoTable.addCell("Paiement:");
        infoTable.addCell(reservation.getPayement());

        infoTable.addCell("Montant Avance:");
        infoTable.addCell(String.format("%,d Ar", reservation.getMontantAvance()));

        infoTable.addCell("Reste:");
        infoTable.addCell(String.format("%,d Ar", reservation.getResteAPayer()));

        document.add(infoTable);

        document.add(new Paragraph(" "));
        Paragraph footer = new Paragraph("Merci de votre confiance !", new Font(Font.FontFamily.HELVETICA, 10, Font.ITALIC));
        footer.setAlignment(Element.ALIGN_CENTER);
        document.add(footer);

        document.close();
    }
}