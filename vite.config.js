import {defineConfig} from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    watch: {ignored: ['**/map/**', '**/comp/**', '**/audio/**']},
    proxy: {
      '/api': 'https://dictum.coffland.com'
    }
  }
})
