<template>
  <div class="calendar-container">
    <!-- 左侧控制面板 -->
    <div class="left-panel">
      <button class="create-btn">+ 创建事件</button>

      <!-- 迷你日历 -->
      <div class="mini-cal-header">
        <span class="mini-cal-title">{{ currentDateText }}</span>
        <div class="mini-cal-nav">
          <span @click="prevMonth">‹</span>
          <span @click="nextMonth">›</span>
        </div>
      </div>
      <div class="mini-cal-grid">
        <div class="header">日</div>
        <div class="header">一</div>
        <div class="header">二</div>
        <div class="header">三</div>
        <div class="header">四</div>
        <div class="header">五</div>
        <div class="header">六</div>
        <div
          v-for="day in calendarDays"
          :key="'mini-' + day.key"
          class="day"
          :class="{ 'other-month': !day.currentMonth, 'today': day.isToday }"
          @click="goToDate(day)"
        >{{ day.date }}</div>
      </div>

      <!-- 日历分类 -->
      <div class="cal-categories">
        <div class="category-title">我的日历</div>
        <div
          v-for="cat in categories"
          :key="cat.id"
          class="category-item"
          :class="{ disabled: !cat.visible }"
          @click="toggleCategory(cat)"
        >
          <div class="color-dot" :style="{ background: cat.color }"></div>
          <span>{{ cat.name }}</span>
        </div>
      </div>
    </div>

    <!-- 右侧日历主区域 -->
    <div class="right-panel">
      <!-- 工具栏 -->
      <div class="cal-toolbar">
        <div class="toolbar-left">
          <button class="btn-today" @click="goToToday">今天</button>
          <div class="nav-arrows">
            <span @click="prevMonth">‹</span>
            <span @click="nextMonth">›</span>
          </div>
          <div class="current-date">{{ currentDateText }}</div>
        </div>
        <div class="toolbar-right">
          <div class="view-switch">
            <button :class="{ active: viewMode === 'day' }" @click="viewMode = 'day'">日</button>
            <button :class="{ active: viewMode === 'week' }" @click="viewMode = 'week'">周</button>
            <button :class="{ active: viewMode === 'month' }" @click="viewMode = 'month'">月</button>
          </div>
        </div>
      </div>

      <!-- 日历主体 -->
      <div class="calendar-body">
        <div class="week-header">
          <div v-for="(d, i) in weekDays" :key="i" :class="{ weekend: d.isWeekend }">{{ d.label }}</div>
        </div>

        <div class="month-grid">
          <div
            v-for="day in calendarDays"
            :key="'main-' + day.key"
            class="day-cell"
            :class="{ 'other-month': !day.currentMonth, 'today': day.isToday, 'weekend': day.isWeekend }"
          >
            <div class="date-num">{{ day.date }}</div>
            <div
              v-for="event in getEventsForDay(day)"
              :key="event.id"
              class="event-block"
              :class="event.colorClass"
            >{{ event.title }}</div>
            <div v-if="getMoreCount(day) > 0" class="more-link">
              查看更多 ({{ getMoreCount(day) }})
            </div>
          </div>
        </div>
      </div>

      <!-- 底部状态栏 -->
      <div class="cal-statusbar">
        <span>共有 {{ categories.length }} 个日历分类，当前显示全部</span>
        <span>当前时区: GMT+08:00 北京</span>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CalendarView',
  data() {
    return {
      currentYear: new Date().getFullYear(),
      currentMonth: new Date().getMonth(),
      viewMode: 'month',
      maxVisibleEvents: 3,
      weekDays: [
        { label: '星期日', isWeekend: false },
        { label: '星期一', isWeekend: false },
        { label: '星期二', isWeekend: false },
        { label: '星期三', isWeekend: false },
        { label: '星期四', isWeekend: false },
        { label: '星期五', isWeekend: true },
        { label: '星期六', isWeekend: true },
      ],
      categories: [
        { id: 1, name: '保险与还款', color: '#F56C6C', visible: true },
        { id: 2, name: '家庭事件', color: '#67C23A', visible: true },
        { id: 3, name: '个人私密', color: '#409EFF', visible: true },
        { id: 4, name: '财产维保', color: '#E6A23C', visible: true },
        { id: 5, name: '日常琐事', color: '#909399', visible: true },
      ],
      events: [
        { id: 1, day: 1, title: '周三倒垃圾', colorClass: 'e-gray' },
        { id: 2, day: 4, title: '全家植物园野餐', colorClass: 'e-green' },
        { id: 3, day: 8, title: '建行信用卡还款', colorClass: 'e-red' },
        { id: 4, day: 9, title: '奔驰交强险到期', colorClass: 'e-orange' },
        { id: 5, day: 9, title: 'Macbook保修截止', colorClass: 'e-orange' },
        { id: 6, day: 10, title: '📅 结婚纪念日', colorClass: 'e-green' },
        { id: 7, day: 13, title: '周三倒垃圾', colorClass: 'e-gray' },
        { id: 8, day: 15, title: '10:00 李四-私人体检', colorClass: 'e-blue' },
        { id: 9, day: 17, title: '车辆保养预约', colorClass: 'e-orange' },
        { id: 10, day: 23, title: '张三-重疾险到期', colorClass: 'e-red' },
        { id: 11, day: 23, title: '房贷扣款日', colorClass: 'e-red' },
        { id: 12, day: 23, title: '水电费自动扣款', colorClass: 'e-red' },
        { id: 13, day: 23, title: '隐藏事件1', colorClass: 'e-red' },
        { id: 14, day: 23, title: '隐藏事件2', colorClass: 'e-red' },
        { id: 15, day: 24, title: '19:00 倒垃圾', colorClass: 'e-gray' },
      ],
    }
  },
  computed: {
    currentDateText() {
      return `${this.currentYear}年 ${this.currentMonth + 1}月`
    },
    calendarDays() {
      const year = this.currentYear
      const month = this.currentMonth
      const firstDay = new Date(year, month, 1)
      const firstDayOfWeek = firstDay.getDay()
      const daysInMonth = new Date(year, month + 1, 0).getDate()
      const daysInPrevMonth = new Date(year, month, 0).getDate()

      const today = new Date()
      const isCurrentMonth = today.getFullYear() === year && today.getMonth() === month
      const todayDate = isCurrentMonth ? today.getDate() : -1

      const days = []

      for (let i = firstDayOfWeek - 1; i >= 0; i--) {
        const date = daysInPrevMonth - i
        const dow = new Date(year, month - 1, date).getDay()
        days.push({ date, currentMonth: false, isToday: false, isWeekend: dow === 5 || dow === 6, key: `prev-${date}` })
      }

      for (let i = 1; i <= daysInMonth; i++) {
        const dow = new Date(year, month, i).getDay()
        days.push({ date: i, currentMonth: true, isToday: i === todayDate, isWeekend: dow === 5 || dow === 6, key: `curr-${i}` })
      }

      const remaining = 42 - days.length
      for (let i = 1; i <= remaining; i++) {
        const dow = new Date(year, month + 1, i).getDay()
        days.push({ date: i, currentMonth: false, isToday: false, isWeekend: dow === 5 || dow === 6, key: `next-${i}` })
      }

      return days
    },
  },
  methods: {
    prevMonth() {
      if (this.currentMonth === 0) {
        this.currentMonth = 11
        this.currentYear--
      } else {
        this.currentMonth--
      }
    },
    nextMonth() {
      if (this.currentMonth === 11) {
        this.currentMonth = 0
        this.currentYear++
      } else {
        this.currentMonth++
      }
    },
    goToToday() {
      const now = new Date()
      this.currentYear = now.getFullYear()
      this.currentMonth = now.getMonth()
    },
    goToDate(day) {
      if (!day.currentMonth) {
        if (day.key.startsWith('prev')) {
          this.prevMonth()
        } else {
          this.nextMonth()
        }
      }
    },
    getEventsForDay(day) {
      if (!day.currentMonth) return []
      return this.events.filter(e => e.day === day.date).slice(0, this.maxVisibleEvents)
    },
    getMoreCount(day) {
      if (!day.currentMonth) return 0
      const count = this.events.filter(e => e.day === day.date).length
      return count > this.maxVisibleEvents ? count - this.maxVisibleEvents : 0
    },
    toggleCategory(cat) {
      cat.visible = !cat.visible
    },
  },
}
</script>

