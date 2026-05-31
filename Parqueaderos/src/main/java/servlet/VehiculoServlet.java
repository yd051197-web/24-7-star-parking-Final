package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "VehiculoServlet", urlPatterns = {"/VehiculoServlet"})
public class VehiculoServlet extends HttpServlet {

    private final String url = "jdbc:mysql://localhost:3306/starparking";
    private final String usuarioDB = "root";
    private final String claveDB = "";

    // Método auxiliar para verificar si una placa ya está en el parqueadero
    private boolean existePlacaActiva(String placa) {
        String sql = "SELECT COUNT(*) FROM vehiculos WHERE UPPER(TRIM(placa)) = ?";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(url, usuarioDB, claveDB);
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, placa.trim().toUpperCase());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1) > 0;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String origen = request.getParameter("origen");

        if ("web_listado".equals(origen)) {
            response.setContentType("application/json;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(url, usuarioDB, claveDB)) {
                    String sql = "SELECT * FROM vehiculos";
                    try (PreparedStatement ps = conn.prepareStatement(sql);
                         ResultSet rs = ps.executeQuery()) {
                        
                        StringBuilder json = new StringBuilder();
                        json.append("[");
                        boolean primero = true;
                        
                        while (rs.next()) {
                            if (!primero) {
                                json.append(",");
                            }
                            json.append("{");
                            json.append("\"placa\":\"").append(rs.getString("placa")).append("\",");
                            json.append("\"tipo\":\"").append(rs.getString("tipo")).append("\"");
                            json.append("}");
                            primero = false;
                        }
                        json.append("]");
                        out.print(json.toString());
                    }
                }
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                try (PrintWriter out = response.getWriter()) {
                    out.print("[]");
                }
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String origen = request.getParameter("origen");

        if ("web_formulario".equals(origen)) {
            response.setContentType("application/json;charset=UTF-8");
            String placa = request.getParameter("placa");
            String tipo = request.getParameter("tipo");

            if (placa != null) {
                placa = placa.trim().toUpperCase();
            }

            try (PrintWriter out = response.getWriter()) {
                // VALIDACIÓN CRÍTICA EN WEB
                if (existePlacaActiva(placa)) {
                    out.print("{\"status\":\"error\", \"mensaje\":\"El vehículo con placa " + placa + " ya se encuentra registrado en el patio.\"}");
                    return;
                }

                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(url, usuarioDB, claveDB)) {
                    String sql = "INSERT INTO vehiculos (placa, tipo) VALUES (?, ?)";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, placa);
                        ps.setString(2, tipo);
                        ps.executeUpdate();
                    }
                    out.print("{\"status\":\"success\", \"mensaje\":\"Vehículo " + placa + " registrado con éxito en Taquilla Web.\"}");
                }
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                try (PrintWriter out = response.getWriter()) {
                    out.print("{\"status\":\"error\", \"mensaje\":\"" + e.getMessage() + "\"}");
                }
            }

        } else if ("web_salida".equals(origen)) {
            response.setContentType("application/json;charset=UTF-8");
            String placa = request.getParameter("placa");

            if (placa != null) {
                placa = placa.trim().toUpperCase();
            }

            try (PrintWriter out = response.getWriter()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(url, usuarioDB, claveDB)) {
                    String sql = "DELETE FROM vehiculos WHERE placa = ?";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, placa);
                        int filas = ps.executeUpdate();
                        
                        if (filas > 0) {
                            out.print("{\"status\":\"success\", \"mensaje\":\"Salida procesada correctamente.\"}");
                        } else {
                            out.print("{\"status\":\"error\", \"mensaje\":\"No se encontró el vehículo en el patio.\"}");
                        }
                    }
                }
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                try (PrintWriter out = response.getWriter()) {
                    out.print("{\"status\":\"error\", \"mensaje\":\"" + e.getMessage() + "\"}");
                }
            }

        } else if ("movil_insertar".equals(origen)) {
            String placa = request.getParameter("placa");
            String tipo = request.getParameter("tipo");

            if (placa != null) {
                placa = placa.trim().toUpperCase();
            }

            // VALIDACIÓN CRÍTICA EN MÓVIL
            if (existePlacaActiva(placa)) {
                response.sendRedirect("movil.jsp?guardado=DUPLICADO_" + placa);
                return;
            }

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                try (Connection conn = DriverManager.getConnection(url, usuarioDB, claveDB)) {
                    String sql = "INSERT INTO vehiculos (placa, tipo) VALUES (?, ?)";
                    try (PreparedStatement ps = conn.prepareStatement(sql)) {
                        ps.setString(1, placa);
                        ps.setString(2, tipo);
                        ps.executeUpdate();
                    }
                }
                response.sendRedirect("movil.jsp?guardado=" + placa);
                
            } catch (Exception e) {
                response.sendRedirect("movil.jsp?guardado=ERROR_" + e.getMessage().replace(" ", "_"));
            }
        }
    }
}