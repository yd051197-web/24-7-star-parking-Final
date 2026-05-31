<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>24/7 Star Parking - Terminal Central</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #ebf1f6;
            margin: 0;
            padding: 20px;
        }
        .login-container {
            max-width: 400px;
            margin: 80px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border-top: 5px solid #004085;
            text-align: center;
        }
        .login-container h2 { color: #004085; margin-bottom: 20px; font-size: 24px; }
        #interfazPrincipal { display: none; }
        .header { text-align: center; color: #004085; margin-bottom: 20px; }
        .header h2 { margin: 5px 0; font-size: 26px; }
        .header p { margin: 0; color: #6c757d; font-size: 14px; }
        .nav-user { 
            max-width: 1300px; margin: 0 auto 15px auto; display: flex; 
            justify-content: space-between; align-items: center;
            background: #004085; color: white; padding: 10px 20px; border-radius: 6px; font-size: 14px;
        }
        .btn-logout { background: #dc3545; color: white; border: none; padding: 5px 12px; border-radius: 4px; cursor: pointer; font-weight: bold; }
        .monitor-container {
            max-width: 600px; margin: 0 auto 20px auto; background: white; padding: 15px;
            border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); border-top: 4px solid #004085;
            display: flex; justify-content: space-around; align-items: center;
        }
        .monitor-block { text-align: center; }
        .monitor-title { font-weight: bold; color: #004085; margin-bottom: 5px; font-size: 14px; }
        .monitor-badge { background-color: #003366; color: white; padding: 8px 15px; border-radius: 6px; font-weight: bold; font-size: 15px; }
        .main-content { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; max-width: 1300px; margin: 0 auto; }
        .panel { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); border-left: 5px solid #0056b3; }
        .panel h3 { color: #003366; margin-top: 0; font-size: 18px; margin-bottom: 15px; }
        .form-section { margin-bottom: 20px; }
        .form-section label { display: block; font-size: 13px; font-weight: bold; margin-bottom: 5px; color: #333; }
        input, select { width: 100%; padding: 10px; margin-bottom: 12px; border: 1px solid #ced4da; border-radius: 4px; box-sizing: border-box; font-size: 14px; }
        .btn-web { width: 100%; padding: 12px; color: white; border: none; border-radius: 4px; font-weight: bold; font-size: 14px; cursor: pointer; }
        .btn-blue { background-color: #004085; }
        .btn-green { background-color: #28a745; }
        .btn-yellow { background-color: #ffc107; color: black; }
        #panelFinanzas { display: none; }
        .caja-container { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; margin-bottom: 15px; }
        .caja-card { background: #f1f8e9; border: 1px solid #c5e1a5; padding: 12px; border-radius: 6px; text-align: center; }
        .caja-card h4 { margin: 0 0 5px 0; color: #33691e; font-size: 13px; }
        .caja-val { font-size: 20px; font-weight: bold; color: #1b5e20; }
        .footer-panel { max-width: 1300px; margin: 20px auto 0 auto; background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); border-left: 5px solid #6c757d; }
        .footer-panel h3 { color: #003366; margin-top: 0; font-size: 16px; margin-bottom: 15px; }
        .log-box { background-color: #f8f9fa; border: 1px solid #e9ecef; padding: 12px; border-radius: 4px; font-family: monospace; font-size: 13px; color: #6c757d; max-height: 150px; overflow-y: auto; }
        
        .tabla-vehiculos { width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 14px; }
        .tabla-vehiculos th { background-color: #004085; color: white; padding: 8px; text-align: left; }
        .tabla-vehiculos td { padding: 8px; border-bottom: 1px solid #dee2e6; }
        .tabla-vehiculos tr:hover { background-color: #f1f3f5; }

        .alerta-duplicado {
            border: 2px solid #ffc107;
            background-color: #fff3cd;
            color: #856404;
            padding: 15px;
            margin-top: 15px;
            border-radius: 6px;
            font-weight: bold;
            text-align: center;
            animation: parpadeo 1.5s infinite;
        }
        @keyframes parpadeo {
            0% { opacity: 1; }
            50% { opacity: 0.6; }
            100% { opacity: 1; }
        }
    </style>
</head>
<body>

    <div id="pantallaLogin" class="login-container">
        <h2>🔒 Acceso Ecosistema</h2>
        <p>24/7 Star Parking - Terminal Central</p>
        <div style="text-align: left;">
            <label style="font-size: 12px; font-weight: bold; color: #555;">USUARIO DE RED</label>
            <input type="text" id="userInput" placeholder="admin u operario">
            <label style="font-size: 12px; font-weight: bold; color: #555;">CONTRASEÑA</label>
            <input type="password" id="passInput" placeholder="••••••••">
            <button class="btn-web btn-blue" style="margin-top: 10px;" onclick="autenticarUsuario()">Ingresar a Terminal</button>
        </div>
    </div>

    <div id="interfazPrincipal">
        <div class="nav-user">
            <div>👤 Autenticado como: <strong id="lblRol">Ninguno</strong></div>
            <button class="btn-logout" onclick="cerrarSesion()">Cerrar Sesión ↩</button>
        </div>

        <div class="header">
            <h2>🚗 24/7 Star Parking - Terminal Central</h2>
            <p>Consola de Control de Taquilla Web</p>
        </div>

        <div class="monitor-container">
            <div class="monitor-block">
                <div class="monitor-title">🚗 Celdas Carros</div>
                <div id="badgeCarros" class="monitor-badge">DISPONIBLES: 160 / 160</div>
            </div>
            <div class="monitor-block">
                <div class="monitor-title">🏍️ Celdas Motos</div>
                <div id="badgeMotos" class="monitor-badge">DISPONIBLES: 40 / 40</div>
            </div>
        </div>

        <div class="main-content">
            <div class="panel">
                <h3>💻 Registro de Taquilla</h3>
                <div class="form-section">
                    <label>Registrar Entrada</label>
                    <input type="text" id="placaIngreso" placeholder="Ingrese placa (ej. ABC123)" 
                           onkeypress="if(event.key === 'Enter') registrarEntradaWeb()">
                    <select id="tipoVehiculo">
                        <option value="Automovil">Carro (H: $10.000 / Fracción: $5.000)</option>
                        <option value="Moto">Moto (H: $3.000 / Fracción: $2.000)</option>
                    </select>
                    <button class="btn-web btn-blue" onclick="registrarEntradaWeb()">Registrar Entrada Web</button>
                </div>
                <div class="form-section" style="border-top: 1px solid #eee; padding-top: 15px;">
                    <label>Registrar Salida y Liquidación de Caja</label>
                    <input type="text" id="placaSalida" placeholder="Ingrese placa del vehículo" 
                           onkeypress="if(event.key === 'Enter') registrarSalidaWeb()">
                    <button class="btn-web btn-green" onclick="registrarSalidaWeb()">Calcular y Registrar Salida</button>
                </div>
                <div id="zonaTicket"></div>
            </div>

            <div class="panel">
                <h3>📅 Reservas y Ubicación</h3>
                <label>Nombre del Cliente</label>
                <input type="text" id="nombreCliente" placeholder="Nombre completo">
                <label>Placa del Vehículo</label>
                <input type="text" id="placaReserva" placeholder="Placa asociada">
                <label>Tipo de Celda Requerida</label>
                <select id="tipoReserva" onchange="dinamizarCeldas()">
                    <option value="Automovil">Espacio para Carro</option>
                    <option value="Moto">Espacio para Moto</option>
                </select>
                <label>Celda Específica</label>
                <select id="espacioParqueo"></select>
                <button class="btn-web btn-yellow" onclick="registrarReserva()">Reservar Cupo 🎫</button>
                <p style="font-size: 11px; color: #6c757d; margin-top: 15px; font-weight: bold;">Sede Urrao: Calle 25 #19-30</p>
            </div>
        </div>

        <div class="footer-panel">
            <h3>📋 Vehículos Actualmente en el Patio (Base de Datos MySQL)</h3>
            <div style="max-height: 200px; overflow-y: auto;">
                <table class="tabla-vehiculos">
                    <thead>
                        <tr>
                            <th>Placa Activa</th>
                            <th>Tipo de Vehículo</th>
                        </tr>
                    </thead>
                    <tbody id="tablaCuerpoVehiculos">
                        <tr>
                            <td colspan="2" style="color: #6c757d; text-align: center;">Cargando registros...</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="panelFinanzas" class="footer-panel">
            <h3>💰 Control Financiero y Arqueo de Caja</h3>
            <div class="caja-container">
                <div class="caja-card"><h4>🚗 Recaudo Carros</h4><div id="recaudoCarros" class="caja-val">$0</div></div>
                <div class="caja-card" style="background:#e0f7fa; border-color:#b2ebf2;"><h4 style="color:#006064;">🏍️ Recaudo Motos</h4><div id="recaudoMotos" class="caja-val" style="color:#006064;">$0</div></div>
                <div class="caja-card" style="background:#fff3e0; border-color:#ffe0b2;"><h4 style="color:#e65100;">💵 TOTAL EN CAJA</h4><div id="recaudoTotal" class="caja-val" style="color:#e65100;">$0</div></div>
            </div>
        </div>

        <div class="footer-panel">
            <h3>📋 Historial de Procesos</h3>
            <div id="logBox" class="log-box"><div class="log-line">> Sistema operativo...</div></div>
        </div>
    </div>

    <script>
        // RUTA RELATIVA DIRECTA: Evita conflictos de nombres entre proyectos de NetBeans
        const URL_SERVLET = "VehiculoServlet";
        
        const MAX_CARROS = 160; const MAX_MOTOS = 40;
        let dbVehiculos = [];
        let dbReservas = JSON.parse(localStorage.getItem('star_parking_res')) || [];
        let cajaFinanzas = JSON.parse(localStorage.getItem('star_parking_caja')) || { carros: 0, motos: 0, total: 0 };
        let usuarioSesion = localStorage.getItem('star_parking_rol') || null;

        function inicializar() {
            if (usuarioSesion) { 
                cargarEntornoSistema(usuarioSesion); 
                setInterval(cargarVehiculosDesdeBD, 4000);
            } else { 
                document.getElementById('pantallaLogin').style.display = 'block'; 
                document.getElementById('interfazPrincipal').style.display = 'none'; 
            }
        }
        
        function autenticarUsuario() {
            const user = document.getElementById('userInput').value.trim().toLowerCase();
            const pass = document.getElementById('passInput').value;
            if (user === 'admin' && pass === '1234') { localStorage.setItem('star_parking_rol', 'Administrador'); cargarEntornoSistema('Administrador'); inicializar(); } 
            else if (user === 'operario' && pass === '5678') { localStorage.setItem('star_parking_rol', 'Operario'); cargarEntornoSistema('Operario'); inicializar(); } 
            else { alert("❌ Credenciales incorrectas."); }
        }
        
        function cargarEntornoSistema(rol) {
            usuarioSesion = rol; document.getElementById('pantallaLogin').style.display = 'none'; document.getElementById('interfazPrincipal').style.display = 'block';
            document.getElementById('lblRol').innerText = rol;
            document.getElementById('panelFinanzas').style.display = (rol === 'Administrador') ? 'block' : 'none';
            
            cargarVehiculosDesdeBD();
            dinamizarCeldas(); 
            actualizarPantallaCaja();
        }
        
        function cerrarSesion() { localStorage.removeItem('star_parking_rol'); usuarioSesion = null; inicializar(); }
        
        function cargarVehiculosDesdeBD() {
            fetch(URL_SERVLET + "?origen=web_listado")
            .then(res => {
                if(!res.ok) throw new Error("Status: " + res.status);
                return res.json();
            })
            .then(data => {
                dbVehiculos = Array.isArray(data) ? data : []; 
                actualizarInterfaz();
                renderizarTabla();
            })
            .catch(err => {
                console.error("Error en Fetch listado:", err);
            });
        }

        function renderizarTabla() {
            const cuerpo = document.getElementById('tablaCuerpoVehiculos');
            if(!cuerpo) return;
            if(dbVehiculos.length === 0) {
                cuerpo.innerHTML = '<tr><td colspan="2" style="text-align:center; color:gray;">No hay vehículos en el patio</td></tr>';
                return;
            }
            cuerpo.innerHTML = "";
            dbVehiculos.forEach(v => {
                cuerpo.innerHTML += '<tr>' +
                    '<td><strong>' + v.placa + '</strong></td>' +
                    '<td>' + (v.tipo === 'Automovil' || v.tipo === 'Carro' ? '🚗 Carro' : '🏍️ Moto') + '</td>' +
                '</tr>';
            });
        }
        
        function registrarEntradaWeb() {
            let placaInput = document.getElementById('placaIngreso').value.trim();
            const tipo = document.getElementById('tipoVehiculo').value;
            
            if(!placaInput) { alert("❌ Error: La placa no puede estar vacía."); return; }
            
            const tieneCaracteresRaros = /[^A-Za-z0-9]/.test(placaInput);
            if(tieneCaracteresRaros) {
                alert("❌ ERROR DE VALIDACIÓN:\nLa placa '" + placaInput + "' contiene espacios o símbolos prohibidos.\nPor favor use solo letras y números.");
                return; 
            }
            
            const placa = placaInput.toUpperCase();
            const existeDuplicado = dbVehiculos.some(v => v.placa === placa);
            if (existeDuplicado) {
                document.getElementById('zonaTicket').innerHTML = 
                    '<div class="alerta-duplicado">' +
                        '⚠️ ATENCIÓN: El vehículo con placa ' + placa + ' ya registra un ingreso activo.' +
                    '</div>';
                return; 
            }
            
            const datos = new URLSearchParams();
            datos.append("origen", "web_formulario");
            datos.append("placa", placa);
            datos.append("tipo", tipo);

            fetch(URL_SERVLET, {
                method: "POST",
                headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                body: datos
            })
            .then(res => res.json())
            .then(data => {
                if(data.status === "success") {
                    document.getElementById('zonaTicket').innerHTML = ""; 
                    alert("✅ " + data.mensaje);
                    cargarVehiculosDesdeBD();
                    document.getElementById('placaIngreso').value = "";
                    agregarLog('Vehículo ' + placa + ' ingresado con éxito.', true);
                } else {
                    alert("❌ " + data.mensaje);
                }
            })
            .catch(err => {
                console.error(err);
                alert("❌ Error de conexión con el servidor Java.");
            });
        }

        function registrarSalidaWeb() {
            const placa = document.getElementById('placaSalida').value.trim().toUpperCase();
            if(!placa) { alert("Ingrese una placa."); return; }
            
            const estaActivo = dbVehiculos.some(v => v.placa === placa);
            if (!estaActivo) {
                document.getElementById('zonaTicket').innerHTML = 
                    '<div class="alerta-duplicado" style="background-color: #f8d7da; color: #721c24; border-color: #f5c6cb;">' +
                        '❌ ERROR: La placa ' + placa + ' no corresponde a ningún vehículo activo en el patio.' +
                    '</div>';
                return;
            }
            
            const vehiculo = dbVehiculos.find(v => v.placa === placa);
            const tipoReal = vehiculo ? vehiculo.tipo : 'Automovil';
            const total = (tipoReal === 'Automovil' || tipoReal === 'Carro') ? 10000 : 3000;
            
            const datos = new URLSearchParams();
            datos.append("origen", "web_salida");
            datos.append("placa", placa); 

            fetch(URL_SERVLET, {
                method: "POST",
                headers: { 'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8' },
                body: datos
            })
            .then(res => res.json())
            .then(data => {
                if(data.status === "success") {
                    if (tipoReal === 'Automovil' || tipoReal === 'Carro') { cajaFinanzas.carros += total; } else { cajaFinanzas.motos += total; }
                    cajaFinanzas.total += total;
                    localStorage.setItem('star_parking_caja', JSON.stringify(cajaFinanzas));
                    actualizarPantallaCaja();
                    
                    document.getElementById('zonaTicket').innerHTML = 
                        '<div style="border: 2px dashed #003366; padding: 15px; background: #fffbeb; margin-top: 15px; font-family: monospace;">' +
                            '<h4 style="text-align:center;margin:0;">*** TICKET DE SALIDA ***</h4>' +
                            '<p><strong>PLACA COBRADA:</strong> ' + placa + '</p>' +
                            '<p style="font-size:16px;color:#c00;"><strong>TOTAL:</strong> $' + total.toLocaleString('es-CO') + ' COP</p>' +
                        '</div>';
                    
                    cargarVehiculosDesdeBD();
                    document.getElementById('placaSalida').value = "";
                    agregarLog('Salida y cobro procesado para la placa: ' + placa, true);
                } else {
                    alert("❌ " + data.mensaje);
                }
            })
            .catch(err => {
                console.error(err);
                alert("❌ Error al procesar la salida en el servidor Java.");
            });
        }

        function actualizarPantallaCaja() {
            if(document.getElementById('recaudoCarros')) {
                document.getElementById('recaudoCarros').innerText = '$' + cajaFinanzas.carros.toLocaleString('es-CO');
                document.getElementById('recaudoMotos').innerText = '$' + cajaFinanzas.motos.toLocaleString('es-CO');
                document.getElementById('recaudoTotal').innerText = '$' + cajaFinanzas.total.toLocaleString('es-CO');
            }
        }
        function registrarReserva() {
            const nom = document.getElementById('nombreCliente').value.trim();
            const pla = document.getElementById('placaReserva').value.trim().toUpperCase();
            const cel = document.getElementById('espacioParqueo').value;
            const tip = document.getElementById('tipoReserva').value;
            if(!nom || !pla) { alert("Complete los datos."); return; }
            dbReservas.push({ nombre: nom, placa: pla, celda: cel, tipo: tip });
            localStorage.setItem('star_parking_res', JSON.stringify(dbReservas));
            alert("🎫 Reserva exitosa.");
            document.getElementById('nombreCliente').value = ""; document.getElementById('placaReserva').value = "";
            dinamizarCeldas(); actualizarInterfaz();
            agregarLog('Nueva reserva para: ' + nom + ' (Placa: ' + pla + ')', true);
        }
        function dinamizarCeldas() {
            const tipo = document.getElementById('tipoReserva').value;
            const select = document.getElementById('espacioParqueo'); if(!select) return; select.innerHTML = "";
            const prefijo = (tipo === 'Automovil') ? 'A' : 'B'; const limite = (tipo === 'Automovil') ? MAX_CARROS : MAX_MOTOS;
            for(let i = 1; i <= limite; i++) {
                const celda = 'Zona ' + prefijo + ' - Celda ' + prefijo + i;
                if(!dbReservas.some(r => r.celda === celda)) {
                    let opt = document.createElement('option'); opt.value = celda; opt.innerText = celda; select.appendChild(opt);
                }
            }
        }
        function actualizarInterfaz() {
            const c = dbVehiculos.filter(v => v.tipo === 'Automovil' || v.tipo === 'Carro').length + dbReservas.filter(r => r.tipo === 'Automovil').length;
            const m = dbVehiculos.filter(v => v.tipo === 'Moto').length + dbReservas.filter(r => r.tipo === 'Moto').length;
            if(document.getElementById('badgeCarros')) {
                document.getElementById('badgeCarros').innerText = 'DISPONIBLES: ' + (MAX_CARROS - c) + ' / ' + MAX_CARROS;
                document.getElementById('badgeMotos').innerText = 'DISPONIBLES: ' + (MAX_MOTOS - m) + ' / ' + MAX_MOTOS;
            }
        }
        
        function agregarLog(m, e) {
            const box = document.getElementById('logBox'); if(!box) return;
            const horaActual = new Date().toLocaleTimeString();
            box.innerHTML += '<div class="log-line">> [' + horaActual + '] ' + m + '</div>';
            box.scrollTop = box.scrollHeight;
        }
        window.onload = inicializar;
    </script>
</body>
</html>