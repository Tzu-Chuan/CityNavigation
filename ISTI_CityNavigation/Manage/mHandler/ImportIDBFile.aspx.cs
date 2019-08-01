using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using NPOI.SS.UserModel; //-- v.1.2.4起 新增的。
using NPOI.XSSF.UserModel; //-- XSSF 用來產生Excel 2007檔案（.xlsx）
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;

namespace ISTI_CityNavigation.Manage.mHandler
{
    public partial class ImportIDBFile : System.Web.UI.Page
    {
        CitySubMoney_DB csm_db = new CitySubMoney_DB();
        BudgetExecution_DB be_db = new BudgetExecution_DB();
        ServiceSubMoney_DB ssm_db = new ServiceSubMoney_DB();
        CategorySubMoney_DB cgsm_db = new CategorySubMoney_DB();
        CitySummaryTable_DB cst_db = new CitySummaryTable_DB();
        CityPlanTable_DB cpt_db = new CityPlanTable_DB();
        CodeTable_DB ct_db = new CodeTable_DB();
        ImportData_Log idl_db = new ImportData_Log();
        string err = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            ///-----------------------------------------------------
            ///功    能: 匯入工業局資料
            ///說    明:
            /// 
            ///-----------------------------------------------------

            #region 登入判斷
            if (string.IsNullOrEmpty(LogInfo.mGuid))
            {
                Response.Write("<script type='text/JavaScript'>parent.feedbackFun('請重新登入');</script>");
                return;
            }
            #endregion

            /// Transaction
            SqlConnection oConn = new SqlConnection(ConfigurationManager.AppSettings["ConnectionString"].ToString());
            oConn.Open();
            SqlCommand oCmd = new SqlCommand();
            oCmd.Connection = oConn;
            SqlTransaction myTrans = oConn.BeginTransaction();
            oCmd.Transaction = myTrans;
            try
            {
                string token = (string.IsNullOrEmpty(Request["InfoToken"])) ? "" : Request["InfoToken"].ToString().Trim();
                if (Common.VeriftyToken(token))
                {
                    HttpFileCollection uploadFiles = Request.Files;//檔案集合
                    HttpPostedFile aFile = uploadFiles[0];

                    IWorkbook workbook = new XSSFWorkbook(aFile.InputStream);

                    /// 預計經費執行情形
                    DoCitySubMoney(workbook, oConn, myTrans);
                    /// 補助經費縣市分析
                    DoBudgetExecution(workbook, oConn, myTrans);
                    /// 補助經費服務主軸分析
                    DoServiceSubMoney(workbook, oConn, myTrans);
                    /// 補助經費計畫類別分析
                    DoCategorySubMoney(workbook, oConn, myTrans);
                    /// 縣市總表
                    DoCitySummaryTable(workbook, oConn, myTrans);
                    /// 各縣市計畫列表
                    DoCityPlanTable(workbook, oConn, myTrans);

                    ///執行到此表示EXCEL資料未出現錯誤，Error Message 清空
                    err = string.Empty;

                    myTrans.Commit();
                    oCmd.Connection.Close();
                    oConn.Close();

                    /// Log
                    idl_db._IDL_Type = "IDB";
                    idl_db._IDL_IP = Common.GetIPv4Address();
                    idl_db._IDL_Description = "狀態：上傳成功";
                    idl_db._IDL_ModId = LogInfo.mGuid;
                    idl_db._IDL_ModName = LogInfo.name;
                    idl_db.addLog();

                    Response.Write("<script type='text/JavaScript'>parent.feedbackFun('上傳成功');</script>");
                }
                else
                {
                    Response.Write("<script type='text/JavaScript'>parent.feedbackFun('網站驗證失敗');</script>");
                }
            }
            catch (Exception ex)
            {
                /// Log
                idl_db._IDL_Type = "IDB";
                idl_db._IDL_IP = Common.GetIPv4Address();
                idl_db._IDL_Description = "狀態：上傳失敗<br>" + err + "<br>錯誤訊息：" + ex.Message;
                idl_db._IDL_ModId = LogInfo.mGuid;
                idl_db._IDL_ModName = LogInfo.name;
                idl_db.addLog();

                /// Rollback Data
                myTrans.Rollback();
                Response.Write("<script type='text/JavaScript'>parent.feedbackFun('" + err + "<br>錯誤訊息：" + ex.Message.Replace("'", "") + "<br>(欄位名稱請參考上傳範例檔)');</script>");
            }
        }

