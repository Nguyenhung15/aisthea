package com.aisthea.fashion.controller;

import com.aisthea.fashion.dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

public class DebugDBServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<html><body style='font-family:monospace;padding:20px;'>");
        out.println("<h1>🔍 DB Debug Info</h1>");

        // Step 1: Test connection
        out.println("<h2>Step 1: Connection Test</h2>");
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                out.println("<p style='color:red;font-weight:bold;'>❌ DBConnection.getConnection() returned NULL!</p>");
                out.println("<p>This means the JDBC driver is not loaded or the DB is unreachable from Tomcat.</p>");
                out.println("<p>Check Tomcat console for error details.</p>");
                out.println("</body></html>");
                return;
            }
            out.println("<p style='color:green;font-weight:bold;'>✅ Connection SUCCESS</p>");
            out.println("<p>Database: " + conn.getCatalog() + "</p>");
        } catch (Exception e) {
            out.println("<p style='color:red;'>❌ Exception: " + e.getMessage() + "</p>");
            out.println("</body></html>");
            return;
        }

        // Step 2: Check table structure
        out.println("<h2>Step 2: Table 'Users' Columns</h2>");
        try {
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet rs = metaData.getColumns(null, null, "Users", null);
            boolean found = false;
            out.println("<table border='1' cellpadding='5'><tr><th>Column</th><th>Type</th><th>Size</th></tr>");
            while (rs.next()) {
                found = true;
                out.println("<tr><td>" + rs.getString("COLUMN_NAME") + "</td><td>" + rs.getString("TYPE_NAME") + "</td><td>" + rs.getInt("COLUMN_SIZE") + "</td></tr>");
            }
            out.println("</table>");
            rs.close();

            if (!found) {
                out.println("<p style='color:orange;'>⚠️ Table 'Users' not found! Trying other variations...</p>");
                // Try to list all tables
                ResultSet tables = metaData.getTables(null, null, "%", new String[]{"TABLE"});
                out.println("<p><b>All tables in this database:</b></p><ul>");
                while (tables.next()) {
                    out.println("<li>" + tables.getString("TABLE_SCHEM") + "." + tables.getString("TABLE_NAME") + "</li>");
                }
                out.println("</ul>");
                tables.close();
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error reading metadata: " + e.getMessage() + "</p>");
        }

        // Step 3: Try to query a user
        out.println("<h2>Step 3: Sample User Query</h2>");
        try (Statement stmt = conn.createStatement()) {
            ResultSet rs = stmt.executeQuery("SELECT TOP 3 email, fullname, role, active FROM Users");
            out.println("<table border='1' cellpadding='5'><tr><th>Email</th><th>Fullname</th><th>Role</th><th>Active</th></tr>");
            boolean hasRows = false;
            while (rs.next()) {
                hasRows = true;
                out.println("<tr><td>" + rs.getString("email") + "</td><td>" + rs.getString("fullname") + "</td><td>" + rs.getString("role") + "</td><td>" + rs.getBoolean("active") + "</td></tr>");
            }
            out.println("</table>");
            rs.close();
            if (!hasRows) {
                out.println("<p style='color:orange;'>⚠️ No users found in the Users table!</p>");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>❌ Query Error: " + e.getMessage() + "</p>");
            out.println("<p>This likely means column names in DAO don't match the actual DB columns.</p>");
        }

        // Step 4: Test findByEmail with a specific email
        String testEmail = request.getParameter("email");
        if (testEmail != null && !testEmail.isEmpty()) {
            out.println("<h2>Step 4: Test findByEmail('" + testEmail + "')</h2>");
            try (PreparedStatement ps = conn.prepareStatement("SELECT * FROM Users WHERE email = ?")) {
                ps.setString(1, testEmail.trim());
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    out.println("<p style='color:green;'>✅ User FOUND!</p>");
                    ResultSetMetaData rsMeta = rs.getMetaData();
                    out.println("<table border='1' cellpadding='5'>");
                    for (int i = 1; i <= rsMeta.getColumnCount(); i++) {
                        String colName = rsMeta.getColumnName(i);
                        String value = rs.getString(i);
                        if ("password".equalsIgnoreCase(colName) && value != null) {
                            // Show only first 10 chars of password hash
                            value = value.substring(0, Math.min(10, value.length())) + "...";
                        }
                        out.println("<tr><td><b>" + colName + "</b></td><td>" + value + "</td></tr>");
                    }
                    out.println("</table>");
                } else {
                    out.println("<p style='color:red;'>❌ User NOT found with email: " + testEmail + "</p>");
                }
                rs.close();
            } catch (Exception e) {
                out.println("<p style='color:red;'>❌ Error: " + e.getMessage() + "</p>");
            }
        }

        out.println("<hr><h2>Test Login Email</h2>");
        out.println("<form method='GET'><input type='email' name='email' placeholder='Enter email to test' style='padding:8px;width:300px;'> ");
        out.println("<button type='submit' style='padding:8px 16px;'>Test</button></form>");

        try { conn.close(); } catch (Exception ignored) {}
        out.println("</body></html>");
    }
}
