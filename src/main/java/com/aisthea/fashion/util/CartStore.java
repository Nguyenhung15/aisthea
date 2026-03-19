package com.aisthea.fashion.util;

import com.aisthea.fashion.model.Cart;
import com.aisthea.fashion.model.CartItem;

import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Logger;

/**
 * In-memory store that persists a logged-in user's cart across logout/login.
 *
 * <p>Lifecycle:
 * <ol>
 * <li>On <b>logout</b>: {@link #save(int, Cart)} snapshots the cart keyed by userId.</li>
 * <li>On <b>login</b>: {@link #popAndMerge(int, Cart)} retrieves the snapshot,
 * merges it into the (possibly non-empty) session cart, removes it from the
 * store and returns the merged result, or {@code null} if no snapshot exists.</li>
 * </ol>
 *
 * <p>Data lives only in the JVM — it is lost on server restart, which is
 * acceptable since users can simply browse and re-add items.
 *
 * <p>Thread-safety: {@link ConcurrentHashMap} ensures reads and writes from
 * concurrent requests are safe without explicit synchronisation.
 */
public final class CartStore {

    private static final Logger logger = Logger.getLogger(CartStore.class.getName());

    /** userId → deep-copied Cart snapshot. */
    private static final ConcurrentHashMap<Integer, Cart> store = new ConcurrentHashMap<>();

    private CartStore() {
        /* utility class */
    }

    // ------------------------------------------------------------------
    // Save (called on logout)
    // ------------------------------------------------------------------

    /**
     * Stores a deep copy of {@code cart} for {@code userId}.
     * If {@code cart} is null or empty, any existing snapshot is removed.
     */
    public static void save(int userId, Cart cart) {
        if (cart == null || cart.isEmpty()) {
            store.remove(userId);
            return;
        }
        store.put(userId, new Cart(cart));
        logger.info("[CartStore] Saved " + cart.getItems().size()
                + " item(s) for userId=" + userId);
    }

    // ------------------------------------------------------------------
    // Pop & Merge (called on login)
    // ------------------------------------------------------------------

    /**
     * Retrieves the saved snapshot for {@code userId}, merges it with
     * {@code sessionCart} and removes the snapshot from the store.
     *
     * <p>Merge rule: if a variant already exists in {@code sessionCart} its
     * quantity is kept unchanged; saved variants not in the session cart are added.
     *
     * @param userId      the authenticated user's ID
     * @param sessionCart the cart currently in the session (may be null)
     * @return the merged cart, or {@code null} if no snapshot exists.
     *         <b>Callers MUST check for null and MUST NOT overwrite session cart
     *         when null is returned.</b>
     */
    public static Cart popAndMerge(int userId, Cart sessionCart) {
        Cart saved = store.remove(userId);

        // No saved snapshot — return null so callers leave session cart untouched
        if (saved == null || saved.isEmpty()) {
            return null;
        }

        Cart base = (sessionCart != null) ? sessionCart : new Cart();

        for (CartItem savedItem : saved.getItems()) {
            int pcsId = savedItem.getProductColorSizeId();
            if (base.getItem(pcsId) == null) {
                base.addItem(new CartItem(savedItem));
            }
            // variant already present → keep session quantity unchanged
        }

        logger.info("[CartStore] Merged saved cart for userId=" + userId
                + " → session now has " + base.getItems().size() + " item(s).");
        return base;
    }

    // ------------------------------------------------------------------
    // Utility
    // ------------------------------------------------------------------

    /** Returns {@code true} if there is a saved cart snapshot for this user. */
    public static boolean hasSaved(int userId) {
        return store.containsKey(userId);
    }

    /** Explicitly removes any snapshot for this user (e.g. after order placed). */
    public static void clear(int userId) {
        store.remove(userId);
    }
}
