import { createRouter, createWebHistory } from 'vue-router'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'legalcheck',
      component: () => import('../views/LegalCheckView.vue'),
    },
  ],
})

export default router