        #region 執行各Sheet匯入

        #region 預計經費執行情形
        private void DoBudgetExecution(IWorkbook workbook, SqlConnection oConn, SqlTransaction myTrans)
        {
            ISheet sheet = workbook.GetSheetAt(0);
            /// 抓最大版次+1
            int maxV = be_db.getMaxVersion() + 1;
            DataTable dt = CreateBudgetExecution();
            /// 資料從第3欄開始
            for (int i = 2; i < 5; i++)
            {
                err = "Sheet Name：" + sheet.SheetName.Trim() + "<br>";
                err += "欄數：第 " + (i + 1).ToString() + " 欄";
                DataRow row = dt.NewRow();
                row["B_Year"] = sheet.GetRow(1).GetCell(i).ToString().Trim().Replace("年度", "");
                row["B_Commission"] = sheet.GetRow(2).GetCell(i).ToString().Trim();
                row["B_Subsidy"] = sheet.GetRow(3).GetCell(i).ToString().Trim();
                row["B_Sub01"] = sheet.GetRow(5).GetCell(i).ToString().Trim();
                row["B_Sub02"] = sheet.GetRow(6).GetCell(i).ToString().Trim();
                row["B_Sub03"] = sheet.GetRow(7).GetCell(i).ToString().Trim();
                row["B_RemainBudget"] = sheet.GetRow(8).GetCell(i).ToString().Trim();
                row["B_Rate"] = sheet.GetRow(9).GetCell(i).ToString().Trim();
                row["B_CreateId"] = LogInfo.mGuid;
                row["B_CreateName"] = LogInfo.name;
                row["B_Version"] = maxV;
                row["B_Status"] = "A";
                dt.Rows.Add(row);
            }
            if (dt.Rows.Count > 0)
            {
                be_db.BeforeBulkCopy(oConn, myTrans); // update old data set status='D'
                be_db.DoBulkCopy(dt, myTrans);
            }
        }
        #endregion

        #region 補助經費縣市分析
        private void DoCitySubMoney(IWorkbook workbook, SqlConnection oConn, SqlTransaction myTrans)
        {
            ISheet sheet = workbook.GetSheetAt(1);
            /// 抓最大版次+1
            int maxV = csm_db.getMaxVersion() + 1;
            DataTable dt = CreateCitySubMoney();
            /// 資料從第3筆開始
            for (int i = 2; i < sheet.PhysicalNumberOfRows - 1; i++)
            {
                err = "Sheet Name：" + sheet.SheetName.Trim() + "<br>";
                err += "行數：第 " + (i + 1).ToString() + " 筆";
                DataRow row = dt.NewRow();
                row["C_City"] = sheet.GetRow(i).GetCell(0).ToString().Trim();
                row["C_PlanCount_NotAll"] = sheet.GetRow(i).GetCell(1).ToString().Trim();
                row["C_SubMoney_NotAll"] = sheet.GetRow(i).GetCell(2).ToString().Trim();
                row["C_PlanMoney_NotAll"] = sheet.GetRow(i).GetCell(3).ToString().Trim();
                row["C_AssignSubMoney"] = sheet.GetRow(i).GetCell(4).ToString().Trim();
                row["C_AssignTotalMoney"] = sheet.GetRow(i).GetCell(5).ToString().Trim();
                row["C_CitySubMoneyRatio_NotAll"] = sheet.GetRow(i).GetCell(6).ToString().Trim();
                row["C_CityTotalMoneyRatio_NotAll"] = sheet.GetRow(i).GetCell(7).ToString().Trim();
                row["C_PlanCount"] = sheet.GetRow(i).GetCell(8).ToString().Trim();
                row["C_SubMoney"] = sheet.GetRow(i).GetCell(9).ToString().Trim();
                row["C_PlanMoney"] = sheet.GetRow(i).GetCell(10).ToString().Trim();
                row["C_CitySubMoneyRatio"] = sheet.GetRow(i).GetCell(11).ToString().Trim();
                row["C_CityTotalMoneyRatio"] = sheet.GetRow(i).GetCell(12).ToString().Trim();
                row["C_CreateId"] = LogInfo.mGuid;
                row["C_CreateName"] = LogInfo.name;
                row["C_Version"] = maxV;
                row["C_Status"] = "A";
                dt.Rows.Add(row);
            }
            if (dt.Rows.Count > 0)
            {
                csm_db.BeforeBulkCopy(oConn, myTrans); // update old data set status='D'
                csm_db.DoBulkCopy(dt, myTrans);
            }
        }
        #endregion

