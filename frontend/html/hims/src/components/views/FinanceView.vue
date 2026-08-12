<template>
  <div>
    <div class="flex justify-between items-center mb-6">
      <h2 class="text-2xl font-bold">家庭财务</h2>
      <div class="flex gap-2">
        <el-button type="primary">+ 记账</el-button>
        <el-button>导入账单</el-button>
      </div>
    </div>

    <el-row :gutter="20">
      <el-col :span="16">
        <el-card shadow="never">
          <template #header>
            <span class="font-bold">收支明细</span>
          </template>
          <el-table :data="records" stripe>
            <el-table-column prop="date" label="日期" width="100" />
            <el-table-column prop="cat" label="分类" width="100" />
            <el-table-column label="收入">
              <template #default="{ row }">
                <span :class="row.income ? 'text-green-600' : 'text-gray-300'">{{ row.income || '-' }}</span>
              </template>
            </el-table-column>
            <el-table-column label="支出">
              <template #default="{ row }">
                <span :class="row.expense ? 'text-red-600' : 'text-gray-300'">{{ row.expense || '-' }}</span>
              </template>
            </el-table-column>
            <el-table-column prop="note" label="备注" />
          </el-table>
        </el-card>
      </el-col>

      <el-col :span="8">
        <el-card shadow="never">
          <template #header>
            <span class="font-bold">AI 财务分析助手</span>
          </template>
          <el-alert type="info" :closable="false" class="mb-4">
            <template #title>
              <div>
                <p>收入总计: <span class="text-green-600 font-bold">¥15,000</span></p>
                <p>支出总计: <span class="text-red-600 font-bold">¥1,500</span></p>
                <p>结余: <span class="font-bold">¥13,500</span></p>
              </div>
            </template>
          </el-alert>
          <div class="text-sm text-gray-700 space-y-2 mb-4">
            <p class="font-bold">AI 建议：</p>
            <p>1. 本周餐饮支出处于正常范围。</p>
            <p>2. 购物占比偏高，建议控制非必要消费。</p>
          </div>
          <el-button type="danger" class="w-full">生成月度报告</el-button>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
export default {
  name: 'FinanceView',
  data() {
    return {
      records: [
        { date: '10-01', cat: '工资', income: '15,000', expense: '', note: '张三工资' },
        { date: '10-03', cat: '餐饮', income: '', expense: '500', note: '聚餐' },
        { date: '10-05', cat: '交通', income: '', expense: '200', note: '加油' },
        { date: '10-08', cat: '购物', income: '', expense: '800', note: '买衣服' },
      ],
    }
  },
}
</script>
