<template>
  <div class="assets-container">
    <el-row :gutter="20" class="mb-5">
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="flex justify-between items-center">
            <div>
              <p class="text-gray-500 text-sm mb-2">家庭资产总值</p>
              <p class="text-2xl font-bold">¥850,000</p>
              <p class="text-xs text-gray-400 mt-1">较去年 +5.2%</p>
            </div>
            <el-icon :size="40" color="#409EFF"><Money /></el-icon>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="flex justify-between items-center">
            <div>
              <p class="text-gray-500 text-sm mb-2">购入总成本</p>
              <p class="text-2xl font-bold">¥1,020,000</p>
              <p class="text-xs text-gray-400 mt-1">共计 24 项资产</p>
            </div>
            <el-icon :size="40" color="#67C23A"><ShoppingCart /></el-icon>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="flex justify-between items-center">
            <div>
              <p class="text-gray-500 text-sm mb-2">累计折旧</p>
              <p class="text-2xl font-bold">¥170,000</p>
              <p class="text-xs text-gray-400 mt-1">折旧率 16.6%</p>
            </div>
            <el-icon :size="40" color="#E6A23C"><TrendCharts /></el-icon>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover">
          <div class="flex justify-between items-center">
            <div>
              <p class="text-gray-500 text-sm mb-2">维保预警</p>
              <p class="text-2xl font-bold">3 件</p>
              <p class="text-xs text-gray-400 mt-1">即将过保或需保养</p>
            </div>
            <el-icon :size="40" color="#F56C6C"><Tools /></el-icon>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <el-card shadow="never" class="mb-5">
      <div class="flex justify-between items-center mb-4">
        <span class="text-lg font-bold">家庭固定资产</span>
        <div class="flex gap-3 items-center">
          <el-radio-group v-model="viewMode">
            <el-radio-button label="grid">网格视图</el-radio-button>
            <el-radio-button label="list">列表视图</el-radio-button>
          </el-radio-group>
          <el-button type="primary">+ 录入财产</el-button>
          <el-button>导出报表</el-button>
        </div>
      </div>

      <el-form :inline="true" class="border-t pt-4">
        <el-form-item>
          <el-input v-model="filters.keyword" placeholder="搜索资产名称" clearable prefix-icon="Search" />
        </el-form-item>
        <el-form-item>
          <el-select v-model="filters.category" placeholder="分类" clearable>
            <el-option label="房产" value="房产" />
            <el-option label="车辆" value="车辆" />
            <el-option label="家电" value="家电" />
            <el-option label="贵重物品" value="贵重物品" />
            <el-option label="电子产品" value="电子产品" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-select v-model="filters.location" placeholder="位置" clearable>
            <el-option label="客厅" value="客厅" />
            <el-option label="主卧" value="主卧" />
            <el-option label="书房" value="书房" />
            <el-option label="车库" value="车库" />
            <el-option label="北京" value="北京" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-select v-model="filters.status" placeholder="状态" clearable>
            <el-option label="正常" value="正常" />
            <el-option label="保修中" value="保修中" />
            <el-option label="需保养" value="需保养" />
            <el-option label="维修中" value="维修中" />
          </el-select>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 网格视图 -->
    <div v-if="viewMode === 'grid'">
      <el-row :gutter="20">
        <el-col :span="6" v-for="asset in filteredAssets" :key="asset.id" class="mb-5">
          <el-card shadow="hover" :body-style="{ padding: '0' }">
            <div class="h-40 bg-gray-50 flex items-center justify-center text-6xl relative">
              {{ asset.icon }}
              <el-tag
                :type="statusTag(asset.status)"
                class="absolute top-3 right-3"
              >{{ asset.status }}</el-tag>
            </div>
            <div class="p-4">
              <div class="flex justify-between items-center mb-3">
                <span class="font-bold">{{ asset.name }}</span>
                <el-tag size="small" type="info">{{ asset.category }}</el-tag>
              </div>
              <el-descriptions :column="1" size="small">
                <el-descriptions-item label="位置">{{ asset.location }}</el-descriptions-item>
                <el-descriptions-item label="购买">{{ asset.buyDate }}</el-descriptions-item>
                <el-descriptions-item label="折旧率">
                  <span :style="{ color: asset.depreciation < 0 ? '#67C23A' : '#606266' }">
                    {{ asset.depreciation < 0 ? '升值' + Math.abs(asset.depreciation) + '%' : asset.depreciation + '%' }}
                  </span>
                </el-descriptions-item>
              </el-descriptions>
              <el-progress
                :percentage="Math.abs(asset.depreciation)"
                :color="asset.depreciation < 0 ? '#67C23A' : '#E6A23C'"
                :stroke-width="6"
                :show-text="false"
                class="mt-2"
              />
              <div class="flex justify-between items-center mt-3 pt-3 border-t border-dashed border-gray-200">
                <div>
                  <p class="text-xs text-gray-400">当前估值</p>
                  <p class="text-red-500 font-bold">¥{{ asset.currentValue }}</p>
                </div>
                <div>
                  <el-button text type="primary" size="small">详情</el-button>
                  <el-button text type="success" size="small">编辑</el-button>
                </div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>

    <!-- 列表视图 -->
    <el-card v-else shadow="never">
      <el-table :data="filteredAssets" stripe>
        <el-table-column type="selection" width="50" />
        <el-table-column label="资产名称">
          <template #default="{ row }">{{ row.icon }} {{ row.name }}</template>
        </el-table-column>
        <el-table-column prop="category" label="分类" width="100">
          <template #default="{ row }">
            <el-tag size="small">{{ row.category }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="location" label="位置" width="80" />
        <el-table-column prop="buyDate" label="购买日期" width="120" />
        <el-table-column prop="buyPrice" label="购入价格" width="120" />
        <el-table-column label="当前估值" width="120">
          <template #default="{ row }">
            <span class="text-red-500 font-bold">¥{{ row.currentValue }}</span>
          </template>
        </el-table-column>
        <el-table-column label="折旧率" width="150">
          <template #default="{ row }">
            <el-progress
              :percentage="Math.abs(row.depreciation)"
              :color="row.depreciation < 0 ? '#67C23A' : '#409EFF'"
              :stroke-width="8"
            >
              <span :style="{ color: row.depreciation < 0 ? '#67C23A' : '#606266' }">
                {{ row.depreciation < 0 ? '升值' + Math.abs(row.depreciation) + '%' : row.depreciation + '%' }}
              </span>
            </el-progress>
          </template>
        </el-table-column>
        <el-table-column label="状态" width="100">
          <template #default="{ row }">
            <el-tag :type="statusTag(row.status)" size="small">{{ row.status }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="120">
          <template #default>
            <el-button text type="primary" size="small">详情</el-button>
            <el-button text type="success" size="small">编辑</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
  </div>
</template>

<script>
import { Money, ShoppingCart, TrendCharts, Tools } from '@element-plus/icons-vue'

export default {
  name: 'AssetsView',
  components: { Money, ShoppingCart, TrendCharts, Tools },
  data() {
    return {
      viewMode: 'grid',
      filters: { keyword: '', category: '', location: '', status: '' },
      assets: [
        { id: 1, icon: '🏠', name: '朝阳区三居室', category: '房产', location: '北京', buyDate: '2018-06-01', buyPrice: '4,500,000', currentValue: '5,200,000', depreciation: -15, status: '正常' },
        { id: 2, icon: '🚗', name: '沃尔沃 S90', category: '车辆', location: '车库', buyDate: '2021-05-10', buyPrice: '420,000', currentValue: '350,000', depreciation: 18, status: '正常' },
        { id: 3, icon: '💻', name: 'Macbook Pro 14', category: '电子产品', location: '书房', buyDate: '2022-08-15', buyPrice: '18,000', currentValue: '12,000', depreciation: 45, status: '需保养' },
        { id: 4, icon: '📺', name: '索尼 A90J 电视', category: '家电', location: '客厅', buyDate: '2023-01-01', buyPrice: '20,000', currentValue: '18,000', depreciation: 10, status: '保修中' },
        { id: 5, icon: '⌚', name: 'Apple Watch S8', category: '贵重物品', location: '主卧', buyDate: '2022-10-12', buyPrice: '3,100', currentValue: '2,500', depreciation: 20, status: '正常' },
      ],
    }
  },
  computed: {
    filteredAssets() {
      return this.assets.filter(a => {
        if (this.filters.keyword && !a.name.includes(this.filters.keyword)) return false
        if (this.filters.category && a.category !== this.filters.category) return false
        if (this.filters.location && a.location !== this.filters.location) return false
        if (this.filters.status && a.status !== this.filters.status) return false
        return true
      })
    },
  },
  methods: {
    statusTag(status) {
      const map = { '正常': 'success', '保修中': '', '需保养': 'warning', '维修中': 'danger' }
      return map[status] || 'info'
    },
  },
}
</script>
