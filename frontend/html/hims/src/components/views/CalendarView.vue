<template>
  <div class="gantt-app bg-gray-50 text-gray-800 h-full flex flex-col overflow-hidden">

    <!-- 顶部导航 -->
    <header class="bg-white border-b p-4 flex justify-between items-center shadow-sm z-10 shrink-0">
      <h1 class="text-xl font-bold text-blue-600">任务与进度管理</h1>
      <el-button type="primary" @click="openModal">
        + 新增任务
      </el-button>
    </header>

    <!-- 主体区域：左右布局 -->
    <main class="flex-1 flex overflow-hidden">

      <!-- 左侧列表区 -->
      <aside class="w-1/5 bg-white border-r shrink-0 flex flex-col overflow-hidden">
        <!-- 顶部图例 -->
        <div class="p-3 border-b bg-gray-50 shrink-0">
          <div class="text-xs font-bold text-gray-600 mb-2">任务级别</div>
          <div class="space-y-1.5 text-xs">
            <div class="flex items-center gap-2">
              <span class="w-3 h-3 rounded-sm" style="background-color: #60a5fa;"></span>
              <span class="text-gray-700">低</span>
            </div>
            <div class="flex items-center gap-2">
              <span class="w-3 h-3 rounded-sm" style="background-color: #facc15;"></span>
              <span class="text-gray-700">中</span>
            </div>
            <div class="flex items-center gap-2">
              <span class="w-3 h-3 rounded-sm" style="background-color: #ef4444;"></span>
              <span class="text-gray-700">高</span>
            </div>
          </div>
        </div>

        <!-- 列表滚动区 -->
        <div class="flex-1 overflow-y-auto">
          <div class="text-sm">
            <template v-for="(cfg, key) in categoryConfig" :key="key">
              <div class="border-b border-gray-100">
                <div class="px-3 py-2 flex justify-between items-center sticky top-0 bg-white z-10">
                  <span class="font-bold text-xs" :class="cfg.color">{{ cfg.icon }} {{ cfg.title }}</span>
                  <span class="bg-gray-100 text-gray-500 rounded-full px-2 text-xs">{{ groupedTasks[key].length }}</span>
                </div>
                <div :style="groupedTasks[key].length > 5 ? 'max-height: 200px; overflow-y: auto;' : ''">
                  <template v-if="groupedTasks[key].length > 0">
                    <div
                      v-for="task in groupedTasks[key]"
                      :key="task.id"
                      class="task-row flex items-center px-3 py-2 border-b border-gray-50"
                      :class="{ draggable: !task.end, active: selectedTaskId === task.id }"
                      :draggable="!task.end"
                      @dragstart="!task.end && handleDragStart($event, task.id)"
                      @click="selectTask(task.id)"
                      :data-task-id="task.id"
                      :title="(task.start ? `开始: ${task.start}` : '') + (task.end ? ` 结束: ${task.end}` : ' 拖拽到右侧甘特图分配结束日期')"
                    >
                      <div class="flex-1 min-w-0 flex items-center">
                        <span class="w-2 h-2 rounded-full mr-2 shrink-0" :style="{ backgroundColor: getTaskDotColor(task) }"></span>
                        <span
                          class="truncate"
                          :class="(task.status === 'completed' || task.status === 'abandoned') ? 'line-through text-gray-400' : 'text-gray-800'"
                        >{{ getTaskPrefix(task) }}{{ task.title }}</span>
                      </div>
                    </div>
                  </template>
                  <div v-else class="px-3 py-2 text-xs text-gray-300">暂无任务</div>
                </div>
              </div>
            </template>
          </div>
        </div>
      </aside>

      <!-- 右侧甘特图区 -->
      <section class="flex-1 flex flex-col overflow-hidden bg-gray-50">
        <!-- 头部月份切换 -->
        <div class="bg-white border-b px-4 py-2 flex justify-between items-center shrink-0">
          <div class="flex items-center gap-4 mx-auto">
            <button @click="changeMonth(-1)" class="text-gray-500 hover:text-blue-600 px-2 py-1 rounded hover:bg-gray-100">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
              </svg>
            </button>
            <span class="font-medium text-gray-700 w-24 text-center">{{ currentMonthLabel }}</span>
            <button @click="changeMonth(1)" class="text-gray-500 hover:text-blue-600 px-2 py-1 rounded hover:bg-gray-100">
              <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
              </svg>
            </button>
            <button @click="goToday" class="ml-4 text-xs border border-gray-300 text-gray-600 px-2 py-1 rounded hover:bg-gray-50">回到今天</button>
          </div>
        </div>

        <!-- 甘特图容器 -->
        <div class="flex-1 overflow-y-auto overflow-x-hidden" id="gantt-scroll-container">
          <div class="p-4" :style="{ height: containerHeight + 'px' }">
            <!-- 表头 -->
            <div class="flex w-full" :style="{ height: headerHeight + 'px' }">
              <div class="bg-gray-100 border-b border-r flex items-center justify-center"
                   :style="{ width: leftColumnWidth + 'px', height: headerHeight + 'px' }">
                <span class="text-sm font-bold text-gray-600">{{ yearMonthLabel }}</span>
              </div>
              <div class="flex-1 grid" :style="{ gridTemplateColumns: `repeat(${daysInMonth}, 1fr)` }">
                <div
                  v-for="(cell, idx) in headerCells"
                  :key="'h-' + idx"
                  class="day-cell border-r border-b flex flex-col items-center justify-center text-xs shrink-0"
                  :class="[
                    cell.isWeekend ? 'bg-gray-50 text-gray-400' : 'text-gray-600',
                    cell.isToday ? 'bg-blue-50 font-bold text-blue-600' : '',
                    dragOverDate === cell.dateStr ? 'drag-over' : ''
                  ]"
                  :style="{ minWidth: 0 }"
                  @dragover.prevent="handleDragOver($event, cell.dateStr)"
                  @dragleave="handleDragLeave($event, cell.dateStr)"
                  @drop="handleDrop($event, cell.dateStr)"
                >
                  <span>{{ cell.day }}日</span>
                  <span class="text-[10px]" :class="cell.isToday ? 'text-blue-500' : 'text-gray-400'">{{ cell.weekLabel }}</span>
                </div>
              </div>
            </div>

            <!-- 任务行 -->
            <div class="w-full">
              <div
                v-for="task in displayTasks"
                :key="'row-' + task.id"
                class="flex w-full border-b border-gray-100"
                :style="{ height: rowHeight + 'px' }"
              >
                <div class="border-r flex items-center px-2 text-xs overflow-hidden bg-white shrink-0"
                     :style="{ width: leftColumnWidth + 'px', height: rowHeight + 'px' }">
                  <span
                    class="truncate"
                    :class="(task.status === 'completed' || task.status === 'abandoned') ? 'text-gray-400 line-through' : 'text-gray-800'"
                  >{{ getTaskPrefix(task) }}{{ task.title }}</span>
                </div>
                <div class="flex-1 grid shrink-0" :style="{ gridTemplateColumns: `repeat(${daysInMonth}, 1fr)` }">
                  <div
                    :id="'gantt-bar-' + task.id"
                    class="gantt-bar relative rounded text-xs flex items-center px-2 text-white my-1 shrink-0"
                    :class="{ selected: selectedTaskId === task.id }"
                    :style="{
                      gridColumn: `${task._offset} / span ${task._duration}`,
                      backgroundColor: getTaskBarColor(task)
                    }"
                    @click="selectTask(task.id)"
                    :title="`${getTaskPrefix(task)}${task.title} (${task.start} ~ ${task.end})`"
                  >
                    {{ getTaskPrefix(task) }}{{ task.title }}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>

    <!-- 新增任务模态框 (Element Plus Dialog) -->
    <el-dialog
      v-model="dialogVisible"
      title="新增任务"
      width="420px"
      :close-on-click-modal="false"
      @closed="resetForm"
    >
      <el-form
        ref="taskFormRef"
        :model="taskForm"
        :rules="taskFormRules"
        label-width="90px"
        @submit.prevent="submitForm"
      >
        <el-form-item label="任务标题" prop="title">
          <el-input v-model="taskForm.title" placeholder="请输入任务名称" />
        </el-form-item>
        <el-form-item label="开始时间" prop="start">
          <el-date-picker
            v-model="taskForm.start"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="选择开始日期"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="结束时间" prop="end">
          <el-date-picker
            v-model="taskForm.end"
            type="date"
            value-format="YYYY-MM-DD"
            placeholder="选填，留空可后续拖拽分配"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="任务级别" prop="level">
          <el-select v-model="taskForm.level" style="width: 100%">
            <el-option label="低" value="low" />
            <el-option label="中" value="medium" />
            <el-option label="高" value="high" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="closeModal">取消</el-button>
        <el-button type="primary" @click="submitForm">确认新增</el-button>
      </template>
    </el-dialog>

  </div>
