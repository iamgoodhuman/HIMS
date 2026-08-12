<template>
  <div>
    <h2 class="text-2xl font-bold mb-6">{{ subPage === 'food' ? '食物管理' : '食谱推荐' }}</h2>

    <!-- 食物管理 -->
    <el-card v-if="subPage === 'food'" shadow="never">
      <div class="flex justify-between items-center mb-4">
        <span class="text-lg font-bold">当前库存</span>
        <el-button type="primary" @click="showAddForm = !showAddForm">+ 添加食材</el-button>
      </div>

      <el-collapse-transition>
        <div v-show="showAddForm" class="mb-6">
          <el-card shadow="inner">
            <el-form :inline="true">
              <el-form-item label="食材名称">
                <el-input v-model="newFood.name" placeholder="如: 西红柿" />
              </el-form-item>
              <el-form-item label="数量">
                <el-input-number v-model="newFood.qty" :min="1" />
              </el-form-item>
              <el-form-item label="分类">
                <el-select v-model="newFood.cat" style="width: 120px">
                  <el-option label="蔬菜" value="蔬菜" />
                  <el-option label="肉类" value="肉类" />
                  <el-option label="主食" value="主食" />
                  <el-option label="调料" value="调料" />
                </el-select>
              </el-form-item>
              <el-form-item>
                <el-button type="success" @click="addFood">确认添加</el-button>
              </el-form-item>
            </el-form>
          </el-card>
        </div>
      </el-collapse-transition>

      <el-empty v-if="foods.length === 0" description="库存空空如也，快去添加食材吧！" />

      <el-row v-else :gutter="20">
        <el-col :span="6" v-for="food in foods" :key="food.id" class="mb-4">
          <el-card shadow="hover">
            <div class="flex justify-between items-center">
              <div>
                <p class="font-bold text-lg">{{ food.name }}</p>
                <p class="text-sm text-gray-500">数量: {{ food.qty }} | 分类: {{ food.cat }}</p>
              </div>
              <el-button type="danger" :icon="Delete" circle size="small" @click="deleteFood(food.id)" />
            </div>
          </el-card>
        </el-col>
      </el-row>
    </el-card>

    <!-- 食谱推荐 -->
    <el-card v-else shadow="never">
      <div class="flex justify-between items-center mb-4">
        <span class="text-lg font-bold">今日吃什么？</span>
        <div class="flex items-center gap-3">
          <span class="text-sm text-gray-500">基于现有库存智能匹配</span>
          <el-button type="warning" @click="generateRandomRecipe">🎲 随机生成</el-button>
        </div>
      </div>

      <el-alert v-if="randomRecipeError" type="error" :title="randomRecipeError" :closable="false" class="mb-4" />

      <el-card v-if="randomRecipe" shadow="hover" class="mb-6 !border-2 !border-purple-200">
        <p class="text-lg font-bold text-purple-600 mb-2">🎯 厨房为你推荐: {{ randomRecipe.name }}</p>
        <p class="text-sm mb-2"><strong>所需食材:</strong> {{ randomRecipe.req.join('、') }}</p>
        <p class="text-sm text-gray-700 bg-purple-50 p-3 rounded">{{ randomRecipe.steps }}</p>
      </el-card>

      <p class="font-bold mb-3 border-b pb-2">可制作的菜谱列表</p>
      <el-row :gutter="20">
        <el-col :span="12" v-for="recipe in recipes" :key="recipe.name" class="mb-4">
          <el-card shadow="hover">
            <div class="flex justify-between items-center mb-2">
              <span class="font-bold text-lg">{{ recipe.name }}</span>
              <el-tag :type="canMake(recipe) ? 'success' : 'info'" size="small">
                {{ canMake(recipe) ? '可制作' : '缺食材' }}
              </el-tag>
            </div>
            <div class="mb-2">
              <strong>所需食材:</strong>
              <div class="mt-1">
                <el-tag
                  v-for="req in recipe.req"
                  :key="req"
                  :type="hasFood(req) ? 'success' : 'danger'"
                  size="small"
                  class="mr-1"
                  :class="{ 'line-through': !hasFood(req) }"
                >{{ req }}</el-tag>
              </div>
            </div>
            <p v-if="canMake(recipe)" class="text-sm text-gray-600 bg-gray-50 p-2 rounded">{{ recipe.steps }}</p>
          </el-card>
        </el-col>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import { Delete } from '@element-plus/icons-vue'

export default {
  name: 'KitchenView',
  props: {
    subPage: { type: String, default: 'food' },
  },
  data() {
    return {
      Delete,
      showAddForm: false,
      newFood: { name: '', qty: 1, cat: '蔬菜' },
      randomRecipe: null,
      randomRecipeError: '',
      foods: [
        { id: 1, name: '西红柿', qty: 3, cat: '蔬菜' },
        { id: 2, name: '鸡蛋', qty: 5, cat: '肉类' },
        { id: 3, name: '面粉', qty: 1, cat: '主食' },
        { id: 4, name: '牛肉', qty: 2, cat: '肉类' },
        { id: 5, name: '葱', qty: 1, cat: '蔬菜' },
        { id: 6, name: '盐', qty: 1, cat: '调料' },
      ],
      recipes: [
        { name: '西红柿炒鸡蛋', req: ['西红柿', '鸡蛋', '盐'], steps: '1. 鸡蛋打散炒熟盛出; 2. 炒西红柿出汁; 3. 加入鸡蛋翻炒, 放盐出锅。' },
        { name: '葱爆牛肉', req: ['牛肉', '葱', '盐'], steps: '1. 牛肉切片腌制; 2. 大火爆炒牛肉至变色; 3. 加入葱段翻炒出锅。' },
        { name: '鸡蛋面', req: ['面粉', '鸡蛋', '盐'], steps: '1. 面粉加水和面, 擀面条; 2. 煮熟面条; 3. 煎荷包蛋盖上, 撒盐。' },
        { name: '西红柿牛肉汤', req: ['西红柿', '牛肉', '盐', '葱'], steps: '1. 牛肉切块焯水; 2. 西红柿切块炒出泥; 3. 加水炖煮牛肉1小时, 撒葱花出锅。' },
        { name: '烤红薯', req: ['红薯'], steps: '1. 红薯洗净; 2. 烤箱200度烤1小时。' },
      ],
    }
  },
  methods: {
    addFood() {
      if (!this.newFood.name) {
        this.$message.warning('请输入食材名称！')
        return
      }
      this.foods.push({ id: Date.now(), ...this.newFood })
      this.newFood = { name: '', qty: 1, cat: '蔬菜' }
      this.showAddForm = false
      this.$message.success('添加成功！')
    },
    deleteFood(id) {
      this.foods = this.foods.filter(f => f.id !== id)
    },
    hasFood(name) {
      return this.foods.some(f => f.name === name)
    },
    canMake(recipe) {
      return recipe.req.every(r => this.hasFood(r))
    },
    generateRandomRecipe() {
      this.randomRecipe = null
      this.randomRecipeError = ''
      const possible = this.recipes.filter(r => this.canMake(r))
      if (possible.length === 0) {
        this.randomRecipeError = '当前库存不足以制作任何完整菜谱，请先补充食材！'
        return
      }
      this.randomRecipe = possible[Math.floor(Math.random() * possible.length)]
    },
  },
}
</script>
