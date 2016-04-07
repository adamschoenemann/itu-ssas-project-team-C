package dk.itu.ssas.project;

import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Comment
 */
@WebServlet("/Comment")
public class Comment extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public Comment() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			 // TODO: check session state
			Connection con = DB.getConnection();
            String userIdStr = (String) request.getSession().getAttribute("user");

            // user not logged in
            if (userIdStr == null) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }

            int userId = Integer.parseInt(userIdStr);
            int imageId = Integer.parseInt(request.getParameter("image_id"));
            int imageUserId = Queries.getImageUserId(con, imageId);

            if (userId == imageUserId || Queries.hasPermission(con, userId, imageId)) {
                PreparedStatement st = con.prepareStatement(
                    "INSERT INTO comments (image_id, user_id, comment) VALUES (?, ?, ?)"
                );
                st.setInt(1, imageId);
                st.setInt(2, userId);
                st.setString(3, (String)request.getParameter("comment"));

                st.executeUpdate();

                response.sendRedirect("main.jsp");
            } else {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
		}
		catch (SQLException e)
		{
            throw new ServletException("SQL malfunction.", e);
		}
        catch (NumberFormatException e) {
            throw new ServletException("Incorect numeric parameter", e);
        }
	}

}
