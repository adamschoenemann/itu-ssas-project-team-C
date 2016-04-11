package dk.itu.ssas.project.csrf;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.annotation.*;
import java.security.SecureRandom;
import java.math.BigInteger;

@WebFilter(filterName = "LoadToken", urlPatterns = "/*")
public class LoadToken implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
        throws IOException, ServletException {

        // Assume its HTTP
        HttpServletRequest httpReq = (HttpServletRequest) request;

        String token = (String) httpReq.getSession().getAttribute(CSRFConfig.tokenKey());

        if (token == null) {
        // Generate the token and store it in the users cache
            token = genToken();
            httpReq.getSession().setAttribute(CSRFConfig.tokenKey(), token);
        }
        // Add the token to the current request so it can be used
        // by the page rendered in this request
        httpReq.setAttribute(CSRFConfig.tokenKey(), token);

        chain.doFilter(request, response);
    }


    private String genToken() {
        SecureRandom random = new SecureRandom();
        return new BigInteger(130, random).toString(32);
    }


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}