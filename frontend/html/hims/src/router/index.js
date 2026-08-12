import { createRouter, createWebHistory } from 'vue-router'
import DashboardView from '../components/views/DashboardView.vue'
import InsuranceView from '../components/views/InsuranceView.vue'
import FinanceView from '../components/views/FinanceView.vue'
import AssetsView from '../components/views/AssetsView.vue'
import CalendarView from '../components/views/CalendarView.vue'
import KitchenView from '../components/views/KitchenView.vue'

const routes = [
  { path: '/', redirect: '/dashboard' },
  { path: '/dashboard', name: 'dashboard', component: DashboardView },
  { path: '/insurance', name: 'insurance', component: InsuranceView },
  { path: '/finance', name: 'finance', component: FinanceView },
  { path: '/assets', name: 'assets', component: AssetsView },
  { path: '/calendar', name: 'calendar', component: CalendarView },
  { path: '/kitchen/food', name: 'kitchen-food', component: KitchenView, props: { subPage: 'food' } },
  { path: '/kitchen/recipe', name: 'kitchen-recipe', component: KitchenView, props: { subPage: 'recipe' } },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
