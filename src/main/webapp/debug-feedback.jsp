<%@ page contentType="text/html;charset=UTF-8" language="java" import="java.sql.*,com.aisthea.fashion.dao.DBConnection"
    %>
    <% Connection c=DBConnection.getConnection(); PreparedStatement p=c.prepareStatement("SELECT
        feedbackid,userid,productid,rating,comment,status,createdat FROM feedback ORDER BY feedbackid DESC"); ResultSet
        r=p.executeQuery(); %>
        <html>

        <body style="font-family:monospace;padding:20px">
            <h2>Feedback Table</h2>
            <table border="1" cellpadding="6">
                <tr>
                    <th>id</th>
                    <th>userid</th>
                    <th>productid</th>
                    <th>rating</th>
                    <th>comment</th>
                    <th>STATUS</th>
                    <th>created</th>
                </tr>
                <% int n=0;while(r.next()){n++;%>
                    <tr>
                        <td>
                            <%=r.getInt(1)%>
                        </td>
                        <td>
                            <%=r.getInt(2)%>
                        </td>
                        <td>
                            <%=r.getInt(3)%>
                        </td>
                        <td>
                            <%=r.getInt(4)%>
                        </td>
                        <td>
                            <%=r.getString(5)%>
                        </td>
                        <td><b>
                                <%=r.getString(6)%>
                            </b></td>
                        <td>
                            <%=r.getTimestamp(7)%>
                        </td>
                    </tr>
                    <%}%>
            </table>
            <p><b>Total: <%=n%></b></p>
            <%r.close();p.close();c.close();%>
        </body>

        </html>