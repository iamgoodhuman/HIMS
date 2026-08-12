<template>
  <el-aside width="220px" class="!bg-gray-800 border-r border-gray-700">
    <el-menu
      :default-active="$route.path"
      router
      background-color="#1f2937"
      text-color="#fff"
      active-text-color="#409EFF"
      class="!border-none"
    >
      <el-menu-item v-for="item in navItems" :key="item.path" :index="item.path">
        <el-icon><component :is="item.icon" /></el-icon>
        <span>{{ item.label }}</span>
      </el-menu-item>

      <el-sub-menu index="/kitchen">
        <template #title>
          <el-icon><Food /></el-icon>
          <span>家庭厨房助手</span>
        </template>
        <el-menu-item v-for="child in kitchenChildren" :key="child.path" :index="child.path">
          <el-icon><component :is="child.icon" /></el-icon>
          <span>{{ child.label }}</span>
        </el-menu-item>
      </el-sub-menu>
    </el-menu>

    <div class="p-4 border-t border-gray-700">
      <el-menu
        background-color="#1f2937"
        text-color="#fff"
        active-text-color="#409EFF"
        class="!border-none"
      >
        <el-menu-item index="settings">
          <el-icon><Setting /></el-icon>
          <span>系统设置</span>
        </el-menu-item>
      </el-menu>
    </div>
  </el-aside>
</template>

<script>
import {
  DataBoard, Shield, Money, House, Calendar, Food, Setting,
  Apple, Reading,
} from '@element-plus/icons-vue'

export default {
  name: 'TheSidebar',
  data() {
    return {
      navItems: [
        { path: '/dashboard', icon: 'DataBoard', label: '首页看板' },
        { path: '/insurance', icon: 'Shield', label: '保险管理' },
        { path: '/finance', icon: 'Money', label: '财务管理' },
        { path: '/assets', icon: 'House', label: '固定财产' },
        { path: '/calendar', icon: 'Calendar', label: '共享日历' },
      ],
      kitchenChildren: [
        { path: '/kitchen/food', icon: 'Apple', label: '食物管理' },
        { path: '/kitchen/recipe', icon: 'Reading', label: '食谱推荐' },
      ],
    }
  },
  components: { DataBoard, Shield, Money, House, Calendar, Food, Setting, Apple, Reading },
}
</script>
