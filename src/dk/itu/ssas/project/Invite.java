package dk.itu.ssas.project;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Invite
 */
@WebServlet("/Invite")
public class Invite extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public Invite() {
        super();
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try
		{
			Connection con = DB.getConnection();

            String userIdStr = (String)request.getSession().getAttribute("user");
            if (userIdStr == null) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            int userId = Integer.parseInt(userIdStr);
            int imageId = Integer.parseInt(request.getParameter("image_id"));
            int owner = Queries.getImageUserId(con, imageId);
            String otherUser = (String) request.getParameter("other");

            if (userId == owner) {

                PreparedStatement st = con.prepareStatement(
                    "INSERT INTO perms (image_id, user_id) " +
                    "SELECT ?, users.id FROM users " +
                    "WHERE users.username = ?"
                );

                st.setInt(1, imageId);
                st.setString(2, otherUser);

                st.executeUpdate();

                response.sendRedirect("main");
            } else {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }


		}
		catch (SQLException e)
		{
			throw new ServletException("SQL malfunction.", e);
		}
        catch (NumberFormatException e)
        {
            throw new ServletException("Incorrect numeric parameter");
        }
	}
}
