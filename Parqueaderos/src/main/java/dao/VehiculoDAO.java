package dao;

import config.ConexionBD;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VehiculoDAO {
    private Connection conexion;

    public VehiculoDAO() {
        try {
            // Ajustado a la instancia estándar de tu proyecto
            ConexionBD cx = new ConexionBD();
            this.conexion = cx.conectar(); 
        } catch (Exception e) {
            System.out.println("❌ Error al inicializar la conexion en el DAO: " + e);
        }
    }

    // 1. REGISTRAR ENTRADA EN MYSQL CON RASTREADOR DE CONSOLA
    public boolean insertarVehiculo(String placa, String tipo, long horaIngreso) {
        if (placa == null || placa.trim().isEmpty()) {
            System.out.println("⚠️ DAO RECHAZÓ: La placa llegó completamente vacía.");
            return false;
        }
        
        try {
            System.out.println("🔎 DAO BUSCANDO DUPLICADOS PARA LA PLACA: [" + placa + "]");
            
            String verificarSql = "SELECT id FROM vehiculos WHERE placa = ? AND estado = 'ACTIVO'";
            PreparedStatement psVerificar = conexion.prepareStatement(verificarSql);
            psVerificar.setString(1, placa);
            ResultSet rs = psVerificar.executeQuery();
            
            if (rs.next()) {
                System.out.println("⚠️ DAO ENCONTRÓ DUPLICADO: El id " + rs.getInt("id") + " ya está ACTIVO.");
                return false; 
            }

            String sql = "INSERT INTO vehiculos (placa, tipo, hora_ingreso, estado) VALUES (?, ?, ?, 'ACTIVO')";
            PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setString(1, placa);
            ps.setString(2, tipo);
            ps.setLong(3, horaIngreso);

            int filasAfectadas = ps.executeUpdate();
            return filasAfectadas > 0;
        } catch (Exception e) {
            System.out.println("❌ Error grave en DAO: " + e);
        }
        return false;
    }

    // 2. LISTAR VEHÍCULOS ACTIVOS EN PATIO
    public List<Map<String, Object>> listarVehiculosActivos() {
        List<Map<String, Object>> lista = new ArrayList<>();
        String sql = "SELECT placa, tipo, hora_ingreso FROM vehiculos WHERE estado = 'ACTIVO'";
        try {
            PreparedStatement ps = conexion.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> v = new HashMap<>();
                v.put("placa", rs.getString("placa"));
                v.put("tipo", rs.getString("tipo"));
                v.put("hora", rs.getLong("hora_ingreso"));
                lista.add(v);
            }
        } catch (Exception e) {
            System.out.println("❌ Error al listar activos: " + e);
        }
        return lista;
    }

    // 3. OBTENER HORA DE INGRESO
    public long obtenerHoraIngreso(String placa) {
        String sql = "SELECT hora_ingreso FROM vehiculos WHERE placa = ? AND estado = 'ACTIVO'";
        try {
            PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setString(1, placa);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getLong("hora_ingreso");
            }
        } catch (Exception e) {
            System.out.println("❌ Error al obtener hora: " + e);
        }
        return -1;
    }

    // 4. OBTENER TIPO DE VEHÍCULO
    public String obtenerTipoVehiculo(String placa) {
        String sql = "SELECT tipo FROM vehiculos WHERE placa = ? AND estado = 'ACTIVO'";
        try {
            PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setString(1, placa);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("tipo");
            }
        } catch (Exception e) {
            System.out.println("❌ Error al obtener tipo: " + e);
        }
        return null;
    }

    // 5. REGISTRAR SALIDA (CAMBIAR ESTADO)
    public boolean registrarSalida(String placa) {
        String sql = "UPDATE vehiculos SET estado = 'INACTIVO' WHERE placa = ? AND estado = 'ACTIVO'";
        try {
            PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setString(1, placa);
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (Exception e) {
            System.out.println("❌ Error al registrar salida: " + e);
        }
        return false;
    }

    // 6. GUARDAR RECAUDO EN LA TABLA PAGOS
    public boolean registrarPago(String placa, String tipo, int minutes, int valor) {
        String sql = "INSERT INTO pagos (placa, tipo_vehiculo, minutos_parqueo, valor_pagado) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = conexion.prepareStatement(sql);
            ps.setString(1, placa);
            ps.setString(2, tipo);
            ps.setInt(3, minutes);
            ps.setInt(4, valor);
            int filas = ps.executeUpdate();
            return filas > 0;
        } catch (Exception e) {
            System.out.println("❌ Error al registrar pago: " + e);
        }
        return false;
    }
}