package dk.itu.ssas.project;

import java.sql.*;

class Queries {

    public static boolean hasPermission(Connection con, int userId, int imageId)
        throws SQLException {

        PreparedStatement s = con.prepareStatement("SELECT * FROM perms WHERE image_id = ?");
        s.setInt(1, imageId);

        ResultSet permsR = s.executeQuery();

        while(permsR.next()) {
            int sharedWith = permsR.getInt("user_id");
            if (sharedWith == userId) {
                return true;
            }
        }
        return false;
    }

    public static int getImageUserId(Connection con, int imageId)
        throws SQLException {

        PreparedStatement s =
            con.prepareStatement("SELECT owner FROM images WHERE id = ?");

        s.setInt(1, imageId);

        ResultSet r = s.executeQuery();
        r.next();
        return r.getInt("owner");
    }
}