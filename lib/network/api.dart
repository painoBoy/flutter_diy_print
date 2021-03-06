const login = "auth/toLogin"; // 登录 /auth/toLogout
const logout = "auth/toLogout"; // 退出登录 
const bindPrint = "printer/bind"; //绑定打印机
const getPrintDoorisLock = "printer/doorState/"; // 获取打印机门锁状态
const removePrint  = "printerType/del/3"; //根据类型删除打印机 
const getPrintStatus = "printer/getPrinterStateByMac"; //根据打印机mac地址获取打印机状态
const getUserPrint = "printer/getPrinters"; //获取当前用户绑定的所有打印机'
const favorite = "userModel/favorIt"; //收藏作品
const unFavorite = "userModel/unFavorIt"; //取消收藏作品
const favoriteList = "userModel/favoriteList"; //获取收藏列表
const pullIn = "printer/pullIn"; //打印机入料
const pullOut = "printer/pullOut"; //打印机退料
const pullInProgress = "printer/pullInProgress"; //入料进度查询
const pullOutProgress = "printer/pullOutProgress"; //退料进度查询
const printerInfo = "printer/printerInfo"; //获取打印机详情 
const checkModel = "printTask/checkModelSizeProgress"; //获取模型大小查询结果 
const modelSize = "printTask/checkModelSize"; //获取模型大小 
const sendCommand = "printer/sendCommand"; //打印机发送命令  
const createPrintTask = "printTask"; //创建打印任务 
const printTaskApi = "printTask/startNow"; //立即开始打印任务  
const userTaskList = "printTask"; //查询用户所有打印任务  
const editUserInfo = "users/editFromUser"; //修改用户信息
const editPrinterName = "printer/updatePrinterName"; //修改打印机名称 
const unBundPrinter = "printer/unbundlingPrinter"; //解绑打印机
const feedback = "feedback/add"; //新增问题反馈