        #region 補助經費服務主軸分析
        private void DoServiceSubMoney(IWorkbook workbook, SqlConnection oConn, SqlTransaction myTrans)
        {
            ISheet sheet = workbook.GetSheetAt(2);
            /// 抓最大版次+1
            int maxV = ssm_db.getMaxVersion() + 1;
            DataTable dt = CreateServiceSubMoney();
            /// 資料從第3筆開始
            for (int i = 2; i < sheet.PhysicalNumberOfRows; i++)
            {
                err = "Sheet Name：" + sheet.SheetName.Trim() + "<br>";
                err += "行數：第 " + (i + 1).ToString() + " 筆";
                DataRow row = dt.NewRow();
                row["S_Type"] = sheet.GetRow(i).GetCell(0).ToString().Trim();
                row["S_PlanCount"] = sheet.GetRow(i).GetCell(1).ToString().Trim();
                row["S_Subsidy"] = sheet.GetRow(i).GetCell(2).ToString().Trim();
                row["S_TotalMoney"] = sheet.GetRow(i).GetCell(3).ToString().Trim();
                row["S_SubsidyRatio"] = sheet.GetRow(i).GetCell(4).ToString().Trim();
                row["S_TotalMoneyRatio"] = sheet.GetRow(i).GetCell(5).ToString().Trim();
                row["S_CreateId"] = LogInfo.mGuid;
                row["S_CreateName"] = LogInfo.name;
                row["S_Version"] = maxV;
                row["S_Status"] = "A";
                dt.Rows.Add(row);
            }
            if (dt.Rows.Count > 0)
            {
                ssm_db.BeforeBulkCopy(oConn, myTrans); // update old data set status='D'
                ssm_db.DoBulkCopy(dt, myTrans);
            }
        }
        #endregion

        #region 補助經費計畫類別分析
        private void DoCategorySubMoney(IWorkbook workbook, SqlConnection oConn, SqlTransaction myTrans)
        {
            ISheet sheet = workbook.GetSheetAt(3);
            /// 抓最大版次+1
            int maxV = cgsm_db.getMaxVersion() + 1;
            DataTable dt = CreateCategorySubMoney();
            /// 資料從第3筆開始
            for (int i = 2; i < sheet.PhysicalNumberOfRows; i++)
            {
                err = "Sheet Name：" + sheet.SheetName.Trim() + "<br>";
                err += "行數：第 " + (i + 1).ToString() + " 筆";
                DataRow row = dt.NewRow();
                row["C_Type"] = sheet.GetRow(i).GetCell(0).ToString().Trim();
                row["C_PlanCount"] = sheet.GetRow(i).GetCell(1).ToString().Trim();
                row["C_Subsidy"] = sheet.GetRow(i).GetCell(2).ToString().Trim();
                row["C_TotalMoney"] = sheet.GetRow(i).GetCell(3).ToString().Trim();
                row["C_SubsidyRatio"] = sheet.GetRow(i).GetCell(4).ToString().Trim();
                row["C_TotalMoneyRatio"] = sheet.GetRow(i).GetCell(5).ToString().Trim();
                row["C_CreateId"] = LogInfo.mGuid;
                row["C_CreateName"] = LogInfo.name;
                row["C_Version"] = maxV;
                row["C_Status"] = "A";
                dt.Rows.Add(row);
            }
            if (dt.Rows.Count > 0)
            {
                cgsm_db.BeforeBulkCopy(oConn, myTrans); // update old data set status='D'
                cgsm_db.DoBulkCopy(dt, myTrans);
            }
        }
        #endregion

