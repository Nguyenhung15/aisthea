package com.aisthea.fashion.controller;

import com.aisthea.fashion.util.Constants;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;

/**
 * Serves uploaded user files (product images, avatars, etc.) from the
 * external UPLOAD_DIR directory (outside the web root).
 *
 * <p>Security measures:
 * <ul>
 *   <li>Path-traversal prevention — canonical path must start with UPLOAD_DIR.</li>
 *   <li>Only GET is allowed; all other methods return 405.</li>
 * </ul>
 *
 * <p>Performance features:
 * <ul>
 *   <li>ETag + Last-Modified headers for browser-side caching.</li>
 *   <li>Cache-Control: public, max-age=86400 (1 day) for CDN / proxy caching.</li>
 *   <li>Efficient NIO streaming via Files.copy().</li>
 * </ul>
 */
@WebServlet(name = "ImageServlet", urlPatterns = { "/uploads/*" })
public class ImageServlet extends HttpServlet {

    // ─── Resolved canonical path of the upload root ───────────────────────────
    private String uploadDirCanonical;

    @Override
    public void init() throws ServletException {
        try {
            File dir = new File(Constants.UPLOAD_DIR);
            uploadDirCanonical = dir.getCanonicalPath();
        } catch (IOException e) {
            throw new ServletException("Failed to resolve UPLOAD_DIR: " + Constants.UPLOAD_DIR, e);
        }
    }

    // ─── GET ──────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // Remove leading slash; pathInfo looks like "/product/abc123.jpg"
        String relativePath = pathInfo.substring(1);

        // ── Security: prevent path traversal ──────────────────────────────────
        File requestedFile  = new File(Constants.UPLOAD_DIR, relativePath);
        String canonicalPath = requestedFile.getCanonicalPath();

        if (!canonicalPath.startsWith(uploadDirCanonical + File.separator)
                && !canonicalPath.equals(uploadDirCanonical)) {
            res.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (!requestedFile.exists() || !requestedFile.isFile()) {
            res.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // ── Caching: ETag + Last-Modified ─────────────────────────────────────
        long lastModified = requestedFile.lastModified();
        String etag       = "\"" + Long.toHexString(lastModified) + "-"
                            + Long.toHexString(requestedFile.length()) + "\"";

        res.setHeader("ETag", etag);
        res.setDateHeader("Last-Modified", lastModified);
        res.setHeader("Cache-Control", "public, max-age=86400"); // 1 day

        // 304 Not Modified
        String ifNoneMatch    = req.getHeader("If-None-Match");
        long   ifModifiedSince = req.getDateHeader("If-Modified-Since");

        if (etag.equals(ifNoneMatch)
                || (ifModifiedSince != -1 && lastModified <= ifModifiedSince + 1000)) {
            res.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
            return;
        }

        // ── MIME type ─────────────────────────────────────────────────────────
        String contentType = getServletContext().getMimeType(requestedFile.getName());
        if (contentType == null) {
            contentType = "application/octet-stream";
        }

        res.setContentType(contentType);
        res.setContentLengthLong(requestedFile.length());

        // ── Stream file to client ─────────────────────────────────────────────
        try (InputStream  in  = Files.newInputStream(requestedFile.toPath());
             OutputStream out = res.getOutputStream()) {
            byte[] buffer = new byte[8192];
            int    bytes;
            while ((bytes = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytes);
            }
        }
    }
}
