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

    protected void imageResponse(Connection con, String image_id, HttpServletResponse response)
        throws SQLException, IOException {
        // TODO: Use prepared statement
        Statement st = con.createStatement();
        // TODO: Include permission check
        ResultSet image = st.executeQuery("SELECT jpeg FROM images WHERE id = " + image_id);
        image.next();
        byte[] content = image.getBytes("jpeg");
        response.setContentType("image/jpeg");
        response.setContentLength(content.length);
        response.getOutputStream().write(content);
    }

    protected boolean hasPermission(Connection con, int userId, String imageId)
        throws SQLException {

        PreparedStatement s = con.prepareStatement("SELECT * FROM perms WHERE image_id = ?");
        s.setString(1, imageId);

        ResultSet permsR = s.executeQuery();

        while(permsR.next()) {
            int sharedWith = permsR.getInt("user_id");
            if (sharedWith == userId) {
                return true;
            }
        }
        return false;
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
 		// TODO: Check session state
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

            String ownerQ = "SELECT owner FROM images WHERE id = ?";
            PreparedStatement stmt = con.prepareStatement(ownerQ);
            String image_id = request.getParameter("image_id");

            stmt.setString(1, image_id);
            ResultSet ownerR = stmt.executeQuery();
            ownerR.next(); // advance
            int owner = ownerR.getInt("owner");

            // owner is user
            if (owner == userId || hasPermission(con, userId, image_id)) {
                imageResponse(con, image_id, response);
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