        #region 縣市總表
        private void DoCitySummaryTable(IWorkbook workbook, SqlConnection oConn, SqlTransaction myTrans)
        {
            ISheet sheet = workbook.GetSheetAt(4);
            /// 抓最大版次+1
            int maxV = cst_db.getMaxVersion() + 1;
            DataTable dt = CreateCitySummaryTable();
            /// 資料從第3筆開始
            for (int i = 2; i < sheet.PhysicalNumberOfRows-1; i++)
            {
                err = "Sheet Name：" + sheet.SheetName.Trim() + "<br>";
                err += "行數：第 " + (i + 1).ToString() + " 筆";
                DataRow row = dt.NewRow();
                row["CS_PlanSchedule"] = sheet.GetRow(i).GetCell(0).ToString().Trim();
                row["CS_No"] = sheet.GetRow(i).GetCell(1).ToString().Trim();
                row["CS_PlanType"] = sheet.GetRow(i).GetCell(2).ToString().Trim();
                row["CS_PlanTypeDetail"] = sheet.GetRow(i).GetCell(3).ToString().Trim();
                row["CS_CaseNo"] = sheet.GetRow(i).GetCell(4).ToString().Trim();
                row["CS_HostCompany"] = sheet.GetRow(i).GetCell(5).ToString().Trim();
                row["CS_JointCompany"] = sheet.GetRow(i).GetCell(6).ToString().Trim();
                row["CS_PlanName"] = sheet.GetRow(i).GetCell(7).ToString().Trim();
                row["CS_PlanSummary"] = sheet.GetRow(i).GetCell(8).ToString().Trim();
                row["CS_PlanDefect"] = sheet.GetRow(i).GetCell(9).ToString().Trim();
                row["CS_NowResult"] = sheet.GetRow(i).GetCell(10).ToString().Trim();
                row["CS_DoneResult"] = sheet.GetRow(i).GetCell(11).ToString().Trim();
                row["CS_ServiceArea"] = sheet.GetRow(i).GetCell(12).ToString().Trim();
                row["CS_ServiceType"] = sheet.GetRow(i).GetCell(13).ToString().Trim();
                row["CS_AllArea"] = sheet.GetRow(i).GetCell(14).ToString().Trim();
                row["CS_CityArea"] = sheet.GetRow(i).GetCell(15).ToString().Trim();
                row["CS_CityAreaDetail"] = sheet.GetRow(i).GetCell(16).ToString().Trim();
                row["CS_PlanTotalMoney"] = sheet.GetRow(i).GetCell(17).ToString().Trim();
                row["CS_PlanSubMoney"] = sheet.GetRow(i).GetCell(18).ToString().Trim();
                row["CS_NewTaipei_Total"] = sheet.GetRow(i).GetCell(19).ToString().Trim();
                row["CS_Taipei_Total"] = sheet.GetRow(i).GetCell(20).ToString().Trim();
                row["CS_Taoyuan_Total"] = sheet.GetRow(i).GetCell(21).ToString().Trim();
                row["CS_Taichung_Total"] = sheet.GetRow(i).GetCell(22).ToString().Trim();
                row["CS_Tainan_Total"] = sheet.GetRow(i).GetCell(23).ToString().Trim();
                row["CS_Kaohsiung_Total"] = sheet.GetRow(i).GetCell(24).ToString().Trim();
                row["CS_Yilan_Total"] = sheet.GetRow(i).GetCell(25).ToString().Trim();
                row["CS_HsinchuCounty_Total"] = sheet.GetRow(i).GetCell(26).ToString().Trim();
                row["CS_Miaoli_Total"] = sheet.GetRow(i).GetCell(27).ToString().Trim();
                row["CS_Changhua_Total"] = sheet.GetRow(i).GetCell(28).ToString().Trim();
                row["CS_Nantou_Total"] = sheet.GetRow(i).GetCell(29).ToString().Trim();
                row["CS_Yunlin_Total"] = sheet.GetRow(i).GetCell(30).ToString().Trim();
                row["CS_ChiayiCounty_Total"] = sheet.GetRow(i).GetCell(31).ToString().Trim();
                row["CS_Pingtung_Total"] = sheet.GetRow(i).GetCell(32).ToString().Trim();
                row["CS_Taitung_Total"] = sheet.GetRow(i).GetCell(33).ToString().Trim();
                row["CS_Hualien_Total"] = sheet.GetRow(i).GetCell(34).ToString().Trim();
                row["CS_Penghu_Total"] = sheet.GetRow(i).GetCell(35).ToString().Trim();
                row["CS_Keelung_Total"] = sheet.GetRow(i).GetCell(36).ToString().Trim();
                row["CS_HsinchuCity_Total"] = sheet.GetRow(i).GetCell(37).ToString().Trim();
                row["CS_ChiayiCity_Total"] = sheet.GetRow(i).GetCell(38).ToString().Trim();
                row["CS_Kinmen_Total"] = sheet.GetRow(i).GetCell(39).ToString().Trim();
                row["CS_Lienchiang_Total"] = sheet.GetRow(i).GetCell(40).ToString().Trim();
                row["CS_NewTaipei_Sub"] = sheet.GetRow(i).GetCell(41).ToString().Trim();
                row["CS_Taipei_Sub"] = sheet.GetRow(i).GetCell(42).ToString().Trim();
                row["CS_Taoyuan_Sub"] = sheet.GetRow(i).GetCell(43).ToString().Trim();
                row["CS_Taichung_Sub"] = sheet.GetRow(i).GetCell(44).ToString().Trim();
                row["CS_Tainan_Sub"] = sheet.GetRow(i).GetCell(45).ToString().Trim();
                row["CS_Kaohsiung_Sub"] = sheet.GetRow(i).GetCell(46).ToString().Trim();
                row["CS_Yilan_Sub"] = sheet.GetRow(i).GetCell(47).ToString().Trim();
                row["CS_HsinchuCounty_Sub"] = sheet.GetRow(i).GetCell(48).ToString().Trim();
                row["CS_Miaoli_Sub"] = sheet.GetRow(i).GetCell(49).ToString().Trim();
                row["CS_Changhua_Sub"] = sheet.GetRow(i).GetCell(50).ToString().Trim();
                row["CS_Nantou_Sub"] = sheet.GetRow(i).GetCell(51).ToString().Trim();
                row["CS_Yunlin_Sub"] = sheet.GetRow(i).GetCell(52).ToString().Trim();
                row["CS_ChiayiCounty_Sub"] = sheet.GetRow(i).GetCell(53).ToString().Trim();
                row["CS_Pingtung_Sub"] = sheet.GetRow(i).GetCell(54).ToString().Trim();
                row["CS_Taitung_Sub"] = sheet.GetRow(i).GetCell(55).ToString().Trim();
                row["CS_Hualien_Sub"] = sheet.GetRow(i).GetCell(56).ToString().Trim();
                row["CS_Penghu_Sub"] = sheet.GetRow(i).GetCell(57).ToString().Trim();
                row["CS_Keelung_Sub"] = sheet.GetRow(i).GetCell(58).ToString().Trim();
                row["CS_HsinchuCity_Sub"] = sheet.GetRow(i).GetCell(59).ToString().Trim();
                row["CS_ChiayiCity_Sub"] = sheet.GetRow(i).GetCell(60).ToString().Trim();
                row["CS_Kinmen_Sub"] = sheet.GetRow(i).GetCell(61).ToString().Trim();
                row["CS_Lienchiang_Sub"] = sheet.GetRow(i).GetCell(62).ToString().Trim();
                row["CS_CreateId"] = LogInfo.mGuid;
                row["CS_CreateName"] = LogInfo.name;
                row["CS_Version"] = maxV;
                row["CS_Status"] = "A";
                dt.Rows.Add(row);
            }
            if (dt.Rows.Count > 0)
            {
                cst_db.BeforeBulkCopy(oConn, myTrans); // update old data set status='D'
                cst_db.DoBulkCopy(dt, myTrans);
            }
        }
        #endregion

