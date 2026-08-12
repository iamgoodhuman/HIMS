<template>
  <div>
    <h2 class="text-2xl font-bold mb-6">欢迎回家，张三！家庭资产总览</h2>

    <el-row :gutter="20" class="mb-6">
      <el-col :span="8">
        <el-card shadow="hover" class="!border-l-4 !border-l-red-500">
          <p class="text-gray-500 text-sm mb-2">即将到期保险</p>
          <p class="text-3xl font-bold">2 件</p>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card shadow="hover" class="!border-l-4 !border-l-green-500">
          <p class="text-gray-500 text-sm mb-2">本月收支结余</p>
          <p class="text-3xl font-bold text-green-600">+¥12,500</p>
        </el-card>
      </el-col>
      <el-col :span="8">
        <el-card shadow="hover" class="!border-l-4 !border-l-blue-500">
          <p class="text-gray-500 text-sm mb-2">家庭资产总值</p>
          <p class="text-3xl font-bold">¥850,000</p>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="12">
        <el-card shadow="hover">
          <template #header>
            <span class="font-bold">即将到期提醒</span>
          </template>
          <el-timeline>
            <el-timeline-item timestamp="剩 5 天到期" type="danger">
              张三-重疾险
            </el-timeline-item>
            <el-timeline-item timestamp="剩 12 天到期" type="warning">
              李四-车险
            </el-timeline-item>
            <el-timeline-item timestamp="剩 3 天" type="info">
              房贷还款日
            </el-timeline-item>
          </el-timeline>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card shadow="hover">
          <template #header>
            <span class="font-bold">月度财务趋势</span>
          </template>
          <div class="space-y-4">
            <div>
              <span class="text-sm text-gray-500">收入: ¥15,000</span>
              <el-progress :percentage="75" :stroke-width="20" color="#67C23A" />
            </div>
            <div>
              <span class="text-sm text-gray-500">支出: ¥2,500</span>
              <el-progress :percentage="40" :stroke-width="20" color="#F56C6C" />
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'DashboardView',
}
</script>
