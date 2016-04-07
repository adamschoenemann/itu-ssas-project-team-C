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
        // TODO Auto-generated constructor stub
    }


	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			 // TODO: check session state
			Connection con = DB.getConnection();

			PreparedStatement st = con.prepareStatement(
                "INSERT INTO comments (image_id, user_id, comment) VALUES (?, ?, ?)"
            );
            st.setInt(1, Integer.parseInt((String)request.getParameter("image_id")));
            st.setInt(2, Integer.parseInt((String)request.getSession().getAttribute("user")));
            st.setString(3, (String)request.getParameter("comment"));

            st.executeUpdate();

			response.sendRedirect("main.jsp");
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