        #region 各縣市計畫列表
        private void DoCityPlanTable(IWorkbook workbook, SqlConnection oConn, SqlTransaction myTrans)
        {
            /// 查詢縣市代碼
            DataTable CodeDt = ct_db.getCommonCode("02");
            /// 建立縣市計畫 DataTable
            DataTable dt = CreateCityPlanTable();
            for (int CitySheet = 5; CitySheet < 27; CitySheet++)
            {
                ISheet sheet = workbook.GetSheetAt(CitySheet);
                string CityCode = Common.GetCityCodeItem(CodeDt, sheet.SheetName.Trim());
                /// 抓最大版次+1
                int maxV = cpt_db.getMaxVersion(CityCode) + 1;
                /// 資料從第3筆開始
                for (int i = 1; i < sheet.PhysicalNumberOfRows; i++)
                {
                    err = "Sheet Name：" + sheet.SheetName.Trim() + "<br>";
                    err += "行數：第 " + (i + 1).ToString() + " 筆";
                    DataRow row = dt.NewRow();
                    row["CP_City"] = sheet.SheetName.Trim();
                    row["CP_CityCode"] = CityCode;
                    row["CP_PlanSchedule"] = sheet.GetRow(i).GetCell(0).ToString().Trim();
                    row["CP_No"] = sheet.GetRow(i).GetCell(1).ToString().Trim();
                    row["CP_PlanType"] = sheet.GetRow(i).GetCell(2).ToString().Trim();
                    row["CP_PlanTypeDetail"] = sheet.GetRow(i).GetCell(3).ToString().Trim();
                    row["CP_CaseNo"] = sheet.GetRow(i).GetCell(4).ToString().Trim();
                    row["CP_HostCompany"] = sheet.GetRow(i).GetCell(5).ToString().Trim();
                    row["CP_JointCompany"] = sheet.GetRow(i).GetCell(6).ToString().Trim();
                    row["CP_PlanName"] = sheet.GetRow(i).GetCell(7).ToString().Trim();
                    row["CP_PlanSummary"] = sheet.GetRow(i).GetCell(8).ToString().Trim();
                    row["CP_PlanDefect"] = sheet.GetRow(i).GetCell(9).ToString().Trim();
                    row["CP_NowResult"] = sheet.GetRow(i).GetCell(10).ToString().Trim();
                    row["CP_DoneResult"] = sheet.GetRow(i).GetCell(11).ToString().Trim();
                    row["CP_ServiceArea"] = sheet.GetRow(i).GetCell(12).ToString().Trim();
                    row["CP_ServiceType"] = sheet.GetRow(i).GetCell(13).ToString().Trim();
                    row["CP_AllArea"] = sheet.GetRow(i).GetCell(14).ToString().Trim();
                    row["CP_CityArea"] = sheet.GetRow(i).GetCell(15).ToString().Trim();
                    row["CP_CityAreaDetail"] = sheet.GetRow(i).GetCell(16).ToString().Trim();
                    row["CP_PlanTotalMoney"] = sheet.GetRow(i).GetCell(17).ToString().Trim();
                    row["CP_PlanSubMoney"] = sheet.GetRow(i).GetCell(18).ToString().Trim();
                    row["CP_CityTotalMoney"] = sheet.GetRow(i).GetCell(19).ToString().Trim();
                    row["CP_CitySubMoney"] = sheet.GetRow(i).GetCell(20).ToString().Trim();
                    row["CP_CreateId"] = LogInfo.mGuid;
                    row["CP_CreateName"] = LogInfo.name;
                    row["CP_Version"] = maxV;
                    row["CP_Status"] = "A";
                    dt.Rows.Add(row);
                }
            }

            if (dt.Rows.Count > 0)
            {
                cpt_db.BeforeBulkCopy(oConn, myTrans); // update old data set status='D'
                cpt_db.DoBulkCopy(dt, myTrans);
            }
        }
        #endregion

