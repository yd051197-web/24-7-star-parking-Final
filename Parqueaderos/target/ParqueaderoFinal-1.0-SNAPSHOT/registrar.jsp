<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>

<head>
    <title>Registro Vehiculo</title>
</head>

<body>

    <h1>Registro Vehiculo</h1>

    <form action="VehiculoServlet" method="post">

        Placa:
        <input type="text" name="placa">
        <br><br>

        Tipo:
        <input type="text" name="tipo">
        <br><br>

        Hora Entrada:
        <input type="text" name="horaEntrada">
        <br><br>

        <input type="submit" value="Guardar">

    </form>

</body>
</html>