package com.aisthea.fashion.util;

import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Set;
import java.util.UUID;
import java.util.logging.Logger;

/**
 * Shared utility for handling multipart image uploads.
 *
 * <p>All uploaded files are stored under {@link Constants#UPLOAD_DIR}/{subDir}/
 * and served by {@code ImageServlet} at {@code /uploads/{subDir}/{filename}}.
 *
 * <p>Only extensions in {@link #ALLOWED_EXTENSIONS} are accepted. Files outside
 * the whitelist are silently rejected and {@code null} is returned.
 */
public final class ImageUploadHelper {

    private static final Logger logger = Logger.getLogger(ImageUploadHelper.class.getName());

    /** Whitelist of accepted image file extensions (lowercase, dot-prefixed). */
    public static final Set<String> ALLOWED_EXTENSIONS =
            Set.of(".jpg", ".jpeg", ".png", ".gif", ".webp");

    /** Extended whitelist that also accepts video files (for evidence uploads etc.). */
    public static final Set<String> ALLOWED_MEDIA_EXTENSIONS =
            Set.of(".jpg", ".jpeg", ".png", ".gif", ".webp", ".mp4", ".mov", ".webm");

    private ImageUploadHelper() {
        throw new IllegalStateException("Utility class");
    }

    /**
     * Saves an uploaded file to {@code UPLOAD_DIR/subDir/} and returns the
     * relative path suitable for storing in the database:
     * <pre>{@code subDir/uuid.ext}</pre>
     *
     * <p>Returns {@code null} when:
     * <ul>
     *   <li>the {@link Part} is null or empty (no file selected),</li>
     *   <li>the submitted filename is blank,</li>
     *   <li>the file extension is not in {@link #ALLOWED_EXTENSIONS}.</li>
     * </ul>
     *
     * @param filePart multipart file part from the HTTP request (may be null)
     * @param subDir   sub-directory name inside UPLOAD_DIR, e.g. {@code "feedback"} or {@code "avatars"}
     * @return relative path like {@code "feedback/uuid.jpg"}, or {@code null}
     * @throws IOException if writing the file fails
     */
    public static String save(Part filePart, String subDir) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String submittedName = filePart.getSubmittedFileName();
        if (submittedName == null || submittedName.isBlank()) {
            logger.warning("[ImageUploadHelper] Part has no submitted filename, skipping.");
            return null;
        }

        // Sanitise: strip any directory separators from client-supplied name
        String originalName = Paths.get(submittedName).getFileName().toString();

        // Extension check
        String ext = "";
        int dot = originalName.lastIndexOf('.');
        if (dot >= 0) {
            ext = originalName.substring(dot).toLowerCase();
        }

        if (!ALLOWED_EXTENSIONS.contains(ext)) {
            logger.warning("[ImageUploadHelper] Rejected upload — disallowed extension '" + ext
                    + "' for file: " + originalName);
            return null;
        }

        // Ensure the target directory exists
        Path dir = Paths.get(Constants.UPLOAD_DIR, subDir);
        if (!Files.exists(dir)) {
            Files.createDirectories(dir);
            logger.info("[ImageUploadHelper] Created directory: " + dir);
        }

        // Save with a UUID name to avoid collisions and path-traversal
        String savedName = UUID.randomUUID().toString() + ext;
        Path target = dir.resolve(savedName);

        try (InputStream in = filePart.getInputStream()) {
            Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
        }

        String relPath = subDir + "/" + savedName;
        logger.info("[ImageUploadHelper] Saved: " + target + "  DB path: " + relPath);
        return relPath;
    }

    /**
     * Like {@link #save(Part, String)} but accepts both image AND video files
     * using the {@link #ALLOWED_MEDIA_EXTENSIONS} whitelist.
     */
    public static String saveMedia(Part filePart, String subDir) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        String submittedName = filePart.getSubmittedFileName();
        if (submittedName == null || submittedName.isBlank()) {
            return null;
        }

        String originalName = Paths.get(submittedName).getFileName().toString();
        String ext = "";
        int dot = originalName.lastIndexOf('.');
        if (dot >= 0) {
            ext = originalName.substring(dot).toLowerCase();
        }

        if (!ALLOWED_MEDIA_EXTENSIONS.contains(ext)) {
            logger.warning("[ImageUploadHelper] Rejected media upload — disallowed extension '" + ext
                    + "' for file: " + originalName);
            return null;
        }

        Path dir = Paths.get(Constants.UPLOAD_DIR, subDir);
        if (!Files.exists(dir)) {
            Files.createDirectories(dir);
        }

        String savedName = UUID.randomUUID().toString() + ext;
        Path target = dir.resolve(savedName);

        try (InputStream in = filePart.getInputStream()) {
            Files.copy(in, target, StandardCopyOption.REPLACE_EXISTING);
        }

        String relPath = subDir + "/" + savedName;
        logger.info("[ImageUploadHelper] Saved media: " + target + "  DB path: " + relPath);
        return relPath;
    }
}