        #endregion

        #region 建立DataTable

        #region BudgetExecution
        private DataTable CreateBudgetExecution()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("B_Year", typeof(string)).MaxLength = 5;
            dt.Columns.Add("B_Commission", typeof(string)).MaxLength = 50;
            dt.Columns.Add("B_Subsidy", typeof(string)).MaxLength = 50;
            dt.Columns.Add("B_Sub01", typeof(string)).MaxLength = 50;
            dt.Columns.Add("B_Sub02", typeof(string)).MaxLength = 50;
            dt.Columns.Add("B_Sub03", typeof(string)).MaxLength = 50;
            dt.Columns.Add("B_RemainBudget", typeof(string)).MaxLength = 50;
            dt.Columns.Add("B_Rate", typeof(string)).MaxLength = 50;
            dt.Columns.Add("B_CreateId", typeof(string));
            dt.Columns.Add("B_CreateName", typeof(string));
            dt.Columns.Add("B_Version", typeof(Int32));
            dt.Columns.Add("B_Status", typeof(string));
            return dt;
        }
        #endregion

        #region ServiceSubMoney
        private DataTable CreateServiceSubMoney()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("S_Type", typeof(string)).MaxLength = 10;
            dt.Columns.Add("S_PlanCount", typeof(string)).MaxLength = 10;
            dt.Columns.Add("S_Subsidy", typeof(string)).MaxLength = 50;
            dt.Columns.Add("S_TotalMoney", typeof(string)).MaxLength = 50;
            dt.Columns.Add("S_SubsidyRatio", typeof(string)).MaxLength = 50;
            dt.Columns.Add("S_TotalMoneyRatio", typeof(string)).MaxLength = 50;
            dt.Columns.Add("S_CreateId", typeof(string));
            dt.Columns.Add("S_CreateName", typeof(string));
            dt.Columns.Add("S_Version", typeof(Int32));
            dt.Columns.Add("S_Status", typeof(string));
            return dt;
        }
        #endregion

        #region CategorySubMoney
        private DataTable CreateCategorySubMoney()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("C_Type", typeof(string)).MaxLength = 10;
            dt.Columns.Add("C_PlanCount", typeof(string)).MaxLength = 10;
            dt.Columns.Add("C_Subsidy", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_TotalMoney", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_SubsidyRatio", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_TotalMoneyRatio", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_CreateId", typeof(string));
            dt.Columns.Add("C_CreateName", typeof(string));
            dt.Columns.Add("C_Version", typeof(Int32));
            dt.Columns.Add("C_Status", typeof(string));
            return dt;
        }
        #endregion

        #region CitySummaryTable
        private DataTable CreateCitySummaryTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("CS_PlanSchedule", typeof(string)).MaxLength = 10;
            dt.Columns.Add("CS_No", typeof(string)).MaxLength = 10;
            dt.Columns.Add("CS_PlanType", typeof(string)).MaxLength = 10;
            dt.Columns.Add("CS_PlanTypeDetail", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_CaseNo", typeof(string)).MaxLength = 12;
            dt.Columns.Add("CS_HostCompany", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_JointCompany", typeof(string));
            dt.Columns.Add("CS_PlanName", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_PlanSummary", typeof(string));
            dt.Columns.Add("CS_PlanDefect", typeof(string));
            dt.Columns.Add("CS_NowResult", typeof(string));
            dt.Columns.Add("CS_DoneResult", typeof(string));
            dt.Columns.Add("CS_ServiceArea", typeof(string)).MaxLength = 200;
            dt.Columns.Add("CS_ServiceType", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_AllArea", typeof(string)).MaxLength = 5;
            dt.Columns.Add("CS_CityArea", typeof(string)).MaxLength = 200;
            dt.Columns.Add("CS_CityAreaDetail", typeof(string));
            dt.Columns.Add("CS_PlanTotalMoney", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_PlanSubMoney", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_NewTaipei_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Taipei_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Taoyuan_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Taichung_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Tainan_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Kaohsiung_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Yilan_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_HsinchuCounty_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Miaoli_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Changhua_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Nantou_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Yunlin_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_ChiayiCounty_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Pingtung_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Taitung_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Hualien_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Penghu_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Keelung_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_HsinchuCity_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_ChiayiCity_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Kinmen_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Lienchiang_Total", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_NewTaipei_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Taipei_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Taoyuan_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Taichung_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Tainan_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Kaohsiung_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Yilan_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_HsinchuCounty_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Miaoli_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Changhua_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Nantou_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Yunlin_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_ChiayiCounty_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Pingtung_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Taitung_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Hualien_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Penghu_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Keelung_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_HsinchuCity_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_ChiayiCity_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Kinmen_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_Lienchiang_Sub", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CS_CreateId", typeof(string));
            dt.Columns.Add("CS_CreateName", typeof(string));
            dt.Columns.Add("CS_Version", typeof(Int32));
            dt.Columns.Add("CS_Status", typeof(string));
            return dt;
        }
        #endregion

        #region CityPlanTable
        private DataTable CreateCityPlanTable()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("CP_City", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CP_CityCode", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CP_PlanSchedule", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CP_No", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CP_PlanType", typeof(string)).MaxLength = 10;
            dt.Columns.Add("CP_PlanTypeDetail", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CP_CaseNo", typeof(string)).MaxLength = 12;
            dt.Columns.Add("CP_HostCompany", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CP_JointCompany", typeof(string));
            dt.Columns.Add("CP_PlanName", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CP_PlanSummary", typeof(string));
            dt.Columns.Add("CP_PlanDefect", typeof(string));
            dt.Columns.Add("CP_NowResult", typeof(string));
            dt.Columns.Add("CP_DoneResult", typeof(string));
            dt.Columns.Add("CP_ServiceArea", typeof(string)).MaxLength = 200;
            dt.Columns.Add("CP_ServiceType", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CP_AllArea", typeof(string)).MaxLength = 5;
            dt.Columns.Add("CP_CityArea", typeof(string)).MaxLength = 200;
            dt.Columns.Add("CP_CityAreaDetail", typeof(string));
            dt.Columns.Add("CP_PlanTotalMoney", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CP_PlanSubMoney", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CP_CityTotalMoney", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CP_CitySubMoney", typeof(string)).MaxLength = 50;
            dt.Columns.Add("CP_CreateId", typeof(string));
            dt.Columns.Add("CP_CreateName", typeof(string));
            dt.Columns.Add("CP_Version", typeof(Int32));
            dt.Columns.Add("CP_Status", typeof(string));
            return dt;
        }
        #endregion

        #region CitySubMoney
        private DataTable CreateCitySubMoney()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("C_City", typeof(string)).MaxLength = 10;
            dt.Columns.Add("C_PlanCount_NotAll", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_SubMoney_NotAll", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_PlanMoney_NotAll", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_AssignSubMoney", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_AssignTotalMoney", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_CitySubMoneyRatio_NotAll", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_CityTotalMoneyRatio_NotAll", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_PlanCount", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_SubMoney", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_PlanMoney", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_CitySubMoneyRatio", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_CityTotalMoneyRatio", typeof(string)).MaxLength = 50;
            dt.Columns.Add("C_CreateId", typeof(string));
            dt.Columns.Add("C_CreateName", typeof(string));
            dt.Columns.Add("C_Version", typeof(Int32));
            dt.Columns.Add("C_Status", typeof(string));
            return dt;
        }
        #endregion

        #endregion
    }
}