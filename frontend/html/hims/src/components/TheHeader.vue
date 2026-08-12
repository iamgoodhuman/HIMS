<template>
  <el-header class="!bg-white shadow-sm flex items-center justify-between !h-14 border-b border-gray-200">
    <div class="flex items-center gap-2">
      <el-icon :size="24" color="#409EFF"><HomeFilled /></el-icon>
      <span class="text-lg font-bold text-gray-800">家庭信息管理系统</span>
    </div>
    <div class="flex items-center gap-4">
      <el-badge :value="2" :max="9">
        <el-icon :size="20" color="#909399"><Bell /></el-icon>
      </el-badge>
      <el-dropdown>
        <span class="flex items-center gap-2 cursor-pointer">
          <el-avatar :size="32" icon="UserFilled" />
          <span class="font-medium">张三</span>
        </span>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item>个人中心</el-dropdown-item>
            <el-dropdown-item>退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </el-header>
</template>

<script>
import { HomeFilled, Bell } from '@element-plus/icons-vue'

export default {
  name: 'TheHeader',
  components: { HomeFilled, Bell },
}
</script>
