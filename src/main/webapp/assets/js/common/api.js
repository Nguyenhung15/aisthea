/**
 * API Client for making HTTP requests
 */

const API = {
    baseURL: window.location.origin + '/FashionProject',

    /**
     * Make HTTP request
     */
    async request(url, options = {}) {
        const config = {
            headers: {
                'Content-Type': 'application/json',
                ...options.headers
            },
            ...options
        };

        try {
            const response = await fetch(`${this.baseURL}${url}`, config);

            // Handle non-OK responses
            if (!response.ok) {
                const error = await response.text();
                throw new Error(error || `HTTP error! status: ${response.status}`);
            }

            // Try to parse JSON
            const contentType = response.headers.get('content-type');
            if (contentType && contentType.includes('application/json')) {
                return await response.json();
            }

            return await response.text();

        } catch (error) {
            console.error('API request failed:', error);
            throw error;
        }
    },

    /**
     * GET request
     */
    async get(url, params = {}) {
        const queryString = new URLSearchParams(params).toString();
        const fullUrl = queryString ? `${url}?${queryString}` : url;
        return this.request(fullUrl, { method: 'GET' });
    },

    /**
     * POST request
     */
    async post(url, data = {}) {
        return this.request(url, {
            method: 'POST',
            body: JSON.stringify(data)
        });
    },

    /**
     * PUT request
     */
    async put(url, data = {}) {
        return this.request(url, {
            method: 'PUT',
            body: JSON.stringify(data)
        });
    },

    /**
     * DELETE request
     */
    async delete(url) {
        return this.request(url, { method: 'DELETE' });
    },

    /**
     * POST with FormData (for file uploads)
     */
    async postFormData(url, formData) {
        return fetch(`${this.baseURL}${url}`, {
            method: 'POST',
            body: formData
            // Don't set Content-Type header - browser will set it with boundary
        }).then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        });
    },

    // Convenience methods for common endpoints

    /**
     * User API
     */
    user: {
        async login(email, password) {
            return API.post('/login', { email, password });
        },

        async register(userData) {
            return API.post('/register', userData);
        },

        async logout() {
            return API.post('/logout');
        },

        async getProfile() {
            return API.get('/profile');
        },

        async updateProfile(userData) {
            return API.put('/profile', userData);
        }
    },

    /**
     * Product API
     */
    product: {
        async getAll(params = {}) {
            return API.get('/product', params);
        },

        async getById(id) {
            return API.get(`/product/${id}`);
        },

        async search(query) {
            return API.get('/product', { search: query });
        }
    },

    /**
     * Cart API
     */
    cart: {
        async get() {
            return API.get('/cart');
        },

        async add(productId, quantity = 1) {
            return API.post('/cart', { productId, quantity });
        },

        async update(itemId, quantity) {
            return API.put(`/cart/${itemId}`, { quantity });
        },

        async remove(itemId) {
            return API.delete(`/cart/${itemId}`);
        }
    },

    /**
     * Order API
     */
    order: {
        async create(orderData) {
            return API.post('/order', orderData);
        },

        async getAll() {
            return API.get('/order');
        },

        async getById(id) {
            return API.get(`/order/${id}`);
        }
    }
};

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = API;
}
