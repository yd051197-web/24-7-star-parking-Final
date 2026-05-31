<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>

    <title>Registro Exitoso</title>

</head>

<body>

    <h1>Vehiculo Registrado Correctamente</h1>

    <hr>

    <h2>Placa:</h2>

    <p>
        <%= request.getAttribute("placa") %>
    </p>

    <h2>Tipo:</h2>

    <p>
        <%= request.getAttribute("tipo") %>
    </p>

    <h2>Hora Entrada:</h2>

    <p>
        <%= request.getAttribute("hora") %>
    </p>

    <br><br>

    <a href="registrar.jsp">
        Registrar Otro Vehiculo
    </a>

</body>

</html>