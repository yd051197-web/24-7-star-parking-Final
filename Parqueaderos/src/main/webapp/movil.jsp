<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    int TOTAL_CARROS = 160;
    int TOTAL_MOTOS = 40;

    int carrosDisponibles = TOTAL_CARROS;
    int motosDisponibles = TOTAL_MOTOS;

    String url = "jdbc:mysql://localhost:3306/starparking";
    String usuarioDB = "root";
    String claveDB = "";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, usuarioDB, claveDB);

        String sqlCarros = "SELECT COUNT(*) FROM vehiculos WHERE tipo = 'Automovil' OR tipo = 'Carro'";
        ps = conn.prepareStatement(sqlCarros);
        rs = ps.executeQuery();
        if (rs.next()) {
            int carrosOcupados = rs.getInt(1);
            carrosDisponibles = TOTAL_CARROS - carrosOcupados;
        }
        rs.close();
        ps.close();

        String sqlMotos = "SELECT COUNT(*) FROM vehiculos WHERE tipo = 'Moto'";
        ps = conn.prepareStatement(sqlMotos);
        rs = ps.executeQuery();
        if (rs.next()) {
            int motosOcupados = rs.getInt(1);
            motosDisponibles = TOTAL_MOTOS - motosOcupados;
        }
    } catch (Exception e) {
        carrosDisponibles = TOTAL_CARROS;
        motosDisponibles = TOTAL_MOTOS;
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }

    String placaGuardada = request.getParameter("guardado");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>24/7 Star Parking Mobile</title>
    <style>
        body {
            background-color: #222222;
            color: #ffffff;
            font-family: 'Arial', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .container {
            width: 100%;
            max-width: 400px;
            padding: 20px;
            text-align: center;
        }
        h1 {
            color: #ffcc00;
            margin-bottom: 5px;
            font-size: 28px;
            font-weight: bold;
        }
        .subtitle {
            color: #aaaaaa;
            margin-bottom: 25px;
            font-size: 16px;
        }
        .btn-status-car {
            background-color: #28a745;
            color: white;
            padding: 12px;
            border-radius: 8px;
            font-weight: bold;
            margin-bottom: 15px;
            text-transform: uppercase;
        }
        .btn-status-moto {
            background-color: #17a2b8;
            color: white;
            padding: 12px;
            border-radius: 8px;
            font-weight: bold;
            margin-bottom: 25px;
            text-transform: uppercase;
        }
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: bold;
            letter-spacing: 1px;
            color: #ffffff;
            text-transform: uppercase;
        }
        input[type="text"], select {
            width: 100%;
            padding: 14px;
            border: 1px solid #333333;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 16px;
            background-color: #333333;
            color: #ffffff;
        }
        input[type="text"]::placeholder {
            color: #777777;
        }
        .btn-submit {
            width: 100%;
            padding: 16px;
            background-color: #ffb703;
            color: #000000;
            border: none;
            border-radius: 8px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            box-shadow: 0 4px 6px rgba(0,0,0,0.2);
        }
        .console-box {
            background-color: #000000;
            border: 1px solid #333333;
            border-radius: 8px;
            padding: 15px;
            margin-top: 25px;
            text-align: left;
            font-family: monospace;
            font-size: 14px;
            color: #00ff00;
            line-height: 1.5;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>24/7 Star Parking Mobile</h1>
    <div class="subtitle">Módulo Operario de Patio - Urrao</div>
    
    <div class="btn-status-car">Carros Libres: <%= carrosDisponibles %></div>
    <div class="btn-status-moto">Motos Libres: <%= motosDisponibles %></div>
    
    <form action="VehiculoServlet" method="POST">
        <input type="hidden" name="origen" value="movil_insertar">

        <div class="form-group">
            <label for="placa">Digitar o Escanear Placa</label>
            <input type="text" id="placa" name="placa" placeholder="EJ. ABC123" minlength="5" maxlength="6" pattern="[A-Za-z0-9]+" title="Solo se permiten letras y números sin espacios." required style="text-transform: uppercase;">
        </div>
        
        <div class="form-group">
            <label for="tipo">Tipo de Vehículo</label>
            <select id="tipo" name="tipo" required>
                <option value="Moto">Moto</option>
                <option value="Automovil">Carro</option>
            </select>
        </div>
        
        <button type="submit" class="btn-submit">Entrada Rápida Móvil</button>
    </form>

    <div class="console-box">
        &gt; Ecosistema Central conectado exitosamente...<br>
        <% if(placaGuardada != null && !placaGuardada.isEmpty()) { 
            if(placaGuardada.startsWith("DUPLICADO_")) { 
                String pRepetida = placaGuardada.replace("DUPLICADO_", ""); %>
                &gt; <span style="color: #ff3333;">[DENEGADO] La placa <%= pRepetida %> ya está activa en el patio.</span>
            <% } else if(placaGuardada.startsWith("ERROR_")) { %>
                &gt; <span style="color: #ff3333;"><%= placaGuardada %></span>
            <% } else { %>
                &gt; <span style="color: #ffcc00;">[ÉXITO] <%= placaGuardada %> guardado en BD.</span>
            <% } 
        } else { %>
            &gt; [SISTEMA] Listo para registrar.
        <% } %>
    </div>
</div>

</body>
</html>