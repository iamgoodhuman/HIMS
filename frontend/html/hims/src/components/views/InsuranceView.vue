<template>
  <div>
    <h2 class="text-2xl font-bold mb-6">保险管理</h2>

    <el-card shadow="never" class="mb-6">
      <div class="flex items-center gap-4 flex-wrap">
        <el-radio-group v-model="filter.member">
          <el-radio-button label="">全部</el-radio-button>
          <el-radio-button label="我的">我的</el-radio-button>
          <el-radio-button label="配偶">配偶</el-radio-button>
        </el-radio-group>
        <el-select v-model="filter.type" placeholder="所有险种" clearable style="width: 150px">
          <el-option label="重疾险" value="重疾险" />
          <el-option label="车险" value="车险" />
        </el-select>
        <el-input v-model="filter.keyword" placeholder="搜索..." clearable style="width: 200px" />
        <el-button type="primary">+ 录入保险</el-button>
      </div>
    </el-card>

    <el-row :gutter="20">
      <el-col :span="8" v-for="ins in list" :key="ins.name">
        <el-card shadow="hover" class="mb-4">
          <template #header>
            <div class="flex justify-between items-center">
              <span class="font-bold">{{ ins.name }}</span>
              <el-tag :type="ins.urgent ? 'danger' : 'warning'">{{ ins.urgent ? '即将到期' : '有效' }}</el-tag>
            </div>
          </template>
          <el-descriptions :column="1" size="small">
            <el-descriptions-item label="保险公司">{{ ins.company }}</el-descriptions-item>
            <el-descriptions-item label="保额">{{ ins.amount }}</el-descriptions-item>
            <el-descriptions-item label="生效日期">{{ ins.start }}</el-descriptions-item>
            <el-descriptions-item label="到期日期">
              <span :class="{ 'text-red-500 font-bold': ins.urgent }">{{ ins.end }}</span>
            </el-descriptions-item>
          </el-descriptions>
          <div class="flex justify-end gap-2 mt-3">
            <el-button text type="primary" size="small">详情</el-button>
            <el-button text type="success" size="small">编辑</el-button>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'InsuranceView',
  data() {
    return {
      filter: { member: '', type: '', keyword: '' },
      list: [
        { name: '重疾险 (张三)', company: '平安', amount: '50 万', start: '2022-11-25', end: '2023-11-25 (剩5天)', urgent: true },
        { name: '车险 (李四)', company: '人保', amount: '100 万', start: '2022-12-01', end: '2023-12-01', urgent: false },
      ],
    }
  },
}
</script>