</template>

<script>
export default {
  name: 'CalendarView',
  data() {
    const today = new Date()
    const formatData = (d) => {
      const y = d.getFullYear()
      const m = String(d.getMonth() + 1).padStart(2, '0')
      const day = String(d.getDate()).padStart(2, '0')
      return `${y}-${m}-${day}`
    }

    return {
      today,
      formatData,
      // 视图控制
      viewDate: new Date(today.getFullYear(), today.getMonth(), 1),
      selectedTaskId: null,
      draggedTaskId: null,
      dragOverDate: null,

      // 布局常量
      rowHeight: 40,
      headerHeight: 40,
      leftColumnWidth: 150,

      // 对话框
      dialogVisible: false,
      taskFormRef: null,
      taskForm: {
        title: '',
        start: '',
        end: '',
        level: 'medium'
      },
      taskFormRules: {
        title: [{ required: true, message: '请输入任务名称', trigger: 'blur' }],
        start: [{ required: true, message: '请选择开始日期', trigger: 'change' }]
      },

      // 级别颜色
      levelStyles: {
        low: { color: '#60a5fa' },
        medium: { color: '#facc15' },
        high: { color: '#ef4444' }
      },

      // 分类配置
      categoryConfig: {
        unassigned: { title: '未分配任务', icon: '📥', color: 'text-gray-600' },
        in_progress: { title: '正在进行中', icon: '🔄', color: 'text-blue-600' },
        due_soon: { title: '两天到期任务', icon: '⚠️', color: 'text-orange-600' },
        overdue: { title: '逾期任务', icon: '🔥', color: 'text-red-600' },
        completed: { title: '完成任务', icon: '✅', color: 'text-green-600' },
        abandoned: { title: '放弃任务', icon: '🗑️', color: 'text-gray-400' }
      },

      // 任务数据（初始 Mock）
      tasks: [
        { id: 1, title: '需求评审与原型设计', start: formatData(new Date(today.getFullYear(), today.getMonth(), 1)), end: formatData(new Date(today.getFullYear(), today.getMonth(), 3)), level: 'high', status: 'in_progress' },
        { id: 2, title: '数据库表结构设计', start: formatData(new Date(today.getFullYear(), today.getMonth(), 5)), end: formatData(new Date(today.getFullYear(), today.getMonth(), 6)), level: 'medium', status: 'in_progress' },
        { id: 3, title: '前端页面搭建', start: formatData(new Date(today.getFullYear(), today.getMonth() - 1, 25)), end: formatData(new Date(today.getFullYear(), today.getMonth(), 8)), level: 'high', status: 'in_progress' },
        { id: 4, title: 'API接口联调', start: formatData(new Date(today.getFullYear(), today.getMonth(), 10)), end: formatData(new Date(today.getFullYear(), today.getMonth(), 12)), level: 'low', status: 'completed' },
        { id: 5, title: '旧版本Bug修复', start: formatData(new Date(today.getFullYear(), today.getMonth(), 15)), end: formatData(new Date(today.getFullYear(), today.getMonth(), 16)), level: 'medium', status: 'abandoned' },
        { id: 6, title: '下期需求规划', start: formatData(new Date(today.getFullYear(), today.getMonth(), 20)), end: formatData(new Date(today.getFullYear(), today.getMonth(), 25)), level: 'low', status: 'in_progress' },
        { id: 7, title: '待规划: 竞品分析', start: formatData(new Date(today.getFullYear(), today.getMonth(), 12)), end: null, level: 'medium', status: 'in_progress' },
        { id: 8, title: '待规划: 周报整理', start: formatData(new Date(today.getFullYear(), today.getMonth(), 15)), end: null, level: 'low', status: 'in_progress' }
      ]
    }
  },
  computed: {
    currentMonthLabel() {
      return `${this.viewDate.getFullYear()}年 ${this.viewDate.getMonth() + 1}月`
    },
    yearMonthLabel() {
      const y = this.viewDate.getFullYear()
      const m = String(this.viewDate.getMonth() + 1).padStart(2, '0')
      return `${y}-${m}`
    },
    daysInMonth() {
      const y = this.viewDate.getFullYear()
      const m = this.viewDate.getMonth()
      return new Date(y, m + 1, 0).getDate()
    },
    firstDayOfMonth() {
      return new Date(this.viewDate.getFullYear(), this.viewDate.getMonth(), 1)
    },
    lastDayOfMonth() {
      const d = new Date(this.viewDate.getFullYear(), this.viewDate.getMonth(), this.daysInMonth)
      d.setHours(23, 59, 59, 999)
      return d
    },
    headerCells() {
      const y = this.viewDate.getFullYear()
      const m = this.viewDate.getMonth()
      const weekDayLabels = ['日', '一', '二', '三', '四', '五', '六']
      const cells = []
      for (let i = 1; i <= this.daysInMonth; i++) {
        const date = new Date(y, m, i)
        const dow = date.getDay()
        cells.push({
          day: i,
          weekLabel: `周${weekDayLabels[dow]}`,
          isWeekend: dow === 0 || dow === 6,
          isToday: date.toDateString() === this.today.toDateString(),
          dateStr: this.formatData(date)
        })
      }
      return cells
    },
    groupedTasks() {
      const grouped = {
        unassigned: [],
        in_progress: [],
        due_soon: [],
        overdue: [],
        completed: [],
        abandoned: []
      }
      this.tasks.forEach(task => {
        const cat = this.getTaskCategory(task)
        grouped[cat].push(task)
      })
      return grouped
    },
    displayTasks() {
      const result = []
      const first = this.firstDayOfMonth.getTime()
      const last = this.lastDayOfMonth.getTime()

      this.tasks.forEach(task => {
        if (!task.start || !task.end) return

        const taskStart = new Date(task.start + 'T00:00:00')
        const taskEnd = new Date(task.end + 'T00:00:00')
        taskEnd.setHours(23, 59, 59, 999)

        const tsStart = taskStart.getTime()
        const tsEnd = taskEnd.getTime()

        if (tsEnd < first || tsStart > last) return

        const validStartTs = tsStart < first ? first : tsStart
        const validEndTs = tsEnd > last ? last : tsEnd

        const offsetDays = Math.floor((validStartTs - first) / 86400000) + 1
        const durationDays = Math.ceil((validEndTs - validStartTs) / 86400000) + 1

        result.push({
          ...task,
          _offset: offsetDays,
          _duration: durationDays
        })
      })
      return result
    },
    containerHeight() {
      return this.headerHeight + (this.displayTasks.length * this.rowHeight) + 20
    }
  },
  methods: {
    // --- 分类判断 ---
    getTaskCategory(task) {
      if (task.status === 'completed') return 'completed'
      if (task.status === 'abandoned') return 'abandoned'
      if (!task.end) return 'unassigned'

      const now = new Date()
      now.setHours(0, 0, 0, 0)
      const end = new Date(task.end + 'T00:00:00')
      end.setHours(23, 59, 59, 999)

      const diffDaysEnd = (end - now) / 86400000
      if (diffDaysEnd < 0) return 'overdue'
      if (diffDaysEnd <= 2) return 'due_soon'
      return 'in_progress'
    },

    // --- 显示辅助 ---
    getTaskPrefix(task) {
      if (task.status === 'completed') return '[已完成] '
      if (task.status === 'abandoned') return '[已放弃] '
      return ''
    },
    getTaskDotColor(task) {
      if (task.status === 'completed') return '#22c55e'
      if (task.status === 'abandoned') return '#9ca3af'
      return this.levelStyles[task.level].color
    },
    getTaskBarColor(task) {
      if (task.status === 'completed') return '#22c55e'
      if (task.status === 'abandoned') return '#9ca3af'
      return this.levelStyles[task.level].color
    },

    // --- 选中联动 ---
    selectTask(taskId) {
      this.selectedTaskId = taskId
    },

    // --- 月份切换 ---
    changeMonth(offset) {
      this.viewDate = new Date(this.viewDate.getFullYear(), this.viewDate.getMonth() + offset, 1)
    },
    goToday() {
      this.viewDate = new Date(this.today.getFullYear(), this.today.getMonth(), 1)
    },

    // --- 拖拽逻辑 ---
    handleDragStart(event, taskId) {
      this.draggedTaskId = taskId
      event.dataTransfer.effectAllowed = 'move'
      event.dataTransfer.setData('text/plain', taskId)
    },
    handleDragOver(event, dateStr) {
      event.dataTransfer.dropEffect = 'move'
      this.dragOverDate = dateStr
    },
    handleDragLeave(event, dateStr) {
      if (this.dragOverDate === dateStr) {
        this.dragOverDate = null
      }
    },
    handleDrop(event, dateStr) {
      event.preventDefault()
      this.dragOverDate = null
      if (this.draggedTaskId) {
        const task = this.tasks.find(t => t.id === this.draggedTaskId)
        if (task) {
          if (new Date(dateStr) < new Date(task.start)) {
            this.$message.warning('结束日期不能早于开始日期！')
            this.draggedTaskId = null
            return
          }
          task.end = dateStr
          task.status = 'in_progress'
          setTimeout(() => this.selectTask(task.id), 50)
        }
        this.draggedTaskId = null
      }
    },

    // --- 模态框 & 表单 ---
    openModal() {
      this.taskForm = { title: '', start: '', end: '', level: 'medium' }
      this.dialogVisible = true
    },
    closeModal() {
      this.dialogVisible = false
    },
    resetForm() {
      this.taskForm = { title: '', start: '', end: '', level: 'medium' }
      if (this.taskFormRef) this.taskFormRef.clearValidate()
    },
    submitForm() {
      if (!this.taskFormRef) return
      this.taskFormRef.validate((valid) => {
        if (!valid) return
        if (this.taskForm.end && new Date(this.taskForm.start) > new Date(this.taskForm.end)) {
          this.$message.warning('开始时间不能晚于结束时间！')
          return
        }
        const newTask = {
          id: Date.now(),
          title: this.taskForm.title,
          start: this.taskForm.start,
          end: this.taskForm.end || null,
          level: this.taskForm.level,
          status: 'in_progress'
        }
        this.tasks.push(newTask)
        this.$message.success('新增任务成功！')
        this.closeModal()
      })
    }
  }
}
</script>

<style scoped>
/* 自定义滚动条样式 */
:deep(::-webkit-scrollbar) { width: 6px; height: 6px; }
:deep(::-webkit-scrollbar-thumb) { background: #cbd5e1; border-radius: 3px; }
:deep(::-webkit-scrollbar-track) { background: #f1f5f9; }

.task-row { transition: background 0.2s; cursor: pointer; }
.task-row:hover { background: #f8fafc; }
.task-row.active { background: #eff6ff; border-left: 3px solid #3b82f6; }
.task-row.draggable { cursor: grab; }
.task-row.draggable:active { cursor: grabbing; }

.gantt-bar { transition: all 0.2s; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; min-width: 0; }
.gantt-bar:hover { opacity: 0.85; z-index: 10; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); }
.gantt-bar.selected { box-shadow: 0 0 0 2px #1d4ed8, 0 4px 6px -1px rgba(0, 0, 0, 0.2); z-index: 20; }

.day-cell { transition: background 0.2s; }
.day-cell.drag-over { background: #dbeafe !important; box-shadow: inset 0 0 0 2px #3b82f6; }

@keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
.fade-in { animation: fadeIn 0.3s ease-out; }
</style>