<style scoped>
.calendar-container {
  --primary-color: #409EFF;
  --success-color: #67C23A;
  --warning-color: #E6A23C;
  --danger-color: #F56C6C;
  --info-color: #909399;
  --border-color: #e4e7ed;
  --bg-color: #f5f7fa;
  --text-primary: #303133;
  --text-regular: #606266;
  --text-placeholder: #c0c4cc;

  display: flex;
  height: 100%;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

/* 左侧面板 */
.left-panel {
  width: 240px;
  border-right: 1px solid var(--border-color);
  padding: 20px;
  overflow-y: auto;
  flex-shrink: 0;
}

.create-btn {
  width: 100%;
  padding: 10px;
  background-color: var(--primary-color);
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
  margin-bottom: 20px;
  transition: background 0.3s;
}
.create-btn:hover { background-color: #66b1ff; }

/* 迷你日历 */
.mini-cal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}
.mini-cal-title { font-weight: bold; }
.mini-cal-nav span { cursor: pointer; color: var(--text-regular); margin: 0 5px; }
.mini-cal-nav span:hover { color: var(--primary-color); }

.mini-cal-grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  text-align: center;
  font-size: 12px;
}
.mini-cal-grid .header { color: var(--text-placeholder); padding: 5px 0; }
.mini-cal-grid .day {
  padding: 5px 0;
  cursor: pointer;
  border-radius: 50%;
  transition: background 0.2s;
}
.mini-cal-grid .day:hover { background-color: #ecf5ff; color: var(--primary-color); }
.mini-cal-grid .day.other-month { color: var(--text-placeholder); }
.mini-cal-grid .day.today {
  background-color: var(--primary-color);
  color: white;
  font-weight: bold;
}

/* 日历分类 */
.cal-categories { margin-top: 30px; }
.category-title {
  font-size: 12px;
  color: var(--text-regular);
  margin-bottom: 10px;
}
.category-item {
  display: flex;
  align-items: center;
  padding: 6px 0;
  cursor: pointer;
}
.category-item.disabled { opacity: 0.4; }
.color-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  margin-right: 10px;
  flex-shrink: 0;
}
.category-item span { font-size: 13px; }

