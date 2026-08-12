<template>
  <el-container direction="vertical" class="h-screen">
    <TheHeader />
    <el-container class="overflow-hidden">
      <TheSidebar />
      <el-main :class="isCalendar ? '!p-0 !overflow-hidden' : ''">
        <router-view />
      </el-main>
    </el-container>
  </el-container>
</template>

<script>
import TheHeader from './components/TheHeader.vue'
import TheSidebar from './components/TheSidebar.vue'

export default {
  name: 'App',
  components: { TheHeader, TheSidebar },
  computed: {
    isCalendar() {
      return this.$route.path === '/calendar'
    },
  },
}
</script>

<style>
body { margin: 0; }
.el-main { background-color: #f5f7fa; }
</style>
