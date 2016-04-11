package dk.itu.ssas.project;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;



/**
 * Servlet implementation class Downloader
 */
@WebServlet("/Downloader")
public class Downloader extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * @see HttpServlet#HttpServlet()
     */
    public Downloader() {
        super();
    }

    protected void imageResponse(Connection con, int imageId, HttpServletResponse response)
        throws SQLException, IOException {
        PreparedStatement st = con.prepareStatement("SELECT jpeg FROM images WHERE id = ?");
        st.setInt(1, imageId);

        ResultSet image = st.executeQuery();
        image.next();
        byte[] content = image.getBytes("jpeg");
        response.setContentType("image/jpeg");
        response.setContentLength(content.length);
        response.getOutputStream().write(content);
    }


	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		try
		{
            HttpSession session = request.getSession();
            String userIdStr = (String)session.getAttribute("user");

            // user is not logged in
            if (userIdStr == null) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
            int userId = Integer.parseInt(userIdStr);

			Connection con = DB.getConnection();

            int imageId = Integer.parseInt(request.getParameter("image_id"));

            PreparedStatement stmt = con.prepareStatement(
                "SELECT owner FROM images WHERE id = ?"
            );

            stmt.setInt(1, imageId);
            ResultSet ownerR = stmt.executeQuery();
            ownerR.next(); // advance
            int owner = ownerR.getInt("owner");

            // owner is user
            if (owner == userId || Queries.hasPermission(con, userId, imageId)) {
                imageResponse(con, imageId, response);
                return;
            }
            // we dont have permission
            else {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                return;
            }
		}
		catch (SQLException e) {
			throw new ServletException("SQL malfunction.", e);
		}
        catch (NumberFormatException e) {
            throw new ServletException("Non-numeric user-id", e);
        }
	}
}