/* 右侧主区域 */
.right-panel {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

/* 工具栏 */
.cal-toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 15px 20px;
  border-bottom: 1px solid var(--border-color);
  flex-shrink: 0;
}
.toolbar-left {
  display: flex;
  align-items: center;
  gap: 15px;
}
.btn-today {
  padding: 6px 12px;
  border: 1px solid var(--border-color);
  background: #fff;
  border-radius: 4px;
  cursor: pointer;
}
.btn-today:hover { color: var(--primary-color); border-color: var(--primary-color); }
.nav-arrows span {
  cursor: pointer;
  font-size: 18px;
  color: var(--text-regular);
  padding: 0 5px;
}
.nav-arrows span:hover { color: var(--primary-color); }
.current-date {
  font-size: 18px;
  font-weight: bold;
}
.toolbar-right { display: flex; gap: 10px; }
.view-switch {
  display: flex;
  border: 1px solid var(--border-color);
  border-radius: 4px;
  overflow: hidden;
}
.view-switch button {
  padding: 6px 12px;
  background: #fff;
  border: none;
  cursor: pointer;
  font-size: 13px;
}
.view-switch button.active {
  background: var(--primary-color);
  color: white;
}

/* 日历主体 */
.calendar-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.week-header {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  border-bottom: 1px solid var(--border-color);
  flex-shrink: 0;
}
.week-header div {
  padding: 10px;
  text-align: center;
  font-weight: bold;
  color: var(--text-regular);
  background: #fafafa;
}
.week-header .weekend { color: var(--danger-color); }

.month-grid {
  flex: 1;
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  grid-auto-rows: 1fr;
  border-right: 1px solid var(--border-color);
}

.day-cell {
  border-bottom: 1px solid var(--border-color);
  border-left: 1px solid var(--border-color);
  padding: 5px;
  overflow: hidden;
  position: relative;
  transition: background 0.2s;
}
.day-cell:hover { background-color: #fafafa; }
.day-cell.other-month { background-color: #fbfbfb; }

.date-num {
  font-size: 14px;
  font-weight: 500;
  margin-bottom: 4px;
  display: inline-block;
}
.day-cell.today .date-num {
  background: var(--primary-color);
  color: white;
  border-radius: 50%;
  width: 24px;
  height: 24px;
  text-align: center;
  line-height: 24px;
}
.day-cell.weekend .date-num { color: var(--danger-color); }

/* 事件块 */
.event-block {
  font-size: 12px;
  padding: 2px 4px;
  border-radius: 3px;
  margin-bottom: 3px;
  cursor: pointer;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  display: flex;
  align-items: center;
}
.event-block::before {
  content: '';
  display: inline-block;
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: white;
  margin-right: 5px;
  flex-shrink: 0;
}

.e-red { background: #fde2e2; color: var(--danger-color); border-left: 2px solid var(--danger-color); }
.e-green { background: #e1f3d8; color: var(--success-color); border-left: 2px solid var(--success-color); }
.e-blue { background: #d9ecff; color: var(--primary-color); border-left: 2px solid var(--primary-color); }
.e-orange { background: #faecd8; color: var(--warning-color); border-left: 2px solid var(--warning-color); }
.e-gray { background: #f4f4f5; color: var(--info-color); border-left: 2px solid var(--info-color); }

.more-link {
  font-size: 12px;
  color: var(--primary-color);
  cursor: pointer;
  text-align: center;
  margin-top: 2px;
}

/* 底部状态栏 */
.cal-statusbar {
  padding: 5px 20px;
  background: #fafafa;
  border-top: 1px solid var(--border-color);
  font-size: 12px;
  color: var(--text-regular);
  display: flex;
  justify-content: space-between;
  flex-shrink: 0;
}
</style>
