DROP USER SSAS@localhost;

CREATE USER photoshare IDENTIFIED BY 'ssas16teamC';

GRANT ALL ON image_site_db.* TO photoshare;
